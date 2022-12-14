
      subroutine housing_model(pclean, active_hours, grazing_hours, 
     2 kload, Curea, ar,avetemp, pH, urea_halflife, u10, p1, p2, 
     3 outside, Vt0, Murea0, Mtan0, test_mode, Vt_storage, 
     4 Murea_storage, Mtan_storage, Vt_remain, Murea_remain, 
     5 Mtan_remain, hourly_emissions, anim_type)

c     implicit none

c     input parameters
      real pclean       ! percent volume removed at cleanout
      real active_hours ! total hours spent active
      real grazing_hours ! hours spent grazing
      real kload        ! rate of manure loading (kg / hr)
      real Curea        ! concentration of urea (kg / m**3)
      real ar           ! fouled surface area
      real avetemp(24)  ! average hourly temperature profile
      real pH           ! pH of manure in housing
      real urea_halflife ! half-life of urea
      real u10          ! windspeed at 10 meters
      real p1, p2       ! tuned parameters, 
      real outside      ! not used
      real Vt0          ! initial volume
      real Murea0       ! initial urea
      real Mtan0        ! initial TAN
      real test_mode    ! set to 0 for accurate execution

c     output paramaters
      real Vt_storage   ! volume passed to storage at cleanout
      real Murea_storage ! urea passed to storage at cleanout
      real Mtan_storage ! TAN passed to storage at cleanout
      real Vt_remain    ! remaining volume for next day
      real Murea_remain ! remaining urea for next day
      real Mtan_remain  ! remaining TAN for next day
      real hourly_emissions(24) ! hourly emissions of NH3
      character*10 anim_type ! animal type

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

      real C1, C2, C3   ! constants of integration

      real hourly_urea(24)  ! test variables
      real hourly_tan(24)   
      real hourly_vol(24)
      integer i
      real r   ! resistance

      kurea = log(0.5) / (-1 * urea_halflife)
      A = ar * 1000 ! covert area to get volume from kg -> m**3
      Hconc = 10**(-pH)
      Kw = 10**14
      Cut = 2.0 * 18.0 / 60.0 ! 2 * molecular weight of TAN over urea

      if (grazing_hours.lt.active_hours) then

       do i = 1,24

         T = avetemp(i) + 273.15
         if(anim_type=='layer'.or.anim_type=='broiler') T = 273.15  ! constant Temp. No temp impact

         dt = 1 ! hours in a timestep
         Kh = 10**(-1.69+(1477.7/(T)))
         Ka = (10**-(0.09018+(2729.92/T)))
         Hstar = Ka/(((1+1/Kh)*Ka+Hconc)*Kh)

         if(anim_type=='layer'.or.anim_type=='broiler') then
            T = avetemp(i) + 273.15
            r = (p1 * (1 - p2 * (T-298.15)))
         else if(anim_type=='beef') then
            r = (p1*(T - 298.15) + p2*u10 + 3.0)  ! constant=3s/m (McQuiling thesis)
         else
            r = (p1 * (1 + p2 * (298.15 - T))) * 24
         end if

         if (((i.ge.(12-(active_hours/2)))
     2        .and.(i.lt.(12 - grazing_hours/2)))
     3        .or.((i.ge.(12 + grazing_hours/2))
     4        .and.(i.lt.(12 + active_hours/2)))) then

           Vt0 = Vt0 + kload
            Murea0 = Murea0 + kload * curea

         elseif (i.eq.12+active_hours/2) then

            Vt_storage = Vt0 * (1 - pclean)
            Vt0 = Vt0 * pclean

            Murea_storage = Murea0 * (1 - pclean)
            Murea0 = Murea0 * pclean

            Mtan_storage = Mtan0 * (1 - pclean)
            Mtan0 = Mtan0 * pclean
         endif

         C3 = Vt0
         C2 = Murea0
         C1 = Mtan0 - (kurea*Cut*C2)/(-kurea + Hstar*A/r/C3)
         
         Vt_remain = Vt0 
         Murea_remain = exp(-kurea*dt)*C2
         Mtan_remain = exp(-Hstar*A/r/C3*dt)*kurea*Cut*C2/
     2    (-kurea+Hstar*A/r/C3)*exp(-kurea*dt+Hstar*A/r/C3*dt)+
     3    exp(-Hstar*A/r/C3*dt)*C1


         hourly_emissions(i) = (Murea0 - Murea_remain) * Cut +
     2                         (Mtan0 - Mtan_remain)

         if (hourly_emissions(i)<0.0) then
            hourly_vol(i) = Vt_remain
            hourly_urea(i) = Murea_remain
            hourly_tan(i) = Mtan_remain
c           write(6,'(a,8F15.3)') 'Housing(-):',avetemp(i),Vt_remain,cut,
c     2        Murea0,Murea_remain,Mtan0,Mtan_remain, hourly_emissions(i)
         endif

         Murea0 = Murea_remain
         Mtan0 = Mtan_remain
         Vt0 = Vt_remain

       enddo

      endif

      end
