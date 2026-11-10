! *****************************COPYRIGHT*******************************
!
! (c) [University of Cambridge] [2008]. All rights reserved.
! This routine has been licensed to the Met Office for use and
! distribution under the UKCA collaboration agreement, subject
! to the terms and conditions set out therein.
! [Met Office Ref SC138]
!
! *****************************COPYRIGHT*******************************
!
! Purpose: Subroutine to overwrite the stratospheric ozone tracer
! (O3S) values with modelled ozone values in the stratosphere
! after the chemistry is solved.  Code originally written by
! Antara Banerjee (2014), updated and edited for use in vn11.1
! branches by Luke Abraham & James Keeble (2020).
!
!  Part of the UKCA model, a community model supported by the
!  Met Office and NCAS, with components provided initially
!  by The University of Cambridge, University of Leeds and
!  The Met. Office.  See www.ukca.ac.uk
!
!          Called from UKCA_CHEMISTRY_CTL.
!
! ---------------------------------------------------------------------
!
MODULE ukca_strat_o3_tracer_mod

IMPLICIT NONE

CHARACTER(LEN=*), PARAMETER, PRIVATE :: ModuleName = 'UKCA_STRAT_O3_TRACER_MOD'

CONTAINS

SUBROUTINE ukca_strat_o3_tracer(row_length, rows, model_levels, ntracer,       &
                                tracer)

USE ukca_tropopause,   ONLY: L_troposphere
USE ukca_cspecies,     ONLY: n_o3, n_o3s
USE ukca_constants,    ONLY: c_o3
USE yomhook,           ONLY: lhook, dr_hook
USE parkind1,          ONLY: jprb, jpim

IMPLICIT NONE

INTEGER, INTENT(IN) :: row_length   ! No of longitudes
INTEGER, INTENT(IN) :: rows         ! No of latitudes
INTEGER, INTENT(IN) :: model_levels ! No of levels
INTEGER, INTENT(IN) :: ntracer      ! No of chemical tracers
! tracer mmr array
REAL, INTENT(IN OUT) :: tracer(row_length,rows,model_levels,ntracer)

INTEGER(KIND=jpim), PARAMETER :: zhook_in  = 0
INTEGER(KIND=jpim), PARAMETER :: zhook_out = 1
REAL(KIND=jprb)               :: zhook_handle

CHARACTER(LEN=*), PARAMETER :: RoutineName='UKCA_STRAT_O3_TRACER'

! Body of subroutine
IF (lhook) CALL dr_hook(ModuleName//':'//RoutineName,zhook_in,zhook_handle)

! Overwrite values of O3S with O3 in the stratosphere

IF (n_o3s > 0) THEN 
   WHERE (.NOT. L_troposphere)
      tracer(:,:,:,n_o3s)   = tracer(:,:,:,n_o3)
   END WHERE
END IF

IF (lhook) CALL dr_hook(ModuleName//':'//RoutineName,zhook_out,zhook_handle)

RETURN
END SUBROUTINE ukca_strat_o3_tracer

END MODULE ukca_strat_o3_tracer_mod
