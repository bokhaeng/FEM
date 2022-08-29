      subroutine grazing_model(ar, Er, u10, avetemp, active_hours, 
     2 grazing_hours, kload, Curea, pH, urea_halflife, p1, Ci, Ir, 
     3 Vt0, Murea0, Mtan0, test_mode, Vt_remain, Mtan_remain,
     4 Murea_remain, infiltration, hourly_emissions, anim_type)


      implicit none

c     input parameters
      real ar           ! fouled surface area
      real Er           ! evaporation event
      real u10          ! windspeed at 10 meters
      real avetemp(24)  ! average hourly temperature profile
      real active_hours ! hours spent in awake
      real grazing_hours ! hours spent grazing
      real kload        ! rate of manure loading (kg / hr)
      real Curea        ! concentration of urea (kg / m**3)
      real pH           ! pH of manure in storage
      real urea_halflife ! half-life of urea
      real p1           ! tuned resistance for application
      real Ci           ! crop interception, fraction
      real Ir           ! infiltration rate, cm/hr
      real Vt0          ! initial volume
      real Murea0       ! initial urea
      real Mtan0        ! initial TAN
      real test_mode    ! set to 0 for accurate execution

c     output paramaters
      real Vt_remain    ! remaining volume for next day
      real Murea_remain ! remaining urea for next day
      real Mtan_remain  ! remaining TAN for next day
      real infiltration ! TAN lost to infiltration
      real hourly_emissions(24) ! hourly emissions of NH3
      character*10 anim_type ! animal type

c     local variables
      real kurea        ! urea hydrolysis rate constant
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
      real hourly_urea(24)
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

c     variables used for differentation
      integer steps, j
      real t_step
      real dMtan, dMurea, demission, dinfiltration
      real prior_demission
      real prior_dinfiltration
      real prior_dMurea
      real prior_dMtan
      real Vt, Murea, Mtan


      kurea = log(0.5) / (-1 * urea_halflife)
      A = ar  
      Vt0 = Vt0 / 1000
      Hconc = 10**(-pH)
      Kw = 10.0**(14.0)
      Cut = 2.0 * 18.0 / 60.0 ! 2 * molecular weight of TAN over urea

 
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

c     time to let the cows out

         if ((i.ge.(12-(grazing_hours/2)))
     2        .and.(i.lt.(12 + grazing_hours/2))) then
c           increase loading and remove crop interception
            Vt0 = Vt0 + kload * (1 - ci)
            Murea0 = Murea0 + kload * curea * (1 - ci)
            hourly_emissions(i) = (ci * kload * curea * Cut ) *
     2           0.05 * (avetemp(i))
         Else
            hourly_emissions(i) = 0
         endif

         dt = 1

         if ((Vt0-dt*A*Er-dt*A*Ir).lt. 0) then
            dt = Vt0 / (A*(Er+Ir))
         else
            dt = 1
         endif

         t_step = 0.2
         steps = dt * 5


         Vt = Vt0
         Murea = Murea0
         Mtan = Mtan0

         if (steps .gt. 0) then
            prior_dMurea = (-kurea*Murea - Ir*Murea/Vt*A)
            prior_dMtan = (-Hstar*A/r*Mtan/Vt  - Ir*Mtan/Vt*A +
     2           kurea*Murea*Cut)
            prior_demission = (Hstar*A/r*Mtan/Vt)
            prior_dinfiltration = Ir*Mtan/Vt*A + Ir*Murea/Vt*A*Cut
         endif

         do j = 1,steps

            Vt = Vt + (-A*(Er+Ir))*t_step

            if (Vt .le. 0) then
                dMurea = 0
                dMtan = 0
                demission = 0
                dinfiltration = 0
                Vt = 0
                Mtan = 0
                Murea = 0
            else

               dMurea = (-kurea*Murea - Ir*Murea/Vt*A)
               dMtan = (-Hstar*A/r*Mtan/Vt  - Ir*Mtan/Vt*A +
     2              kurea*Murea*Cut)
               demission = (Hstar*A/r*Mtan/Vt)
               dinfiltration = Ir*Mtan/Vt*A + Ir*Murea/Vt*A*Cut

                Murea = Murea + (dMurea + prior_dMurea)/2*t_step
                if (Murea.lt.0) Murea = 0
                Mtan = Mtan + (dMtan + prior_dMtan)/2*t_step
                hourly_emissions(i) = hourly_emissions(i) +
     2               (demission + prior_demission)/2*t_step
                infiltration = infiltration +
     2               (dinfiltration + prior_dinfiltration)/2*t_step

                prior_dMurea = dMurea
                prior_dMtan = dMtan
                prior_demission = demission
                prior_dinfiltration = dinfiltration
            endif

         enddo

         if (hourly_emissions(i)<0.0) then
            hourly_vol(i) = vt_remain
            hourly_infiltration(i) = infiltration
            hourly_tan(i) = Mtan_remain
            write(6,'(a,i6,4F15.3)') 'Grazing: ', i,Vt_remain,
     2         Mtan_remain, infiltration, hourly_emissions(i)
         endif

         Vt0 = Vt
         Murea0 = Murea
         Mtan0 = Mtan

      enddo        

      Vt_remain = Vt * 1000
      Murea_remain = Murea
      Mtan_remain = Mtan

      end
