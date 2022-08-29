      subroutine generate_climate_data_daily(county_file,nf,temp_file,
     2           wind_file, precip_file)
      
      implicit none

c     input variables
      character*180 county_file
      integer nf
      character*180 temp_file
      character*180 wind_file
      character*180 precip_file
      character*180 climate_file

c     file identifiers for input files
      integer fstate_county
      integer ftemps
      integer fwind
      integer fprecip
      integer fstate_codes

c     file identifiers for output files
      integer fclimate_out

      parameter nfip = 3113    ! max no of U.S. counties

c     arrays to hold climate data from files
      real, allocatable :: temps(:,:)
      real, allocatable :: wind(:,:)
      real, allocatable :: precip(:,:)
C      real :: wind(nfip, 368) = 0.0
c      real :: precip(nfip,368) = 0.0
      real :: tmpvar( 31 ) = 0.0

c     local variables
      integer ii, i,j,k,n, dummy, fips, nd, id, mon, lmon
      integer climate_code
      integer state, fstate, county, fcounty
      integer climate_data_exists
      integer clim_found
      integer ndays(12)
      
      fstate_county = 30
      ftemps = 31
      fwind = 32
      fprecip = 33
      fstate_codes = 34
      fclimate_out = 36

      data ndays /31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31/

      allocate(temps(nfip,368),wind(nfip,368),precip(nfip,368)) 

c     load climate data
      open(ftemps, file=temp_file)
      open(fwind, file=wind_file)
      open(fprecip, file=precip_file)      

      nd = 2
      lmon = 0

      do ii = 1, nfip*12 
 
         read(ftemps,FMT=*) fips,mon,(tmpvar(j),j=1,ndays(mon))
         fstate = int(fips/1000)
         fcounty = int(fips-(fstate*1000))
 
         if(mon/=lmon) then
             nf = k   ! no of FIPS from met files
             k = 0
             nd = nd + ndays(mon)
             id = nd - ndays(mon) + 1 
         end if
         lmon = mon

         k = k + 1
         temps(k,1)=fstate
         temps(k,2)=fcounty
         temps(k,id:nd) = tmpvar(1:ndays(mon))
         tmpvar = 0

         read(fwind, FMT = *) fips,mon,(tmpvar(j),j=1,ndays(mon))
         wind(k,id:nd) = tmpvar(1:ndays(mon))
         tmpvar = 0

         read(fprecip, FMT = *) fips,mon,(tmpvar(j),j=1,ndays(mon))
         precip(k,id:nd) = tmpvar(1:ndays(mon))
         tmpvar = 0
      end do

      close(ftemps)
      close(fwind)
      close(fprecip)

c     open output file
      call getenv('CLIMATE',climate_file)
      open(fclimate_out, file = climate_file)

c     open state and counties to collect climate data
      open(fstate_county, file=county_file)
      
      do while(1.eq.1)
         read(fstate_county,FMT=*,END=200) state, county

         do j = 1,nf 
            fstate = int(temps(j,1))
            fcounty = int(temps(j,2))
            if(state.eq.fstate.and.county.eq.fcounty) then
                clim_found = 1
                k = j
            endif
         end do

         if (clim_found.eq.0) then
            print *, 'ERROR: climate code not found.',
     2           ' State: ',state,
     3           ' Climate Code: ', climate_code
         else
c     write climate data to output file with climate index k
             write (fclimate_out,'(2I5,366F10.3)')
     1        state, county,(temps(k,j),j=3,368)
             write (fclimate_out,'(2I5,366F10.3)')
     2        state, county,(wind(k,j),j=3,368)
             write (fclimate_out,'(2I5,366F10.3)')
     3        state, county,(precip(k,j),j=3,368)

         endif

      end do
200   continue

      deallocate( temps )
      deallocate( wind )
      deallocate( precip )

      close(fclimate_out)
      close(fstate_county)

      end
