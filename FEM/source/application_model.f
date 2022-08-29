      subroutine application_model(ar, Er, u10, avetemp, pH, p1,
     2 pD1, pD2, DmC, Ci, Irate, It, Ip, Vt0, Mtan0, Vt_new, Mtan_new,
     3 test_mode, Vt_remain, Mtan_remain, infiltration_total, 
     4 hourly_emissions, anim_type)


      implicit none

c     input parameters
      real ar           ! fouled surface area
      real Er           ! evaporation event
      real u10          ! windspeed at 10 meters
      real avetemp(24)  ! average hourly temperature profile
      real pH           ! pH of manure in storage
      real urea_halflife ! half-life of urea
      real p1           ! tuned resistance for application
      real pD1, pD2     ! tuned parameters for dry matter content
      real DmC          ! dry matter content, fraction
      real Ci           ! crop interception, fraction
      real Ir, Irate    ! infiltration rate, cm/hr
      real It           ! time to incorporation, hours
      real Ip           ! incorporation percent, fraction
      real Vt0          ! initial volume
      real Mtan0        ! initial TAN
      real Vt_new       ! newly applied volume
      real Mtan_new     ! newly applied mass of TAN
      real test_mode    ! set to 0 for accurate execution

c     output paramaters
      real Vt_remain    ! remaining volume for next day
      real Mtan_remain  ! remaining TAN for next day
      real infiltration ! TAN lost to infiltration each hour
      real infiltration_total  ! total TANt
      real emission     ! NH3 emissions
      real hourly_emissions(24) ! hourly emissions of NH3
      character*10 anim_type ! animal type

      real Mtan_remain1, Mtan_remain2 ! for crust and no crust cases

c     local variables
      real T            ! current temperature
      real Kh           ! Henry's law constant
      real Ka           ! dissociation constant
      real Kw           ! dissociation of water
      real Hconc        ! concentration of H+
      real A            ! area
      real Hstar        ! effective Henry's Law
      real Cut          ! convert urea to TAN
      real dt           ! timestep

      double precision C1, C2, C3, C4 ! constants of integration

      real hourly_infiltration(24)  ! test variables
      real hourly_tan(24)   
      real hourly_vol(24)
      integer i


      real kvk           ! von Karmans constant
      real z0            ! height of surface roughness (meters)
      real ustar         ! frictional wind velocity
      real yl            ! effective length
      real lbh           ! boundry layer height
      real ra            ! aerodynamic resistance
      real rb            ! quasi-laminar resistance
      real rc            ! tuned resistance
      real r             ! resistance
                         ! 1 = no crust, 2 = crust
      real ci_tan, ci_vol ! manages distribution of crop interception


C       print *,  ar, Er, u10, avetemp, pH, p1,
C     2 pD1, pD2, DmC, Ci, Ir, It, Ip, Vt0, Mtan0, Vt_new, Mtan_new,
C     3 test_mode, Vt_remain, Mtan_remain, infiltration, 
C     4 hourly_emissions


      A = ar  
      Vt_new = Vt_new / 1000
      Vt0 = Vt0 / 1000
      Hconc = 10**(-pH)
      Kw = 10.0**14.0
      Cut = 2.0 * 18.0 / 60.0 ! 2 * molecular weight of TAN over urea

c     calculate infiltration rate as a function 
c     of dry matter content
      Ir  = Irate * 10.0**(pD1 + pD2 * DmC)
      if (Ir.lt.(10.0**(-6.0))) then
         Ir = 10.0**(-6.0)
      endif

c     calculate crop interception per hour
c     all of the intercepted TAN volatilizes
      ci_tan = (ci * Mtan_new) / 12
      ci_vol = (ci * Vt_new) / 12
c     remove intercepted and incorporated manure from system
c     and divide by hours applied
      Mtan_new = (Mtan_new * (1 - ci - Ip)) / 12
      Vt_new = (Vt_new * (1 - ci - Ip)) / 12

      do i = 1,24

         dt = 1 ! hours in a timestep
         T = avetemp(i) + 273.15
         Kh = 10**(-1.69+(1477.7/(T)))
         Ka = (10**-(0.09018+(2729.92/T)))
         Hstar = Ka/(((1+1/Kh)*Ka+Hconc)*Kh)

c        calculate resistance

         kvk = 0.4   ! von Karmans constant
         z0 = 0.001  ! height of surface roughness (meters)
c        frictional wind velocity (meters/second)
         ustar = (u10 * kvk) / (log (10/z0)) 
         yl = 2.89             ! length of slurry container (meters)
         lbh = 0.071           ! boundry layer height (meters)

c        Aerodynamic resistance, (days/meter)
         ra = log(lbh / z0) / (kvk * ustar) / (60*60) 

c        Quasi-laminar resistance, (days/meter)
         rb =  (6.2*ustar**-0.67) / (60*60) 
    
         rc = p1*24
         r = ra + rb + rc*(10.0**(-3.0))
         if(anim_type=='swine') then
             r = ra + rb + rc*(10.0**(6.0))  ! Swine-specific eq
         end if

c     time to apply 
         if ((i.ge.6).and.(i.le.17)) then
            Vt0 = Vt0 + Vt_new
            Mtan0 = Mtan0 + Mtan_new            
         endif

         C4 = Vt0
         if (C4 .le. 0) then
            C3 = 0
         else
            C3 = Mtan0 / exp(Hstar/r*(log(C4)/(Er+Ir))+
     2           Ir*log(C4)/(Er+Ir))
         endif

         C2 = -1 * (Ir*A*C3/(Hstar+Ir*r)*r*(Er+Ir)/(-A*Er-A*Ir)*
     2        (C4)**((Hstar+Ir*r)/r/(Er+Ir)))
         C1 = -1 * (Hstar*A*C3/(Hstar+Ir*r)*(Er+Ir)/(-A*Er-A*Ir)*
     2        (C4)**((Hstar+Ir*r)/r/(Er+Ir)))
    
         Vt_remain = -A*dt*Er-A*dt*Ir+C4

         if ((Vt_remain .lt. 0).and.(i .gt. 0)) then
            dt = C4 / (A*(Er+Ir))
            Vt_remain = 0
            Mtan_remain = 0
            emission = Hstar*A*C3/(Hstar+Ir*r)*(Er+Ir)/(-A*Er-A*Ir)*
     2           (0)**((Hstar+Ir*r)/r/(Er+Ir))+C1
            infiltration = Ir*A*C3/(Hstar+Ir*r)*r*(Er+Ir)/(-A*Er-A*Ir)*
     2           (0)**((Hstar+Ir*r)/r/(Er+Ir))+C2
         else
            dt = 1
            Mtan_remain = C3*exp(-Hstar*A/r*log((-A*Er-A*Ir)*dt+C4)/
     2           (-A*Er-A*Ir)-A*Ir*log((-A*Er-A*Ir)*dt+C4)/(-A*Er-A*Ir))
            emission = Hstar*A*C3/(Hstar+Ir*r)*(Er+Ir)/(-A*Er-A*Ir)*
     2           (-A*dt*Er-A*dt*Ir+C4)**((Hstar+Ir*r)/r/(Er+Ir))+C1
            infiltration = Ir*A*C3/(Hstar+Ir*r)*r*(Er+Ir)/(-A*Er-A*Ir)*
     2           (-A*dt*Er-A*dt*Ir+C4)**((Hstar+Ir*r)/r/(Er+Ir))+C2
        
         endif
         
         if ((i.ge.6).and.(i.le.17)) then

            if(anim_type=='swine') then  ! Swine-specific equation
                hourly_emissions(i) = 0.01* avetemp(i)/15*
     2                      (emission + ci_tan + 5/365/24)
            else if(anim_type=='beef') then   ! Beef-specific equation
                hourly_emissions(i) = emission + ci_tan + 5/365/24  
            else
                hourly_emissions(i) = emission + ci_tan
            end if
            if (hourly_emissions(i).le.0) hourly_emissions(i)=0  ! no negative value
         else
            hourly_emissions(i) = emission
         endif

         infiltration_total = infiltration_total + infiltration

         if (hourly_emissions(i)<0.0) then
            hourly_vol(i) = Vt_remain
            hourly_infiltration(i) = infiltration
            hourly_tan(i) = Mtan_remain
            write(6,'(a,i6,4F15.3)') 'Application: ', i,Vt_remain,
     2         Mtan_remain, infiltration, hourly_emissions(i)
         endif

         Mtan0 = Mtan_remain
         Vt0 = Vt_remain

      enddo        

      Vt_remain = Vt_remain * 1000

      end
