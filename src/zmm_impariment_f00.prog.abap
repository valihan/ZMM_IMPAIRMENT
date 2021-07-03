*&---------------------------------------------------------------------*
*&  Include           ZMM_IMPAIRMENT_F00
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  bspl_alv_variant_f4
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->VALUE      text
*      -->(P_REPID)  text
*      -->VALUE      text
*      -->(P_HANDLE) text
*      -->VALUE      text
*      -->(P_DISP)   text
*      <--P_VARIANT  text
*----------------------------------------------------------------------*
FORM bspl_alv_variant_f4 USING VALUE(p_repid)
  VALUE(p_handle)
  VALUE(p_disp)
  CHANGING p_variant.

  DATA: ls_variant LIKE disvariant.
  ls_variant-report = p_repid.
  ls_variant-handle = p_handle.
  ls_variant-username = sy-uname.
  CALL FUNCTION 'REUSE_ALV_VARIANT_F4'
    EXPORTING
      is_variant         = ls_variant
      i_save             = 'A'
      i_display_via_grid = 'X'
    IMPORTING
      es_variant         = ls_variant.
  IF sy-subrc = 0.
    p_variant = ls_variant-variant.
  ENDIF.
ENDFORM. " BSPL_ALV_VARIANT_F4
