{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/CODER/DRDOSLIB-TP)
  @abstract(Target: Turbo Pascal 7)
}

Unit SECURITY;

INTERFACE

Const
 FNAME_LOGIN_TXT='LOGIN.TXT';
 FNAME_LOCK_TXT='LOCK.TXT';
 FNAME_LOGIN_ERR='LOGIN.ERR';
 FNAME_LOCK_ERR='LOCK.ERR';

 FNAME_USER_INF='USER.INF';
 SIG_USER_INF=$4955;

 USERID_LGTH=4;
 SYS_NAME_LGTH=12;
 DEFACCESS_LGTH=9;
 DATE_LGTH=10;
 TIME_LGTH=8;
 CMNT_LGTH=32;

 PATH_LEN=65;

 DEFLT_SU_NAME='Superuser';
 DEFLT_SU_GROUP='Supergroup';
 FNAME_USER_SYS='USER.SYS';
 SIG_USER_SYS=$5355;

 FNAME_LOGIN_LOG='LOGIN.LOG';
 SIG_LOGIN_LOG=$4C4C;

 LOG_LOGIN=0;
 LOG_LOGOUT=1;
 LOG_LOCK=2;
 LOG_UNLOCK=3;
 LOG_REBOOT=4;
 LOG_POWERON=5;

 ERR_BASE=0;
 ERR_USERPWORD=ERR_BASE-1;
 ERR_NOFILE=ERR_BASE-2;
 ERR_OPENFILE=ERR_BASE-3;
 ERR_BADFILE=ERR_BASE-4;
 ERR_READFILE=ERR_BASE-5;
 ERR_WRITEFILE=ERR_BASE-6;
 ERR_BADID=ERR_BASE-7;
 ERR_FATALSYSTEM=ERR_BASE-8;
 ERR_LOGIN=ERR_BASE-9;
 ERR_LOGOUT=ERR_BASE-10;
 ERR_LOCK=ERR_BASE-11;
 ERR_UNLOCK=ERR_BASE-12;

 SYS_PWORD_MINLEN=3;
 SYS_PWORD_MIN=6;
 SYS_PWORD_MAX=SYS_NAME_LGTH;

 ACCESS_ATTEMPTS=1000;

Type
 INF_HEADER_ENTRY=Record
  Signature:Word;
  Version:Byte;
  CrLf:Array[0..1]of Char;
 End;

 USER_INF_ENTRY=Record
  UserId:Array[0..USERID_LGTH]of Char;
  LoginName:Array[0..SYS_NAME_LGTH]of Char;
  GroupName:Array[0..SYS_NAME_LGTH]of Char;
  DefAccess:Array[0..DEFACCESS_LGTH]of Char;
  HomeDrv:Array[0..1]of Char;
  HomeDir:Array[0..PATH_LEN]of Char;
  Date:Array[0..DATE_LGTH]of Char;
  Time:Array[0..TIME_LGTH]of Char;
  Comment:Array[0..CMNT_LGTH]of Char;
  CrLf:Array[0..1]of Char;
 End;

 USER_SYS_ENTRY=Record
  UserId:Word;
  PWord:LongInt;
 End;

 SYSDAT=Record
  Year:Word;
  Month:Byte;
  Day:Byte;
  Day_of_week:Byte;
 End;

 SYSTIM=Record
  Hour:Byte;
  Minute:Byte;
  Second:Byte;
  Hundredth:Byte;
 End;

 LOGIN_LOG_ENTRY=Record
  UserId:Word;
  Station:Word;
  Event:Word;
  Time:SYSTIM;
  Date:SYSDAT;
 End;

Function ID_NUM(n:Word):Word;
Function ID_GROUP(n:Word):Word;
Function ID_GRP_USR(g,u:Word):Word;

IMPLEMENTATION

{@description: Cette fonction permet d'extraire le num‚ro d'utilisateur
               d'un identificateur de 16 bits.
}

Function ID_NUM(n:Word):Word;Begin
 ID_NUM:=n and $00FF;
End;

{@description: Cette fonction permet d'extraire le num‚ro
               de groupe d'un identificateur de 16 bits.
}

Function ID_GROUP(n:Word):Word;Begin
 ID_GROUP:=n shr 8;
End;

{@description: Cette fonction permet d'extraire le num‚ro
               de groupe/identificateur d'un identificateur 16 bits.
}

Function ID_GRP_USR(g,u:Word):Word;Begin
 ID_GRP_USR:=(g shl 8)+u;
End;

END.