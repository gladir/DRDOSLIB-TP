{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/CODER/DRDOSLIB-TP)
  @abstract(Target: Turbo Pascal 7)
}

Unit Support;

INTERFACE

Const
 CLS_KEY='$CLS=';
 REVON_KEY='$ON=';
 REVOFF_KEY='$OFF=';

 {$IFDEF DOSPLUS}
  CLS_DEF='033[2J\0***';
  REVON_DEF='\0********';
  REVOFF_DEF='\0********';
 {$ELSE}
  CLS_DEF='\033E\0*****';
  REVON_DEF='\033p\0*****';
  REVOFF_DEF='\033q\0*****';
 {$ENDIF}

Var
 Country:Record
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

Function Disp_FileTime(Time:Word):String;
Function IsDigit(b:Char):Boolean;
Function IsWild(Path:String):Boolean;
Function Is_Blank(s:String):Byte;
Function Is_FileChar(s:String):Boolean;
Function Is_PathChar(s:String):Boolean;
Function ToLower(b:Char):Char;

IMPLEMENTATION

Function PadLeft(Value:Integer;Space:Byte):String;
Var
 S:String;
Begin
 Str(Value,S);
 While Length(S)<Space do S:=' '+S;
 PadLeft:=S;
End;

Function PadZeroLeft(Value:Integer;Space:Byte):String;
Var
 S:String;
Begin
 Str(Value,S);
 While Length(S)<Space do S:='0'+S;
 PadZeroLeft:=S;
End;

Function Disp_FileTime(Time:Word):String;
Var
 h,m:Word;
 ap:Char;
Begin
 ap:=' ';
 h:=(time shr 11);
 m:=(time shr 5) and $3f;
 If(Country.AmPm=0)Then Begin
  ap:='a';
  If(h=0)Then h:=12 Else
  If(h>=12)Then Begin
   ap:='p';
   If(h>12)Then h:=h-12;
  End;
 End;
 Disp_FileTime:=PadLeft(h,2)+Country.dtime[0]+
                PadZeroLeft(m,2)+country.dtime[0]+ap;
End;

Function IsDigit(b:Char):Boolean;Begin
 IsDigit:=b in['0'..'9'];
End;

Function IsWild(Path:String):Boolean;
Var
 I:Integer;
Begin
 IsWild:=False;
 For I:=1 to Length(Path)do Begin
  If Path[I]in['*','?']Then Begin
   IsWild:=True;
   Exit;
  End;
 End;
End;

Function Is_Blank(s:String):Byte;
Var
 I:Integer;
Begin
 Is_Blank:=0;
 If(s=#$81#$40)Then Is_Blank:=2 (* Espace KANJI *)
  Else
 Begin
  For I:=1 to Length(s)do Begin
   If(s[I]in[#9,' '])Then Begin
    Is_Blank:=1;
    Exit;
   End;
  End;
 End;
End;

Function Is_FileChar(s:String):Boolean;
Var
 I:Integer;
Begin
 Is_FileChar:=True;
 If Length(s)=0 Then Is_FileChar:=False Else
 If Is_Blank(s)>0 Then Is_FileChar:=False
  Else
 Begin
  For I:=1 to Length(S)do Begin
   If(S[I]in[#0,'*','?','\','.',':',';',',','=','+','<','>',
              '|','/','"','[',']'])Then Begin
    Is_FileChar:=False;
    Exit;
   End;
  End;
 End;
End;

Function Is_PathChar(s:String):Boolean;Begin
 Is_PathChar:=False;
 If(Is_FileChar(s)or(s='\')or(s='.')or(s=':')or
   (s>=Chr(Byte('Z')+1))and(s<=Chr(Byte('Z')+6)))Then Is_PathChar:=True;
End;

Function ToLower(b:Char):Char;Begin
 If(b=#$8D)Then ToLower:='i' Else
 If b in['a'..'z']Then ToLower:=Chr(Ord(b)-32)
                  Else ToLower:=b;
End;

END.