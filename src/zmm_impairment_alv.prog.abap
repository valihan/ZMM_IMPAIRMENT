*&---------------------------------------------------------------------*
*&  Include           ZMM_IMPAIRMENT_ALV
*&---------------------------------------------------------------------*

  FORM alv.
    DATA: ls_alv_layout TYPE slis_layout_alv,
          ls_variant    TYPE disvariant.
    DATA: lv_ind TYPE i,
          ls_cat LIKE LINE OF gt_cat.

    DEFINE fc_add.
      ls_cat-col_pos = lv_ind = lv_ind + 1.
      ls_cat-fieldname = &1.
      ls_cat-seltext_s = &2.
      ls_cat-seltext_l = &3.
      append ls_cat to gt_cat. clear ls_cat.
    END-OF-DEFINITION.

    ls_alv_layout-colwidth_optimize = 'X'.
    ls_alv_layout-info_fieldname = 'COLOR'.
    ls_alv_layout-zebra = 'X'.
    "    ls_alv_layout-box_fieldname = 'CHECKBOX'.
*    ls_variant-variant = p_var.


    fc_add 'DMBE1_KZT' text-520 text-520.
    fc_add 'DMBE1_USD' text-521 text-521.
    fc_add 'DMBE2_KZT' text-522 text-522.
    fc_add 'DMBE2_USD' text-523 text-523.



    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program      = sy-repid
        is_layout               = ls_alv_layout
        it_fieldcat             = gt_cat
        i_callback_user_command = 'USER_COMMAND'
"       i_callback_pf_status_set = 'SET_PF_STATUS'
        i_save                  = 'X'
        is_variant              = ls_variant
"       i_callback_top_of_page  = 'TOP_10'
      TABLES
        t_outtab                = gt_output
      EXCEPTIONS
        program_error           = 1
        OTHERS                  = 2.

  ENDFORM.                    "alv

  FORM user_command USING ucomm
        selline TYPE slis_selfield.
    DATA: ls_output  LIKE LINE OF gt_output,
          lv_left    TYPE i,  lv_id_l TYPE i,
          lv_right   TYPE i, lv_id_r TYPE i,
          lv_checked TYPE i.

    CASE ucomm.
      WHEN '&IC1' OR '&ETA'.
        READ TABLE gt_output INDEX selline-tabindex INTO ls_output.
        CASE selline-fieldname.
          WHEN 'CHARG'.
            SET PARAMETER ID 'MAT' FIELD ls_output-matnr.
            SET PARAMETER ID 'CHA' FIELD ls_output-charg.
            SET PARAMETER ID 'WRK' FIELD ls_output-werks.
            SET PARAMETER ID 'LGT' FIELD ls_output-lgort.
            CALL TRANSACTION 'MSC2N' AND SKIP FIRST SCREEN.
          WHEN 'MATNR'.
            SET PARAMETER ID 'MAT' FIELD ls_output-matnr.
            CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
          WHEN 'ZIV_SERIAL'.
            PERFORM ziv_serial_alv(rm07mlbs)
              USING ls_output-matnr ls_output-werks ls_output-lgort.
        ENDCASE.
*      WHEN '&LOG'.
*        "        zsnt_cl_log=>slog_show( ).
    ENDCASE.
  ENDFORM.                    "als
