      subroutine model_driver_daily(temps_in, precip_in, wind_in, 
     2     infiltration_rate, farm_type, application_schedule, params,
     3     daily_emissions, anim_type, ndays)

c******
c Exectute the farm model for a complete year
c writen by Rob Pinder, 9/14/2003
c******

      implicit none

c     input parameters
      real temps_in(366)  ! daily average temperature
      real precip_in(366) ! daily average precipitation
      real wind_in(366)      ! daily average windspeed
      real infiltration_rate ! infiltration rate
      integer farm_type(18)     ! array holding farm type information
      real application_schedule(12)  ! fraction of manure 
                                     ! applied each month
      real params(44)    ! input parameters

c     output variables
      real daily_emissions(366,4) ! emissions for each month from 
                                   ! housing, storage, application,
                                   ! and grazing
      character*10 anim_type
      integer ndays

c     variables for submodels
      real pclean        ! percent volume removed at cleanout
      real active_hours  ! total hours active
      real grazing_hours ! hours spent grazing
      real kload         ! rate of manure loading (kg / hr)
      real Curea         ! concentration of urea (kg / m**3)
      real Har           ! fouled surface area for housing
      real Sar           ! storage surface area
      real Aar           ! application surface area
      real Gar           ! grazing surface are
      real avetemp(24)   ! average hourly temperature profile
      real HpH           ! pH of manure in housing
      real SpH           ! pH of manure in storage
      real ApH           ! pH of manure applied
      real GpH           ! pH of grazing manure
      real urea_halflife ! half-life of urea
      real u10           ! windspeed at 10 meters
      real Er            ! evaporation rate
      real Hp1, Hp2      ! tuned parameters for housing
      real Sp1, Sp2      ! storage tuned resistance
      real Ap1           ! tuned application resistance
      real ApD1, ApD2    ! tuned dry matter content function
      real Gp1, Gp2      ! tuned grazing resistance pasture, drylot
      real ACi           ! application crop interception, fraction
      real GCi           ! grazing crop interception, fraction
      real outside       ! not used
      real pcrust        ! fraction storage with crust
      real Sclean        ! application event
      real app_fraction  ! fraction applied
      real DmC           ! dry matter content, fraction
      real Ir            ! infiltration rate
      real It            ! time to incorporation (not used)
      real Ip            ! incorporation percent (not used)
      real HVt0          ! initial housing volume
      real HMurea0       ! initial housing urea
      real HMtan0        ! initial housing TAN
      real SVt0          ! initial storage volume
      real SMurea0       ! initial storage urea
      real SMtan0        ! initial storage TAN
      real AVt0          ! initial application volume
      real AMtan0        ! initial application TAN
      real GVt0          ! initial grazing volume
      real GMurea0       ! initial grazing urea
      real GMtan0        ! initial grazing TAN

      real test_mode     ! set to 0 for accurate execution
      real Cut           ! constant of transfer urea to TAN

      real HVt_storage   ! volume passed to storage at cleanout
      real HMurea_storage ! urea passed to storage at cleanout
      real HMtan_storage ! TAN passed to storage at cleanout
      real HVt_remain    ! remaining volume for next day
      real HMurea_remain ! remaining urea for next day
      real HMtan_remain  ! remaining TAN for next day

      real SVt_application   ! volume passed to application at cleanout
      real SMurea_application ! urea passed to application at cleanout
      real SMtan_application ! TAN passed to application at cleanout
      real SVt_remain    ! remaining storage volume for next day
      real SMurea_remain ! remaining storage urea for next day
      real SMtan_remain  ! remaining storage TAN for next day

      real AVt_new       ! volume to be applied
      real AMtan_new     ! TAN to be applied
      real AVt_remain    ! remaining application volume
      real AMtan_remain  ! remaining application TAN
      real Ainfiltration ! TAN lost to infiltration

      real GVt_remain    ! grazing remaining volume
      real GMurea_remain ! grazingremaining urea 
      real GMtan_remain  ! grazing remaining TAN 
      real Ginfiltration ! TAN lost to grazing infiltration 

      real Hhourly_emissions(24) ! housing hourly emissions of NH3
      real Shourly_emissions(24) ! storage hourly emissions of NH3
      real Ahourly_emissions(24) ! application hourly NH3
      real Ghourly_emissions(24) ! grazing hourly NH3

      real urination_day, urination_hour, volume_urination, volume_hour

c     seasonal variables
      integer i, j, k
      integer month
                              ! 0 = low temps to high 
      integer days(12)        ! days in a month
      integer summer          ! 1 if summer, 0 if not
      integer winter          ! 1 if winter, 0 if not
      real month_temps(366)    ! daily temperature for each day in month

c     precipitation variables
      integer precip_freq     ! frequency of precipitation
      real Sprecip         ! volume to storage from precip
      real Aprecip         ! volume to application from precip
      real Srunoff         ! per runoff area

      real solid_factor       ! emission factor for solid manure

c     total variables
      real Hemission_total, Semission_total
      real Aemission_total, Gemission_total
      real h, s, a, g

c     mass balance variables
      real housing_input, exit_housing, exit_storage ! mass balance
      real housing_balance, storage_balance, application_balance
      real grazing_input, exit_grazing, grazing_balance
      real Ainfiltration_total, Ginfiltration_total

c     farm type variables
      integer confined_summer
      integer confined_winter
      integer pasture
      integer drylot
      integer tiestall
      integer freestall
      integer nohousing
      integer liquid
      integer solid
      integer lagoon
      integer earthbasin
      integer slurrytank
      integer irrigation
      integer injection
      integer trailinghose
      integer broadcast
      integer summer_application
      integer winter_application

c     farm type

      confined_summer = farm_type(1)
      confined_winter = farm_type(2)
      pasture = farm_type(3)
      drylot = farm_type(4)
      tiestall = farm_type(5)
      freestall = farm_type(6)
      nohousing = farm_type(7)
      liquid = farm_type(8)
      solid = farm_type(9)
      lagoon = farm_type(10)
      earthbasin = farm_type(11)
      slurrytank = farm_type(12)        
      irrigation = farm_type(13)
      injection = farm_type(14)
      trailinghose = farm_type(15)
      broadcast = farm_type(16)
      summer_application = farm_type(17)
      winter_application = farm_type(18)

      Cut = 2.0 * 18.0 / 60.0 ! 2 * molecular weight of TAN over urea
      active_hours = 16.0
      urination_day = 10.0
      urination_hour = urination_day / active_hours
      volume_urination = 0.2 ! liters
      volume_hour = volume_urination * urination_hour

      Curea = 0.0168 * params(18) ! kg Urea / liter urine
      kload = volume_hour * params(17)
      urea_halflife = params(12)

      data days /31,60,91,122,153,183,213,244,274,305,335,365/
      days(12) = ndays

      u10 = 1.0
      Er = 10.0**(-5.0)

      pclean = 0.1
      pcrust = params(10)
      test_mode = 0

c     initialize monthly emissions
      daily_emissions = 0 
      
c      precip_freq = 7   ! weekly precipitation
      solid_factor = params(11)

c     Initialize Housing parameters

      outside = 0.0
      HVt0 = 1.0
      HMurea0 = 0.0
      HMtan0 = 0.0

      if (freestall.eq.1) then
         Har = 2.4 * params(20)
      elseif (tiestall.eq.1) then
         Har = 3.3 * params(20)
      else ! no housing
         if (liquid.eq.1) then
            Har = 3.3 * params(20)
         endif
      endif
         
      HpH = params(13)
      Hp1 = params(1)
      Hp2 = params(2)

      HVt_storage = 0.0
      HMurea_storage = 0.0
      HMtan_storage = 0.0
      HVt_remain = 0.0
      HMurea_remain = 0.0
      HMtan_remain = 0.0
      Hhourly_emissions = 0.0
      Hemission_total = 0.0

c     Initialize Storage parameters

      SVt0 = 0.0
      SMurea0 = 0.0
      SMtan0 = 0.0
      Sar = params(21)
      if (slurrytank.eq.1) then
         Sar = 2.8 * params(21)
      elseif (earthbasin.eq.1) then
         Sar = 2.8 * params(21)
      elseif (lagoon.eq.1) then
         Sar = 5.0 * params(21)
      endif

      SpH = params(14)
      
      Sp1 = params(3)
      Sp2 = params(4)

      Srunoff = params(32)   ! area per cow for run off

      SVt_application = 0.0
      SMurea_application = 0.0
      SMtan_application = 0.0
      SVt_remain = 0.0
      SMurea_remain = 0.0
      SMtan_remain = 0.0
      Shourly_emissions = 0.0
      Semission_total = 0.0

      Sclean = 0.0
      app_fraction = 1.0

c     Initialize Application parameters

      AVt0 = 0.0
      AMtan0 = 0.0

      Aar = 1440 * params(22)
      ApH = params(15)
      
      Ap1 = params(5)
      ApD1 = params(6)
      ApD2 = params(7)

      AVt_new = 0.0
      AMtan_new = 0.0
      AVt_remain = 0.0
      AMtan_remain = 0.0
      Ainfiltration = 0.0
      Ahourly_emissions = 0.0
      Aemission_total = 0.0

      It = 0.0
      Ip = 0.0

      if (irrigation.eq.1) then
         ACi = params(24)      ! crop interception percentage
         DmC = params(26)     
      elseif (injection.eq.1) then
         ACi = 0               ! crop interception percentage
         Ip = 0.9
         DmC = params(27)
      elseif (trailinghose.eq.1) then
         ACi = 0               ! crop interception percentage    
         DmC = params(28)    
      elseif(broadcast.eq.1) then
         ACi = params(24)        ! crop interception percentage    
         DmC = params(29)  
      endif

c     Initialize Grazing parameters

      GVt0 = 0.0
      GMurea0 = 0.0
      GMtan0 = 0.0

      Gar = 0.4 * params(23)
      GpH = params(16)
      GCi = params(25)
      
      if (pasture.eq.1) then
         Gp1 = params(8) ! pasture resistance
      else
         Gp1 = params(9) ! drylot resistance
      endif

      GVt_remain = 0.0
      GMurea_remain = 0.0
      GMtan_remain = 0.0
      Ghourly_emissions = 0.0
      Gemission_total = 0.0

c     replace with infiltration rate
      Ir = infiltration_rate * 7.112*10.0**(-5.0) * params(19)

      month = 1
 
      do i = 1, ndays

c     set month
        if(i>days(month)) month = month + 1

        if ((month.le.11).and.(month.ge.5)) then 
           summer = 1
           winter = 0
        else
           summer = 0
           winter = 1
        endif

c       set wind speed
        u10 = wind_in(i)

c       set temperature for each hour in day
        do k = 1,24
           avetemp(k) = temps_in(i)   ! temperature in unit of C
        enddo

c       set precipitation amount
c       precipitation increases volume and reduces emissions
C       for storage, increase by storage and runoff area
        Sprecip = precip_in(i) * (Sar+Srunoff)
C       for application, increase by application area
        Aprecip = precip_in(i) * Aar

c       seasonal application
c       set Sclean = 1 if it is time for application
        Sclean = 0
        app_fraction = 1.0
        if (summer.eq.1) then ! summer application
           if (summer_application.eq.1) then      ! daily
              Sclean = 1
           elseif ((summer_application.eq.2).and. ! weekly
     2             (mod(i,7).eq.3)) then
              Sclean = 1
           elseif ((summer_application.eq.3).and. ! monhthly
     2             (mod(i,15).eq.0)) then
              Sclean = 1
           elseif ((summer_application.eq.4).and. ! seasonally
     2             (mod(i,15).eq.0).and.
     3             (application_schedule(month).gt.0)) then
              Sclean = 1
              app_fraction = application_schedule(month)
           endif
        elseif (winter.eq.1) then ! winter application
           if (winter_application.eq.1) then      ! daily
              Sclean = 1
           elseif ((winter_application.eq.2).and. ! weekly
     2             (mod(i,7).eq.3)) then
              Sclean = 1
           elseif ((winter_application.eq.3).and. ! monhthly
     2             (mod(i,15).eq.0)) then
              Sclean = 1
           elseif ((winter_application.eq.4).and. ! seasonally
     2             (mod(i,15).eq.0).and.
     3             (application_schedule(month).gt.0))  then
              Sclean = 1
              app_fraction = application_schedule(month)
           endif
        endif

c     seasonal grazing

        if ((nohousing.eq.1).and.(liquid.eq.1)) then
           ! animals on the open yard
           confined_summer = 1
           confined_winter = 1
        endif
        
        if ((confined_summer.eq.1).and.(confined_winter.eq.1)) then
           ! animals confined; no grazing
            grazing_hours = 0
        elseif ((confined_winter.eq.1).and.(confined_summer.eq.0)) then
           ! animals are grazing if temperature is greater than 50 F
           ! for the default case, params(31) is the temp for this run
           ! compare with temperature at 10am
            if (avetemp(10).gt.params(31)) then
                grazing_hours = params(30)
            else
                grazing_hours = 0
            endif
        elseif ((confined_winter.eq.0).and.(confined_summer.eq.0)) then
           ! grazing all the time
            if (nohousing.eq.1) then
                grazing_hours = active_hours
            else
                grazing_hours = params(30)
            endif
        elseif ((confined_summer.eq.1).and.(confined_winter.eq.0)) then
           ! only winter grazing
            if (winter.eq.1) then
                grazing_hours = params(30)
            else
                grazing_hours = 0
            endif
        endif

        housing_input = housing_input + 
     2        (volume_urination * urination_day * Curea * Cut * 
     3        ((active_hours - grazing_hours) / active_hours))

        grazing_input = grazing_input + 
     2        ((volume_urination * urination_day * Curea * Cut * 
     3        (grazing_hours / active_hours))) * (avetemp(k))

         call housing_model(pclean, active_hours, grazing_hours, kload, 
     2  Curea, Har, avetemp, HpH, urea_halflife, u10, Hp1, Hp2, outside,
     3  HVt0, HMurea0, HMtan0, test_mode, HVt_storage, HMurea_storage, 
     4  HMtan_storage, HVt_remain, HMurea_remain, HMtan_remain, 
     5  Hhourly_emissions, anim_type)

        HVt0 = HVt_remain
        HMurea0 = HMurea_remain
        HMtan0 = HMtan_remain

        exit_housing=exit_housing+HMurea_storage*Cut+HMtan_storage

        SVt0 = HVt_storage + SVt_remain + Sprecip
        SMurea0 = HMurea_storage + SMurea_remain
        SMtan0 = HMtan_storage + SMtan_remain

        if ((liquid.eq.1).and.(SVt0.gt.0)) then

           call storage_model(pclean, Sclean, app_fraction, pcrust,
     2        Sar, Er, u10, avetemp, SpH, urea_halflife, Sp1, Sp2, 
     3        SVt0, SMurea0, SMtan0, test_mode, SVt_application, 
     4        SMurea_application, SMtan_application, SVt_remain, 
     5        SMurea_remain, SMtan_remain, Shourly_emissions,anim_type)
        else
           do k = 1,24
             if(anim_type=='swine') then  ! solid manure, for feedlot; need to define process
                Shourly_emissions(k) = 0.035 * solid_factor * 
     2             avetemp(k) / 8760.0 + u10 * 0.0035 / 8760.0
             end if
             if(Shourly_emissions(k)<=0.0) Shourly_emissions(k)=0.0
           enddo                
        endif

        exit_storage = exit_storage + SMurea_application * Cut + 
     2                 SMtan_application

        ! if there is manure to be applied, then apply it
        if ((AVt0 + SVt_application).gt.0) then
           AVt_new = SVt_application + Aprecip
           AMtan_new = SMurea_application * Cut + SMtan_application

           call application_model(Aar, Er, u10, avetemp, ApH, Ap1,
     2        ApD1, ApD2, DmC, ACi, Ir, It, Ip, AVt0, AMtan0, AVt_new,
     3        AMtan_new, test_mode, AVt_remain, AMtan_remain, 
     4        Ainfiltration, Ahourly_emissions, anim_type)

           AVt0 = AVt_remain
           AMtan0 = AMtan_remain
           Ainfiltration_total = Ainfiltration_total + Ainfiltration
        else 
           Ainfiltration = 0
           Ahourly_emissions = 0.0
        endif

C.......  NOTE: constant application emissions from cattle beef (3kg/yr)
        if(anim_type=='beef') Ahourly_emissions = 3.0/(ndays*24)

        if ((grazing_hours.gt.0).or.(GMtan_remain.gt.0)) then
         
           GVt0 = GVt_remain
           GMurea0 = GMurea_remain
           GMtan0 = GMtan_remain

           call grazing_model(Gar, Er, u10, avetemp, active_hours, 
     2          grazing_hours, kload, Curea, GpH, urea_halflife, 
     3          Gp1, GCi, Ir, GVt0, GMurea0, GMtan0, test_mode, 
     4          GVt_remain, GMtan_remain, GMurea_remain, Ginfiltration, 
     5          Ghourly_emissions, anim_type)

           Ginfiltration_total = Ginfiltration_total + Ginfiltration
           Ginfiltration =  0
        endif

        a = 0
        h = 0
        s = 0
        g = 0
        do k = 1,24

C          Zero-out negative hourly emissions
C           if( Hhourly_emissions(k)<0.0 ) Hhourly_emissions(k) = 0.0
C           if( Shourly_emissions(k)<0.0 ) Shourly_emissions(k) = 0.0
C           if( Ahourly_emissions(k)<0.0 ) Ahourly_emissions(k) = 0.0
C           if( Ghourly_emissions(k)<0.0 ) Ghourly_emissions(k) = 0.0

           h = h + Hhourly_emissions(k)
           s = s + Shourly_emissions(k)
           a = a + Ahourly_emissions(k)
           g = g + Ghourly_emissions(k)

           daily_emissions(i,1)  = daily_emissions(i,1) + 
     2                             Hhourly_emissions(k)
           daily_emissions(i,2)  = daily_emissions(i,2) + 
     2                             Shourly_emissions(k)
           daily_emissions(i,3)  = daily_emissions(i,3) + 
     2                             Ahourly_emissions(k)
           daily_emissions(i,4)  = daily_emissions(i,4) + 
     2                             Ghourly_emissions(k)
           Hhourly_emissions(k) = 0
           Shourly_emissions(k) = 0
           Ahourly_emissions(k) = 0
           Ghourly_emissions(k) = 0
        enddo

c       compute annual totals
        Hemission_total = Hemission_total + h 
        Semission_total = Semission_total + s
        Aemission_total = Aemission_total + a
        Gemission_total = Gemission_total + g
      enddo

       housing_balance = housing_input - Hemission_total - exit_housing 
     2     - HMtan0 + HMurea0 * Cut

       storage_balance = exit_housing - Semission_total - exit_storage
     2     - SMtan0 + SMurea0 * Cut

       application_balance = exit_storage - Aemission_total 
     2     - AMtan0 - Ainfiltration_total

       grazing_balance = grazing_input - Gemission_total 
     2     - GMtan0 + GMurea0 * Cut - Ginfiltration_total

      end

