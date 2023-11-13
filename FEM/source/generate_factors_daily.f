      subroutine generate_factors_daily(nfips,farm_filename,param_filename, 
     2                                  anim_type, country, cyear, scc)

      implicit none
     
c     input variables
      integer nfips
      character*180 farm_filename
      character*180 param_filename
      character*10  anim_type, country, cyear, scc
      character*180 farm_ann, farm_mon, farm_day

c     farm model variables
      real temps(366)
      real precip(366)               ! monthly average precipitation
      real wind(366)                 ! monthly average windspeed
      real infiltration_rate         ! infiltration rate
      integer farm_type(18)          ! array holding farm type information
      real application_schedule(12)  ! fraction of manure 
      real params(44)                ! input parameters
      integer month_jdate (12)       ! julian date for each month 
      integer month_idate (12)       ! julian date for each month 
      real daily_emissions(366,4)    ! daily emissions by process
      real day_emission(366)         ! daily emissions
      real mon_total(12)             ! monthly emissions
      real me(366,4)

c     farm type variables
      integer year, ndays, sdate, edate
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
      integer ffactor_day      ! daily output file
      character*80 line1, line2
      character*180 climate_file, anim_file
      logical, save:: firstime = .true.

c     local variables
      integer i,j,k,l,ii
      integer state            ! current state
      integer county           ! current county
      integer date
      integer d1,d2            ! read in dummy variables
      character*3 string_id    ! used for output file name

c     compute average emission factor
      integer county_cow_pop   ! cow population for county
      integer total_cow_pop    ! total cow population 
      real month_emission      ! county monthly emission
      real annual_emission     ! county annual emission
      real summer_winter_ratio ! emissions ratio summer / winter

      data month_idate /31,59,90,120,151,181,212,243,273,304,334,365/
      data month_jdate /31,60,91,121,152,182,213,244,274,305,335,366/  ! leap-yaer

C.......  check the leap year or not
      ndays = 366
      read( cyear,'(I10)' ) year
      if( mod( year,4 ) > 0 ) then
          ndays = 365
          month_jdate=month_idate
      end if

      i = 0
      total_cow_pop = 0

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
      call getenv('FARM_DAY_OUTPUT',farm_day)

      open(ffactor_out, file = farm_ann)
      open(ffactor_day, file = farm_day)

c     write NH3 emissions in FF10 headers
      if( firstime ) then
        write(ffactor_day,'(a)') '#FORMAT=FF10_DAYILY_NONPOINT'
        write(ffactor_day,'(a)') '#COUNTRY=US'
        write(ffactor_day,'(a)') '#YEAR='//trim(cyear)
        write(ffactor_day,'(a)') 'country_cd,region_cd,tribal_code,census_tract_cd'
     1    //',shape_id,na,emis_typescc,scc,poll,,,,month,mon_value,day1,day2,,,,,dayN'

        write(ffactor_out,'(a)') '#FORMAT=FF10_NONPOINT'
        write(ffactor_out,'(a)') '#COUNTRY=US'
        write(ffactor_out,'(a)') '#YEAR='//trim(cyear)
        write(ffactor_out,'(a)') 'country_cd,region_cd,tribal_code,census_tract_cd'
     1 //',shape_id,scc,emis_type,poll,ann_value,,,,,,,,,,,,jan,feb,mar,,,,,,,,,dec'
        
        firstime = .false.
      end if

c     open climate data
      call getenv('CLIMATE',climate_file)
      open(fclimate, file=climate_file)

c     open cow population data
      call getenv('ANIMAL_COUNTS',anim_file)
      open(fcow_pop, file=anim_file)

c     open farm probabilities
      open(ffarm_prob, file=farm_filename)

      print*, climate_file
      print*, anim_file

      do ii = 1,nfips

c     iterate over all counties in the input file
c     for each one, load the farm probabilities

c     load cow population data
        read(fcow_pop, FMT = *) state, county, county_cow_pop

        print*,'PROCESSING = State: ', state, ': County:',county

c     load climate data

         read(fclimate,'(2I5,366F10.3)') tstate, tcounty,
     2                                  (temps(j),j=1,ndays)
         read(fclimate,'(2I5,366F10.3)') tstate, tcounty,
     2                                   (wind(j),j=1,ndays)
         read(fclimate,'(2I5,366F10.3)') tstate, tcounty,
     2                                   (precip(j),j=1,ndays)

C         precip(:) = precip(:)/100.0   ! convert cm to meter 

        if(state.ne.tstate .or. county.ne.tcounty) then
          print*, 'ERROR: State:',tstate,' County:',tcounty,
     2            ' is missing from Climate Input file'
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
     3          params, daily_emissions,anim_type,ndays)

           daily_emissions = daily_emissions * (2.2/2000.0)  ! convert kg/day to s-tons/day

           do k = 1,ndays
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

        annual_emission = 0
        do k = 1,ndays
           me(k,:) = me(k,:) / total_prob    ! true daily total (s-tons/day-head)
           day_emission(k) = county_cow_pop * (me(k,1)+me(k,2)+me(k,3)+ me(k,4))
           month_emission = month_emission + day_emission(k)
           annual_emission = annual_emission + day_emission(k)
           date = year*1000 + k

           do i = 1,12
             if(k==month_jdate(i)) then
                sdate = month_jdate(i-1) + 1
                if(i==1) sdate = 1
                edate = k 
                write(ffactor_day,10000) trim(country),state,county,trim(scc),i,
     1                   month_emission,(day_emission(l),l=sdate,edate)
                mon_total(i) = month_emission
                month_emission = 0.0  ! reset it for next month total

             end if
           end do 
        enddo

        write(ffactor_out,20000) trim(country),state,county,trim(scc),
     1                    annual_emission,(mon_total(l),l=1,12)

      end do
 200  continue

      close(ffarm_prob)
      close(ffactor_out)
      close(ffactor_day)
      close(fclimate)
      close(fcow_pop)

10000 format(a3,',',I2.2,I3.3,',,,,,,',a,',NH3,,,,,',I2,32(',',E15.7))
20000 format(a3,',',I2.2,I3.3,',,,,',a,',,NH3,',E15.7,',,,,,,,,,,,',12(',',E15.7))
      
      end

