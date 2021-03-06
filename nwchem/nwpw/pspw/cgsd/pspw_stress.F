*
* $Id: pspw_stress.F 22289 2012-04-09 00:15:38Z bylaska $
*

      logical function pspw_stress(rtdb)
      implicit none
      integer rtdb

#include "mafdecls.fh"
#include "rtdb.fh"
#include "errquit.fh"

*     **** local variables ****
      logical numerical,frozen,hasfrozen

*     **** external functions ****
      logical  cgsdv5,pspw_stress_numerical
      external cgsdv5,pspw_stress_numerical


      if (.not.
     >  rtdb_get(rtdb,'nwpw:stress_numerical',mt_log,1,numerical))
     >  numerical = .false.

      if (numerical) then
        hasfrozen = .false.
        if (rtdb_get(rtdb,'nwpw:frozen_lattice',mt_log,1,frozen))
     >     hasfrozen = .true.

        if (.not.rtdb_put(rtdb,'nwpw:frozen_lattice',mt_log,1,.true.))
     >     call errquit('pspw_stress:error frozen lattice',0,RTDB_ERR)

        pspw_stress = pspw_stress_numerical(rtdb)

        if (hasfrozen) then
           if(.not.rtdb_put(rtdb,'nwpw:frozen_lattice',mt_log,1,frozen))
     >        call errquit('pspw_stress:error frozen lattice',
     >                     1,RTDB_ERR)
        else
           if (.not.rtdb_delete(rtdb,'nwpw:frozen_lattice'))
     >        call errquit('pspw_stress:error delete frozen lattice',
     >                     0,RTDB_ERR)
        end if
      else
        pspw_stress = cgsdv5(rtdb,3)
      end if

      return
      end

