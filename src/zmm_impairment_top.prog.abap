*&---------------------------------------------------------------------*
*&  Include           ZMM_IMPAIRMENT_TOP
*&---------------------------------------------------------------------*

TABLES: t001w, t001l, mara, mchb, marc.

TYPES: BEGIN OF ts_output.
TYPES:   "checkbox           TYPE c,
  color  TYPE char4,
  matnr  LIKE mara-matnr,
  werks  LIKE t001w-werks,
  lgort  LIKE mard-lgort,
  sobkz  LIKE mkol-sobkz,
  ssnum  LIKE bickey-ssnum,
  pspnr  LIKE mspr-pspnr,
  vbeln  LIKE mska-vbeln,
  posnr  LIKE mska-posnr,
  lifnr  LIKE mkol-lifnr,
  kunnr  LIKE msku-kunnr,
  kzbws  LIKE mssa-kzbws,
  charg  LIKE mchb-charg,
*        Additional data (texts, unit, ...)
  maktx  LIKE marav-maktx,
  bwkey  LIKE mbew-bwkey,
  mtart  LIKE marav-mtart,
  matkl  LIKE marav-matkl,
  meins  LIKE marav-meins,
  bwtty  LIKE marc-bwtty,
  xchar  LIKE marc-xchar,
  lgobe  LIKE t001l-lgobe,
  bwtar  LIKE mcha-bwtar,
  waers  LIKE t001-waers,
  name1  LIKE t001w-name1,
*        Quantities and currencies
  labst  LIKE mard-labst,
  wlabs  LIKE mbew-salk3,
  insme  LIKE mard-insme,
  winsm  LIKE mbew-salk3,
  speme  LIKE mard-speme,
  wspem  LIKE mbew-salk3,
  einme  LIKE mard-einme,
  weinm  LIKE mbew-salk3,
  retme  LIKE mard-retme,
  wretm  LIKE mbew-salk3,
  umlme  LIKE mard-umlme,
  wumlm  LIKE mbew-salk3,
  glgmg  LIKE marc-glgmg,                                   "n912093
  wglgm  LIKE mbew-salk3,                                   "n912093
  trame  LIKE marc-trame,                                   "n912093
  wtram  LIKE mbew-salk3,                                   "n912093
  umlmc  LIKE marc-umlmc,                                   "n912093
  wumlc  LIKE mbew-salk3,                                   "n912093

*        Dummy field
  dummy  TYPE  alv_dummy,
*        Colour
  farbe  TYPE slis_t_specialcol_alv,
  lvorm  LIKE  mard-lvorm,

*        valuated blocked GR stock                       "AC0K020254
  bwesb  LIKE  marc-bwesb,                                  "AC0K020254
  wbwesb LIKE  mbew-salk3.                                  "AC0K020254

TYPES:
  dmbe1_kzt  TYPE dmbtr,
  dmbe1_usd  TYPE dmbtr,
  dmbe2_kzt  TYPE dmbtr,
  dmbe2_usd  TYPE dmbtr.

types
: ziv_waers_dmbe2 type t001-waers
, ziv_dmbe2 type CKMLCR-SALK3
, ziv_MFRPN type mara-MFRPN
, ziv_serial type i
, ziv_konts type t030-konts
.
TYPES:END OF ts_output.

DATA:      gt_output TYPE TABLE OF ts_output,
           gt_cat TYPE slis_t_fieldcat_alv.
