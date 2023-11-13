
      subroutine storage_model(pclean, Sclean, app_fraction, pcrust, ar,
     2 Er, u10, avetemp, pH, urea_halflife, p1, p2, Vt0, Murea0, 
     3 Mtan0, test_mode, Vt_application, Murea_application, 
     4 Mtan_application, Vt_remain, Murea_remain, Mtan_remain, 
     5 hourly_emissions, anim_type)


      implicit none

c     input parameters
      real pclean       ! percent volume removed at cleanout
      real Sclean       ! 1 = cleanout event 
      real app_fraction ! fraction of storage moved to application
      real pcrust       ! fraction of storage covered in crust
      real ar           ! fouled surface area
      real Er           ! evaporation event
      real u10          ! windspeed at 10 meters
      real avetemp(24)  ! average hourly temperature profile
      real pH           ! pH of manure in storage
      real urea_halflife ! half-life of urea
      real p1           ! tuned resistance for no cover
      real p2           ! tuned resistance for crust 
      real Vt0          ! initial volume
      real Murea0       ! initial urea
      real Mtan0        ! initial TAN
      real test_mode    ! set to 0 for accurate execution

c     output paramaters
      real Vt_application    ! volume passed to storage at cleanout
      real Murea_application ! urea passed to storage at cleanout
      real Mtan_application  ! TAN passed to storage at cleanout
      real Vt_remain    ! remaining volume for next day
      real Murea_remain ! remaining urea for next day
      real Mtan_remain  ! remaining TAN for next day
      real hourly_emissions(24) ! hourly emissions of NH3
      character*10 anim_type  ! animal type

      real Mtan_remain1, Mtan_remain2 ! for crust and no crust cases

c     local variables
      real kurea        ! rate of urea hydrolysis
      real T            ! current temperature
      real Kh           ! Henry's law constant
      real Ka           ! dissociation constant
      real Kw           ! dissociation of water
      real Hconc        ! concentration of H+
      real A            ! area
      real Hstar        ! effective Henry's Law
      real Cut          ! convert urea to TAN
      real dt           ! timestep

      real C1(2), C2, C3 ! constants of integration

      real hourly_urea(24)  ! test variables
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
      real rc(2)         ! tuned resistance
      real r(2)          ! resistance
                         ! 1 = no crust, 2 = crust

      kurea = log(0.5) / (-1 * urea_halflife)
      A = ar * 1000 ! covert area to get volume from kg -> m**3
      Hconc = 10**(-pH)
      Kw = 10**14
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

         if(anim_type=='swine' .or. anim_type=='dairy') then ! Swine-specific temp-dependent eqs
            rc(1) = p1*24*(T/15.0)
            rc(2) = p2*24*(T/15.0)
            r(1) = ra + rb + rc(1)*(10.0**(-2.0))
            r(2) = ra + rb + rc(2)*(10.0**(-2.0))
         else
            rc(1) = p1*24
            rc(2) = p2*24
            r(1) = ra + rb + rc(1)*(10.0**(-3.0))
            r(2) = ra + rb + rc(2)*(10.0**(-3.0))
         end if

         C3 = Vt0
         C2 = Murea0
         C1(1) = Mtan0 - (kurea*Cut*C2)/(-kurea + Hstar*A/r(1)/C3)
         C1(2) = Mtan0 - (kurea*Cut*C2)/(-kurea + Hstar*A/r(2)/C3)
         
         Vt_remain = Vt0 
         Murea_remain = exp(-kurea*dt)*C2

c        Calculate a different remaining tan for crust and no crust
c        resistances.  Combine by fraction with crust
         Mtan_remain1 = exp(-Hstar*A/r(1)/C3*dt)*kurea*Cut*C2/
     2    (-kurea+Hstar*A/r(1)/C3)*exp(-kurea*dt+Hstar*A/r(1)/C3*dt)+
     3    exp(-Hstar*A/r(1)/C3*dt)*C1(1)
         Mtan_remain2 = exp(-Hstar*A/r(2)/C3*dt)*kurea*Cut*C2/
     2    (-kurea+Hstar*A/r(2)/C3)*exp(-kurea*dt+Hstar*A/r(2)/C3*dt)+
     3    exp(-Hstar*A/r(2)/C3*dt)*C1(2)
         Mtan_remain = (1 - pcrust) * Mtan_remain1 + 
     2                  pcrust * Mtan_remain2

         hourly_emissions(i) = (Murea0-Murea_remain) * Cut +
     2                         (Mtan0 - Mtan_remain)

         if (hourly_emissions(i)<0.0) then
            hourly_vol(i) = Vt_remain
            hourly_urea(i) = Murea_remain
            hourly_tan(i) = Mtan_remain
         endif

         Murea0 = Murea_remain
         Mtan0 = Mtan_remain
         Vt0 = Vt_remain

      enddo

      if (Sclean==1) then !  application event 
         Vt_application = Vt_remain * ((1-pclean) * app_fraction)
         Mtan_application = Mtan_remain * ((1-pclean) * app_fraction)
         Murea_application = Murea_remain * ((1-pclean) * app_fraction)
        
         Vt_remain = Vt_remain * (1-((1-pclean) * app_fraction))
         Murea_remain = Murea_remain * (1-((1-pclean) * app_fraction))
         Mtan_remain = Mtan_remain * (1-((1-pclean) * app_fraction))
      else
         Vt_application = 0
         Mtan_application = 0
         Murea_application = 0
      endif
        
      end
