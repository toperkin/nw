*
* $Id: nwpw_timing.F 23516 2013-01-29 19:01:11Z bylaska $
*

* nwpw_timing.F
* Author - Eric Bylaska
*
*   These routines are to be used to time the nwpw module
*
*
*   1 - total FFT 
*   2 - total dot products
*   3 - lagrange multipliers
*   4 - exchange correlation
*   5 - local pseudopotentials
*   6 - non-local pseudopotentials
*   7 - hartree potentials
*   8 - structure factors
*   9 - masking and packing
*   10 - geodesic time
*   11 - gen psi_r and dn
*   12 - allocating memory from stack
*   13 - miscellaneous steepest descent update
*   15 - ffm_dgemm
*   16 - fmf_dgemm
*   17 - m_diagonalize

*
*   20 - phase factors
*   21 - ewald /ion-ion

*   22 - tredq
*   23 - getdiags
*   24 - tqliq
*   25 - eigsrt

*   30 - queue fft
*   31 - queue fft serial
*   32 - queue fft parallel
*   33 - HFX
*   40 - qmmm LJ
*   41 - qmmm residual Q

*   50 - io time


      subroutine nwpw_timing_init()
      implicit none

#include "nwpw_timing_common.fh"
      call current_second(t0)
      call dcopy(50,0.0d0,0,times,1)
      return 
      end

      subroutine nwpw_timing_start(counter)
      implicit none
      integer counter

#include "nwpw_timing_common.fh"

	  call current_second(nwpw_tim1(counter))
      return
      end

      subroutine nwpw_timing_end(counter)
      implicit none
      integer counter

#include "nwpw_timing_common.fh"

      
	  call current_second(nwpw_tim2(counter))
     
      times(counter) = times(counter) 
     >               + (nwpw_tim2(counter)-nwpw_tim1(counter))
      return
      end

      real*8 function nwpw_timing(counter)
      implicit none
      integer counter
#include "nwpw_timing_common.fh"

      nwpw_timing = times(counter)
      return
      end

      subroutine nwpw_timing_print(msg,time,counter,ttime)
      implicit none
      character*(*) msg
      real*8 time,ttime
      integer counter
#include "stdio.fh"
      if (time>1.0d-9) then
         write(luout,1708) msg,time,time/dble(counter),100*time/ttime
      end if
 1708 FORMAT(A,E14.6,E14.6,F12.1,' %')
      return
      end


      subroutine nwpw_timing_print_final(oprint,counter)
      implicit none
      logical  oprint
      integer counter

#include "stdio.fh"

      real*8 ttime
c     **** external functions ****
      real*8   nwpw_timing
      external nwpw_timing

#include "nwpw_timing_common.fh"

      call current_second(tf)
      ttime = tf-t0
      if (oprint) then
      write(luout,1809) 'Time spent doing               ',
     >                  'total','step', 'percent'
         call nwpw_timing_print(
     >                 '  total time                 : ',
     >                 ttime,counter,ttime)
         call nwpw_timing_print(
     >                 '  i/o time                   : ',
     >                 nwpw_timing(50),counter,ttime)
         call nwpw_timing_print(
     >                 '  FFTs                       : ',
     >                 nwpw_timing(1),counter,ttime)
         call nwpw_timing_print(
     >                 '  dot products               : ',
     >                 nwpw_timing(2),counter,ttime)
         call nwpw_timing_print(
     >                 '  geodesic                   : ',
     >                 nwpw_timing(10),counter,ttime)
         call nwpw_timing_print(
     >                 '  ffm_dgemm                  : ',
     >                 nwpw_timing(15),counter,ttime)
         call nwpw_timing_print(
     >                 '  fmf_dgemm                  : ',
     >                 nwpw_timing(16),counter,ttime)
         call nwpw_timing_print(
     >                 '  m_diagonalize              : ',
     >                 nwpw_timing(17),counter,ttime)

         call nwpw_timing_print(
     >                 '    - m_tredq                : ',
     >                 nwpw_timing(22),counter,ttime)
         call nwpw_timing_print(
     >                 '       - m_tredq_houseq      : ',
     >                 nwpw_timing(26),counter,ttime)
         call nwpw_timing_print(
     >                 '       - m_tredq_houseq_dgemm: ',
     >                 nwpw_timing(28),counter,ttime)
         call nwpw_timing_print(
     >                 '       - m_tredq_dgemm1      : ',
     >                 nwpw_timing(27),counter,ttime)

         call nwpw_timing_print(
     >                 '    - m_getdiags             : ',
     >                 nwpw_timing(23),counter,ttime)
         call nwpw_timing_print(
     >                 '    - m_tqliq                : ',
     >                 nwpw_timing(24),counter,ttime)
         call nwpw_timing_print(
     >                 '    - m_eigsrt               : ',
     >                 nwpw_timing(25),counter,ttime)

         call nwpw_timing_print(
     >                 '  exchange correlation       : ',
     >                 nwpw_timing(4),counter,ttime)
         call nwpw_timing_print(
     >                 '  local pseudopotentials     : ',
     >                 nwpw_timing(5),counter,ttime)
         call nwpw_timing_print(
     >                 '  non-local pseudopotentials : ',
     >                 nwpw_timing(6),counter,ttime)
         call nwpw_timing_print(
     >                 '  hartree potentials         : ',
     >                 nwpw_timing(7),counter,ttime)
         call nwpw_timing_print(
     >                 '  ion-ion interaction        : ',
     >                 nwpw_timing(21),counter,ttime)
         call nwpw_timing_print(
     >                 '  structure factors          : ',
     >                 nwpw_timing(8),counter,ttime)
         call nwpw_timing_print(
     >                 '  phase factors              : ',
     >                 nwpw_timing(20),counter,ttime)
         call nwpw_timing_print(
     >                 '  masking and packing        : ',
     >                 nwpw_timing(9),counter,ttime)
         call nwpw_timing_print(
     >                 '  queue fft                  : ',
     >                 nwpw_timing(30),counter,ttime)
         call nwpw_timing_print(
     >                 '  queue fft (serial)         : ',
     >                 nwpw_timing(31),counter,ttime)
         call nwpw_timing_print(
     >                 '  queue fft (message passing): ',
     >                 nwpw_timing(32),counter,ttime)
         call nwpw_timing_print(
     >                 '  HFX potential              : ',
     >                 nwpw_timing(33),counter,ttime)
         call nwpw_timing_print(
     >                 '  qmmm LJ                    : ',
     >                 nwpw_timing(40),counter,ttime)
         call nwpw_timing_print(
     >                 '  qmmm residual Q            : ',
     >                 nwpw_timing(41),counter,ttime)
      end if

      return 
 1808 FORMAT(A,E14.6,E14.6)
 1809 FORMAT(//A,3A14)
      end

