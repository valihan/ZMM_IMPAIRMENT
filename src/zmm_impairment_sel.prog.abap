*&---------------------------------------------------------------------*
*&  Include           ZMM_IMPAIRMENT_SEL
*&---------------------------------------------------------------------*
FORM sel_data.
  REFRESH gt_output.
  PERFORM get_from_mb52.
ENDFORM.                    "sel_data



*&---------------------------------------------------------------------*
*&      Form  get_from_mb52
*&---------------------------------------------------------------------*
*       Получить данные из MB52
*----------------------------------------------------------------------*
FORM get_from_mb52.
  DATA:
    lr_alv_data TYPE REF TO data,
    ls_output   LIKE LINE OF gt_output.
  FIELD-SYMBOLS:
    <ft_alv_data> TYPE ANY TABLE,
    <fs_alv_data> TYPE any.

  cl_salv_bs_runtime_info=>set( EXPORTING display  = abap_false
                                          metadata = abap_true
                                          data     = abap_true ).

  " вызвать MB52
  SUBMIT rm07mlbs EXPORTING LIST TO MEMORY
    WITH matnr  IN s_matnr
    WITH werks  IN s_werks
    WITH lgort  IN s_lgort
    WITH xmchb  = abap_true
    WITH nozero = abap_true
    WITH pa_hsq = abap_false
    WITH pa_flt = abap_true
    AND RETURN.

  TRY.
      cl_salv_bs_runtime_info=>get_data_ref(
        IMPORTING r_data = lr_alv_data ).
      CHECK lr_alv_data IS BOUND.

      ASSIGN lr_alv_data->* TO <ft_alv_data>.
      LOOP AT <ft_alv_data> ASSIGNING <fs_alv_data>.
        CLEAR ls_output.
        MOVE-CORRESPONDING <fs_alv_data> TO ls_output.

        PERFORM add_data CHANGING ls_output.

        APPEND ls_output TO gt_output.
      ENDLOOP.


      " Получить перечень полей ALV в MB52
      DATA: ls_metadata TYPE cl_salv_bs_runtime_info=>s_type_metadata.
      ls_metadata = cl_salv_bs_runtime_info=>get_metadata( ).
      PERFORM fill_fcat USING ls_metadata.

    CATCH cx_salv_bs_sc_runtime_info.
      MESSAGE 'Ошибка работы с MB52' TYPE 'E'.
  ENDTRY.

  cl_salv_bs_runtime_info=>set( EXPORTING display  = abap_true
                                          metadata = abap_false
                                          data     = abap_true ).

ENDFORM.                    "call_mb52


*&---------------------------------------------------------------------*
*&      Form  fill_fcat
*&---------------------------------------------------------------------*
* Копируем описание полей ALV MB52 к себе
*----------------------------------------------------------------------*
*      -->IS_METADATA  text
*----------------------------------------------------------------------*
FORM fill_fcat USING is_metadata TYPE cl_salv_bs_runtime_info=>s_type_metadata.
  DATA:
    ls_fcat TYPE lvc_s_fcat,
    ls_cat  LIKE LINE OF gt_cat.

  LOOP AT is_metadata-t_fcat INTO ls_fcat.
    CLEAR ls_cat.
    "MOVE-CORRESPONDING ls_gcat TO ls_fcat.
    MOVE:
      ls_fcat-fieldname  TO ls_cat-fieldname,
      ls_fcat-tabname    TO ls_cat-tabname,
      ls_fcat-cfieldname TO ls_cat-cfieldname,
      ls_fcat-qfieldname TO ls_cat-qfieldname,
      ls_fcat-hotspot    TO ls_cat-hotspot,
      ls_fcat-seltext    TO ls_cat-seltext_s,
      ls_fcat-tooltip    TO ls_cat-seltext_l.
    APPEND ls_cat TO gt_cat.
  ENDLOOP.

ENDFORM.                    "fill_fcat

*&---------------------------------------------------------------------*
*&      Form  add_data
*&---------------------------------------------------------------------*
* Заполняем дополнительные поля из FI (поиск документов, у которых
* BKTXT = MBLNR/CHARG и суммируем
*----------------------------------------------------------------------*
*      <--CS_OUTPUT  text
*----------------------------------------------------------------------*
FORM add_data CHANGING cs_output TYPE ts_output.
  DATA: lv_bukrs     TYPE bukrs,
        lv_belnr     TYPE belnr_d,
        lv_gjahr     TYPE gjahr,
        lv_bktxt     TYPE bktxt,

        lv_menge     TYPE menge_d,
        lv_menge1    TYPE menge_d,
        lv_dmbe1_kzt TYPE dmbtr,
        lv_dmbe1_usd TYPE dmbtr,
        lv_dmbtr     TYPE dmbtr,
        lv_dmbe2     TYPE dmbtr,
        lv_dmbe3     TYPE dmbtr.

  CLEAR: cs_output-dmbe1_kzt,
         cs_output-dmbe1_usd,
         cs_output-dmbe2_kzt,
         cs_output-dmbe2_usd,
         lv_dmbe1_kzt,
         lv_dmbe1_usd,
         lv_menge1.

  CONCATENATE cs_output-matnr cs_output-charg
  INTO lv_bktxt SEPARATED BY '/'.

  SHIFT lv_bktxt LEFT DELETING LEADING '0'.
  lv_gjahr = sy-datum(4).

  SELECT bukrs belnr gjahr
    INTO (lv_bukrs, lv_belnr, lv_gjahr)
    FROM bkpf
   WHERE gjahr = lv_gjahr
     AND blart = 'ZA'
     AND bktxt = lv_bktxt
     AND stblg = ''.

    SELECT dmbtr dmbe2 dmbe3 menge
      INTO (lv_dmbtr, lv_dmbe2, lv_dmbe3, lv_menge)
      FROM bseg
     WHERE belnr = lv_belnr
       AND gjahr = lv_gjahr
       AND bukrs = lv_bukrs
       AND shkzg = 'H'
      .
      ADD lv_dmbtr TO lv_dmbe1_kzt.
      ADD lv_dmbe2 TO lv_dmbe1_usd.
      ADD lv_menge TO lv_menge1.
    ENDSELECT.

  ENDSELECT.


  IF lv_menge1 > 0.
    cs_output-dmbe1_kzt = lv_dmbe1_kzt / lv_menge1 * cs_output-labst.
    cs_output-dmbe1_usd = lv_dmbe1_usd / lv_menge1 * cs_output-labst.

    cs_output-dmbe2_kzt = cs_output-wlabs - cs_output-dmbe1_kzt.
    cs_output-dmbe2_usd = cs_output-ziv_dmbe2 - cs_output-dmbe1_usd.

  ENDIF.
ENDFORM.                    "add_data
