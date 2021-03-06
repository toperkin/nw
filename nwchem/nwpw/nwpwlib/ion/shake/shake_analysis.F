*
* $Id: shake_analysis.F 19707 2010-10-29 17:59:36Z d3y133 $
*

*     ***************************
*     *			        *
*     *	     shake_analysis     *
*     *				*
*     ***************************
      subroutine shake_analysis(rtdb)
      implicit none 
      integer   rtdb

#include "rtdb.fh"
#include "errquit.fh"
#include "stdio.fh"

*     **** local variables ****
      integer MASTER,taskid
      parameter (MASTER=0)

      logical value
      character*50  filename
      character*255 full_filename

*     **** external functions ****

      call ga_sync()

      call Parallel_taskid(taskid)


      call molecular_init(rtdb)
      value = rtdb_parallel(.false.)
      if (taskid.eq.MASTER) then

         write(luout,*)
         write(luout,*) '===== Performing shake analysis ===='
         write(luout,*)


         if (.not.rtdb_cget(rtdb,'cpmd:fei_filename',1,filename))
     >     call util_file_prefix('fei',filename)

         call util_file_name_noprefix(filename,.false.,
     >                             .false.,
     >                             full_filename)

         call util_file_name_noprefix(filename,.false.,
     >                               .false.,
     >                               full_filename)

         call molecular_force_average(full_filename)
         


      end if
      call ga_sync()
      value = rtdb_parallel(.true.)
      call molecular_end()
   

      return
      end



