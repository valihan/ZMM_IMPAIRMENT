*&---------------------------------------------------------------------*
*& Report  ZMM_IMPAIRMENT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zmm_impairment.

INCLUDE zmm_impairment_top.
INCLUDE zmm_impairment_scr.
INCLUDE zmm_impairment_sel.
INCLUDE zmm_impairment_alv.


START-OF-SELECTION.
  PERFORM sel_data.
  PERFORM alv.
