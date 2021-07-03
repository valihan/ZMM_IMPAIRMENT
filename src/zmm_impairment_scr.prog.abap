*&---------------------------------------------------------------------*
*&  Include           ZMM_IMPAIRMENT_SCR
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME." TITLE text-070.
SELECT-OPTIONS:
  s_matnr  FOR mara-matnr MEMORY ID mat MATCHCODE OBJECT mat1,
  s_werks  FOR t001l-werks  MEMORY ID wrk OBLIGATORY,                      "718285
  s_lgort  FOR t001l-lgort  MEMORY ID lag,
  s_charg  FOR mchb-charg  MEMORY ID cha MATCHCODE OBJECT mch1.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK lbs WITH FRAME." TITLE text-070.

SELECT-OPTIONS:
  s_matart FOR mara-mtart,
  s_matkla FOR mara-matkl,
  s_ekgrup FOR marc-ekgrp.

SELECTION-SCREEN END OF BLOCK lbs.

PARAMETERS: p_var TYPE disvariant-variant.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_var.
  PERFORM bspl_alv_variant_f4  USING sy-repid '' 'X' CHANGING p_var.
