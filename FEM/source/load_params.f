      subroutine load_params(filename, params, num_params)

      implicit none

      character*180 filename
      character*180 default_filename
      
      integer num_params
      real params(num_params)

      integer new_fileid
      integer default_fileid
      character*3 param_id
      character*4 value2
      real value
      integer i,j

      i = 0
      new_fileid = 9
      default_fileid = 10

c     first, load default values 
      call getenv('PARAM_DEFAULT',default_filename)
      open(default_fileid, file=default_filename)
      print*,'Processing: Default Parameter:',trim(default_filename)

      do while(1.eq.1)
         i = i + 1
         read(default_fileid,fmt=*,END = 200) param_id, value
         params(i) = value
      end do
 200  continue

      close(default_fileid)

      i = 0

c     now, load any different parameters from file

      open(new_fileid, file=filename)
      print*,'Processing: MAIN Parameter:',trim(filename)
      
      do while(1.eq.1)
         i = i + 1
         read(new_fileid, FMT = *, END = 400) param_id, value

         if (param_id.eq.'Hp1') then
            params(1) = value         
         elseif (param_id.eq.'Hp2') then
            params(2) = value
         elseif (param_id.eq.'Sp1') then
            params(3) = value
         elseif (param_id.eq.'Sp2') then
            params(4) = value
         elseif (param_id.eq.'Ap1') then
            params(5) = value
         elseif (param_id.eq.'Ap2') then
            params(6) = value
         elseif (param_id.eq.'Ap3') then
            params(7) = value
         elseif (param_id.eq.'Gp1') then
            params(8) = value
         elseif (param_id.eq.'Gp2') then
            params(9) = value
         elseif (param_id.eq.'crt') then
            params(10) = value
         elseif (param_id.eq.'sld') then
            params(11) = value
         elseif (param_id.eq.'hlf') then
            params(12) = value
         elseif (param_id.eq.'hph') then
            params(13) = value
         elseif (param_id.eq.'sph') then
            params(14) = value
         elseif (param_id.eq.'aph') then
            params(15) = value
         elseif (param_id.eq.'gph') then
            params(16) = value
         elseif (param_id.eq.'mvl') then
            params(17) = value
         elseif (param_id.eq.'ure') then
            params(18) = value
         elseif (param_id.eq.'ifl') then
            params(19) = value
         elseif (param_id.eq.'har') then
            params(20) = value
         elseif (param_id.eq.'sar') then
            params(21) = value
         elseif (param_id.eq.'aar') then
            params(22) = value
         elseif (param_id.eq.'gar') then
            params(23) = value
         elseif (param_id.eq.'aci') then
            params(24) = value
         elseif (param_id.eq.'gci') then
            params(25) = value
         elseif (param_id.eq.'idm') then
            params(26) = value
         elseif (param_id.eq.'jdm') then
            params(27) = value
         elseif (param_id.eq.'tdm') then
            params(28) = value
         elseif (param_id.eq.'bdm') then
            params(29) = value
         elseif (param_id.eq.'grh') then
            params(30) = value
         elseif (param_id.eq.'grt') then
            params(31) = value
         elseif (param_id.eq.'rna') then
            params(32) = value
         elseif (param_id.eq.'m01') then
            params(33) = value
         elseif (param_id.eq.'m02') then
            params(34) = value
         elseif (param_id.eq.'m03') then
            params(35) = value
         elseif (param_id.eq.'m04') then
            params(36) = value
         elseif (param_id.eq.'m05') then
            params(37) = value
         elseif (param_id.eq.'m06') then
            params(38) = value
         elseif (param_id.eq.'m07') then
            params(39) = value
         elseif (param_id.eq.'m08') then
            params(40) = value
         elseif (param_id.eq.'m09') then
            params(41) = value
         elseif (param_id.eq.'m10') then
            params(42) = value
         elseif (param_id.eq.'m11') then
            params(43) = value
         elseif (param_id.eq.'m12') then
            params(44) = value
         endif

         write(*,'(3a,f10.5)') trim(filename),' :: ',param_id, value

      end do
 400  continue

      close(new_fileid)
      return

      end   
