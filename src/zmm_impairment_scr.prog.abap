*&---------------------------------------------------------------------*
*&  Include           ZMM_IMPAIRMENT_SCR
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1.
SELECT-OPTIONS:
  s_matnr  FOR mara-matnr MEMORY ID mat MATCHCODE OBJECT mat1,
  s_werks  FOR t001l-werks  MEMORY ID wrk,                      "718285
  s_lgort  FOR t001l-lgort  MEMORY ID lag,
  s_charg  FOR mchb-charg  MEMORY ID cha MATCHCODE OBJECT mch1.
SELECTION-SCREEN END OF BLOCK b1.
