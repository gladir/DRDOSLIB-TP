{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/CODER/DRDOSLIB-TP)
  @abstract(Target: Turbo Pascal 7)
}

Unit COMMAND;

INTERFACE

Type
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

IMPLEMENTATION

END.