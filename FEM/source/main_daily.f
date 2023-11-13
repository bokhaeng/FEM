      program regression_sensitivity

      implicit none
      real params(44)
      integer i

      character*180 anim_file, farm_file
      character*180 param_file
      character*180 temp_file, wind_file, precip_file
      character*10 anim_type, country, cyear, scc

      integer nfips
      
      call getenv('ANIMAL_TYPE',anim_type)
      call getenv('YEAR',cyear)
      call getenv('COUNTRY',country)
      call getenv('SCC',scc)

      call getenv('TEPERATURE',temp_file)
      call getenv('WIND_SPEED',wind_file)
      call getenv('PRECIPITATION',precip_file)

      call getenv('FARM_CONFIG',farm_file)
      call getenv('PARAMETERS',param_file)
      call getenv('ANIMAL_COUNTS',anim_file)

      call generate_climate_data_daily(anim_file,nfips,temp_file,
     2     wind_file,precip_file,cyear)
      print*,'Completed: Processing climate data=================='

      call generate_factors_daily(nfips,farm_file,param_file,
     2     anim_type, country, cyear, scc)

      end

      
