      subroutine generate_activity_data(county_file,anim_file)
      
c     loads states and counties in filename, and then
c     gathers climate input and stores it with the
c     unique identifier "id"

      implicit none

c     input variables
      character*180 county_file
      character*180 anim_file
      character*180 animpop_file

c     file identifiers for input files
      integer fstate_county
      integer fani_pop
      integer fani_pop_out

c     file identifiers for output files
      integer fcow_out


c     arrays to hold cow population data from files
      integer ani_pop(3113,3)

c     local variables
      integer i,j,k,n,dummy
      integer state, county, nfips
      integer ani_pop_total
      integer county_found

      fstate_county = 40
      fani_pop = 41
      fani_pop_out = 42

c     load animal data
      open(fani_pop, file=anim_file)
      i = 0
      do while(1.eq.1) 
         i = i + 1
         read(fani_pop,FMT=*,END=300) 
     2        ani_pop(i,1),ani_pop(i,2),ani_pop(i,3)
      enddo
300   continue

      nfips = i   ! total no of counties processing
      
      close(fani_pop)

c     open output file
      call getenv('ANIMPOP',animpop_file)
      open(fani_pop_out, file = animpop_file)

c     open state and counties to collect climate data
      open(fstate_county, file=county_file)
       
      do while(1.eq.1)
         read(fstate_county,FMT=*,END=200) state, county

         county_found = 0
         do j =1,nfips
            if ((ani_pop(j,1).eq.state).and.
     2          (ani_pop(j,2).eq.county)) then
                county_found = 1
                k = j
            endif
         end do

         if (county_found.eq.0) then
          write(*,'(a,i5,a,i5)') 'WARNING: Animal Population data '//
     2     'is not found: State: ',state,' :: County: ', county
         else

c     write climate data to output file with index k
             write (fani_pop_out, '(3I12)')
     2            state, county, ani_pop(k,3)
         endif

      end do
 200  continue

      close(fani_pop_out)
      close(fstate_county)

      end
