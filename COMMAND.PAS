{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/CODER/DRDOSLIB-TP)
  @abstract(Target: Turbo Pascal 7)
}

Unit COMMAND;

INTERFACE

Const
 SWITCH_ENABLED=1;
 DOSPLUS=1;
 BETA=1;
 PASSWORD=1;

  { D‚finitions du processeur de ligne de commande DOS Plus }
 PIPE_CHAR='|';
 MULTI_CHAR='!';
 BACK_CHAR='&';
 ESC_CHAR='~';
 MAX_PATHLEN=131;
 MAX_FILELEN=140;
 MAX_ENVLEN=255;
 DEFAULT_PROMPT='$n$g';
 MAX_MEMSIZE=1000;
 MAX_LIMSIZE=8192;

  { Les d‚finitions suivantes sont utilis‚es pour contr“ler la
    redirection de la console, les tuyaux, l'‚tat de l'‚cho,... }
 REDIR_ACTIVE=$0001;
 REDIR_BATCH=$0002;
 REDIR_PIPE=$0004;
 REDIR_FOR=$0008;

 ECHO_ON=$0001;
 ECHO_OFF=$0000;

 XBATCH_ON=$0001;
 XBATCH_OFF=$0000;

  { Les d‚finitions suivantes sont des codes d'erreur ®LONGJMP¯
    utilis‚s pour sp‚cifier la cause de l'abandon interne. }
 IA_BREAK=1;
 IA_STACK=2;
 IA_HEAP=3;
 IA_FILENAME=4;

  { Valeurs possibles de needparam dans S_CMD. }

 PARAM_NONE=0;
 PARAM_NEEDFILE=1;
 PARAM_NEEDPATH=2;
 PARAM_NEEDDEV=3;
 PARAM_SYNTAX=4;
 PARAM_IFCONTEXT=6;

  { Masques de bits d'attribut de fichier DOS }
 ATTR_RO=$0001;
 ATTR_HID=$0002;
 ATTR_SYS=$0004;
 ATTR_STD=(ATTR_SYS or ATTR_RO);
 ATTR_ALL=$0014;
 ATTR_LBL=$0008;
 ATTR_DIR=$0010;
 ATTR_DEV=$0040;

 STDIN=0;
 STDOUT=1;
 STDERR=2;
 STDAUX=3;
 STDPRN=4;
 STDCON=5;

 OPEN_RO=$0000;
 OPEN_WO=$0001;
 OPEN_RW=$0002;

 OPEN_DRW=$0010;
 OPEN_DW=$0020;
 OPEN_DR=$0030;
 OPEN_DN=$0040;
 OPEN_NI=$0080;

 OPEN_READ=(OPEN_RO or OPEN_DW);
 OPEN_WRITE=(OPEN_WO or OPEN_DRW);
 OPEN_RDWR=(OPEN_RW or OPEN_DRW);

Type
 SYSDATE=Record
  Year:Word;
  Month:Byte;
  Day:Byte;
  DOW:Byte;
 End;

 SYSTIME=Record
  Hour:Byte;
  Min:Byte;
  Sec:Byte;
  HSec:Byte;
 End;

 DTA=Record
  resvd:Array[0..20]of Byte;
  FAttr:Byte;
  FTime:Word;
  FDate:Word;
  FSize:LongInt;
  FName:Array[0..12]of Byte;
 End;

 INTERNAT=Record
  dt_fmt:Word;
  Currcy:Array[0..4]of Char;
  d1000:Array[0..1]of Char;
  ddecm:Array[0..1]of Char;
  ddate:Array[0..1]of Char;
  dtime:Array[0..1]of Char;
  cflg:Byte;
  cdec:Byte;
  ampm:Byte;
  Internl:Array[0..13]of Byte;
  Code:Word;
 End;

Function FP_OFF(P:LongInt):Word;
Function FP_SEG(P:LongInt):Word;
Function MK_FP(Seg,Ofs:Word):LongInt;


IMPLEMENTATION

Function FP_OFF(P:LongInt):Word;Begin
 FP_OFF:=P and $FFFF;
End;

Function FP_SEG(P:LongInt):Word;Begin
 FP_SEG:=P shr 16;
End;

Function MK_FP(Seg,Ofs:Word):LongInt;Begin
 MK_FP:=LongInt(Seg shl 16)or LongInt(Ofs);
End;

END.