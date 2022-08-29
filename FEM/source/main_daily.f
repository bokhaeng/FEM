      program regression_sensitivity

      implicit none
      real params(44)
      integer i

      character*180 anim_file, farm_file
      character*180 county_file
      character*180 param_file
      character*180 temp_file, wind_file, precip_file

      character*10 anim_type

      real sum_winter, sum_spring, sum_summer, sum_fall
      real mean_emission
      real stdev_emission
      integer fstats_out, nfips
      
      fstats_out = 50

      call getenv('ANIMAL_TYPE',anim_type)
      call getenv('COUNTY',county_file)
      call getenv('TEPERATURE',temp_file)
      call getenv('WIND_SPEED',wind_file)
      call getenv('PRECIPITATION',precip_file)
      call getenv('FARM_CONFIG',farm_file)
      call getenv('PARAMETERS',param_file)
      call getenv('ANIMAL_COUNTS',anim_file)

      call generate_climate_data_daily(county_file,nfips,temp_file,
     2     wind_file,precip_file)
      print*,'Completed: Processing climate data=================='

      call generate_activity_data(county_file,anim_file)
      print*,'Completed: Processing animal population data========'

      call generate_factors_daily(county_file,farm_file,param_file,
     2     anim_type)

      end

      
