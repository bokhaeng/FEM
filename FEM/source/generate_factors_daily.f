      subroutine generate_factors_daily(county_filename, farm_filename,  
     2                                  param_filename, anim_type)

      implicit none
     
c     input variables
      character*180 county_filename
      character*180 farm_filename
      character*180 param_filename
      integer iterations ! number of counties
      character*180 farm_ann, farm_mon, farm_day
      character*10  anim_type


c     farm model variables
      real temps(366)
      real precip(366) ! monthly average precipitation
      real wind(366)      ! monthly average windspeed
      real infiltration_rate ! infiltration rate
      integer farm_type(18)     ! array holding farm type information
      real application_schedule(12)  ! fraction of manure 
      real month_jdate (12)  ! julian date for each month 
      real params(44)    ! input parameters
      real daily_emissions(366,4)
      real me(366,4)

c     farm type variables
      integer confined_summer
      integer confined_winter
      integer pasture
      integer drylot
      integer deep_pit
      integer shallow
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

c     farm probabilities
      integer farms            ! number of farm probabilities
      real total_prob          ! total probability of top farms
      real prob, tprob         ! probability of farm configuration

c     climate variables
      integer tstate, tcounty
      
c     file IO variables
      integer fstate_county    ! list of states and counties
      integer ffarm_prob       ! farm types and probabilities 
      integer fclimate         ! climate values
      integer fcow_pop         ! cow population
      integer ffactor_out      ! annual output file
      integer ffactor_mon      ! monthly output file
      integer ffactor_day      ! daily output file
      character*80 line1, line2
      character*180 climate_file, anim_file

c     local variables
      integer i,j,k,l
      integer state            ! current state
      integer county           ! current county
      integer date
      integer d1,d2            ! read in dummy variables
      character*3 string_id    ! used for output file name

c     compute average emission factor
      integer county_cow_pop   ! cow population for county
      integer total_cow_pop    ! total cow population 
      real day_total           ! county daily emission
      real annual_emission     ! county annual emission
      real Hannual_emission     ! county annual emission from housing
      real Sannual_emission     ! county annual emission from storage
      real Aannual_emission     ! county annual emission from application
      real Gannual_emission     ! county annual emission from grazing
      real total_month(12)     ! monthly emissions nationally
      real summer_winter_ratio ! emissions ratio summer / winter
      real county_emission     ! county emissions weighted by cow population
      real total_emission      ! weighted by cow population
      real Mannual,MHannual,MSannual,MAannual,MGannual

      data month_jdate /31,60,91,121,152,182,213,244,274,305,335,366/
c      data month_jdate /31,60,90,120,151,181,212,243,273,304,334,365/

      i = 0
      total_cow_pop = 0
      total_emission = 0


      do k = 1,12
         total_month(k) = 0.0
      enddo

      fstate_county = 18
      ffarm_prob = 17
      fclimate = 11
      fcow_pop = 16
      ffactor_out = 19
      ffactor_day = 20

C.......  loading parameters (default with optional parameter files)
      call load_params(param_filename, params, 44)

C     application_schedule
      if (params(33).eq.0.0) then
         data application_schedule /0.04,0.06,0.36,0.77,0.27,0.24,
     2                              0.18,0.21,0.32,0.62,0.39,0.11/
      else
         application_schedule(1) = params(33)
         application_schedule(2) = params(33)
         application_schedule(3) = (1+params(33))/2
         application_schedule(4) = 1
         application_schedule(5) = (1+params(33))/2
         application_schedule(6) = params(33)
         application_schedule(7) = params(33)
         application_schedule(8) = params(33)
         application_schedule(9) = (1+params(33))/2
         application_schedule(10) = 1
         application_schedule(11) = (1+params(33))/2
         application_schedule(12) = params(33)
      endif

c     open output file
      call getenv('FARM_ANN_OUTPUT',farm_ann)
      call getenv('FARM_MON_OUTPUT',farm_mon)
      call getenv('FARM_DAY_OUTPUT',farm_day)

      open(ffactor_out, file = farm_ann)
      open(ffactor_mon, file = farm_mon)
      open(ffactor_day, file = farm_day)

c     open states and county list
      i = 0
      open(fstate_county,file=county_filename) 

c     open climate data
      call getenv('CLIMATE',climate_file)
      open(fclimate, file=climate_file)

c     open cow population data
      call getenv('ANIMPOP',anim_file)
      open(fcow_pop, file=anim_file)

c     open farm probabilities
      open(ffarm_prob, file=farm_filename)

      i = 0
      do while(i.eq.i)

         i = i + 1

c     iterate over all counties in the input file
c     for each one, load the farm probabilities

         read(fstate_county, FMT = *,END = 200) 
     2        state, county

        print*,'PROCESSING = State: ', state, ': County:',county

c     load climate data

         read(fclimate,'(2I5,366F10.3)') tstate, tcounty,
     2                                  (temps(j),j=1,366)
         read(fclimate,'(2I5,366F10.3)') tstate, tcounty,
     2                                   (wind(j),j=1,366)
         read(fclimate,'(2I5,366F10.3)') tstate, tcounty,
     2                                   (precip(j),j=1,366)

C         precip(:) = precip(:)/100.0   ! convert cm to meter 

        if(state.ne.tstate .or. county.ne.tcounty) then
          print*, 'ERROR: State:',tstate,' County:',tcounty,
     2            ' is missing from Climate Input file'
          stop
        end if

c     load cow population data
        read(fcow_pop, FMT = *) d1, d2, county_cow_pop

        if(state.ne.d1 .or. county.ne.d2) then
          print*, 'ERROR: State:',d1,' County:', d2,
     2            ' is missing from Population Input file'
          stop
        end if

c     load farm probabilities
        read(ffarm_prob, FMT = *, END = 200) 
     2        tstate, tcounty, farms, total_prob

        if(state.ne.tstate .or. county.ne.tcounty) then
          print*, 'ERROR: State:',tstate,' County:', tcounty,
     2            ' is missing from FARM Configuration Input file'
          stop
        end if

        me = 0
        tprob = 0
        do j = 1,farms
           read(ffarm_prob, FMT = *, END = 200)
     4           confined_summer,
     5           confined_winter,
     6           pasture,
     7           drylot,
     8           deep_pit,
     9           shallow,
     1           nohousing,
     2           liquid,
     3           solid,
     4           lagoon,
     5           earthbasin,
     6           slurrytank,
     7           irrigation,
     8           injection,
     9           trailinghose,
     1           broadcast,
     2           summer_application,
     3           winter_application,
     4           prob

           farm_type(1) = confined_summer
           farm_type(2) = confined_winter
           farm_type(3) = pasture
           farm_type(4) = drylot
           farm_type(5) = deep_pit
           farm_type(6) = shallow
           farm_type(7) = nohousing
           farm_type(8) = liquid
           farm_type(9) = solid
           farm_type(10) = lagoon
           farm_type(11) = earthbasin
           farm_type(12) = slurrytank
           farm_type(13) = irrigation
           farm_type(14) = injection
           farm_type(15) = trailinghose
           farm_type(16) = broadcast
           farm_type(17) = summer_application
           farm_type(18) = winter_application

c     load infiltration data
           infiltration_rate = 0.952498111 

c     run farm model

           call model_driver_daily(temps, precip, wind, 
     2          infiltration_rate, farm_type, application_schedule, 
     3          params, daily_emissions,anim_type)

           do k = 1,366
              me(k,1) = me(k,1) + prob * daily_emissions(k,1)
              me(k,2) = me(k,2) + prob * daily_emissions(k,2)
              me(k,3) = me(k,3) + prob * daily_emissions(k,3)
              me(k,4) = me(k,4) + prob * daily_emissions(k,4)
           enddo

           tprob = tprob + prob

        enddo

        if( abs(tprob-total_prob)>0.001 ) then
           print*,'ERROR: Probability total does not match for'//
     @      ' State:', state, ' :: County:', county
           print*, 'New prob total:',tprob, '  : Org:', total_prob
           stop
        end if

        Mannual = 0
        MHannual = 0
        MSannual = 0
        MAannual = 0
        MGannual = 0
        annual_emission = 0
        Hannual_emission = 0
        Sannual_emission = 0
        Aannual_emission = 0
        Gannual_emission = 0
        do k = 1,366
           me(k,:) = me(k,:) / total_prob    ! true daily total (kg/day-head)
           day_total = me(k,1) + me(k,2) + me(k,3) + me(k,4)
           annual_emission = annual_emission + day_total
           Hannual_emission = Hannual_emission + me(k,1)
           Sannual_emission = Sannual_emission + me(k,2)
           Aannual_emission = Aannual_emission + me(k,3)
           Gannual_emission = Gannual_emission + me(k,4)
           date = 2020000 + k
           write(ffactor_day,'(I2.2,I3.3,2I16,6F20.3)') state,county,
     2         date, county_cow_pop,county_cow_pop*day_total,day_total,
     3         (me(k,l),l=1,4)

           do i = 1,12
               if(k==month_jdate(i)) then

                   write(ffactor_mon,'(I2.2,I3.3,2I16,6F20.3)')
     1               state,county,i,county_cow_pop,
     2               county_cow_pop*(annual_emission-Mannual),
     3               annual_emission-Mannual,
     4               Hannual_emission-MHannual,
     5               Sannual_emission-MSannual,
     6               Aannual_emission-MAannual,
     7               Gannual_emission-MGannual

                     Mannual = annual_emission
                     MHannual = Hannual_emission
                     MSannual = Sannual_emission
                     MAannual = Aannual_emission
                     MGannual = Gannual_emission
               end if
           end do 
        enddo

        county_emission = county_cow_pop * annual_emission
c        Hannual_emission = county_cow_pop * Hannual_emission
c        Sannual_emission = county_cow_pop * Sannual_emission
c        Aannual_emission = county_cow_pop * Aannual_emission
c        Gannual_emission = county_cow_pop * Gannual_emission

        write(ffactor_out,'(I2.2,I3.3,I16,6F20.3)')
     2   state, county, county_cow_pop,county_emission,annual_emission,
     3    Hannual_emission, Sannual_emission, Aannual_emission,
     4    Gannual_emission

      end do
 200  continue

      close(fstate_county)
      close(ffarm_prob)
      close(ffactor_out)
      close(ffactor_day)
      close(fclimate)
      close(fcow_pop)
      
      end

