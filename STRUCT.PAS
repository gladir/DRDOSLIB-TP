{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/CODER/DRDOSLIB-TP)
  @abstract(Target: Turbo Pascal 7)
}

Unit STRUCT;

INTERFACE

Const
 FCB_NAME=1;
 FCB_SIZE=32;
 FCB_NAME_SIZE=11;
 FCB_EXTENT=12;
 FCB_CS=13;
 FCB_RC=15;
 FCB_ALUS=16;

Type
 xios_iopb=Record
  Drv:Byte;
  MCnt:Byte;
  Track:Word;
  Sector:Word;
  Dma_Buffer:Pointer;
 End;

 xios_dpb=Record
  spt:Word;
  bsh:Byte;
  blm:Byte;
  exm:Byte;
  dsm:Word;
  drm:Word;
  al0:Byte;
  al1:Byte;
  cks:Word;
  off:Word;
  psh:Byte;
  prm:Byte;
 End;

 segoff=Record
  Off:Word;
  Seg:Word;
 End;

 f_data=Record
  Srch_Attrib:Byte;
  Cur_Drive:Byte;
  Media:Byte;
  Pattern:Array[0..FCB_NAME_SIZE-1]of Byte;
  Cur_Alu:Word;
  Cur_Index:Word;
  Filler:Array[0..2]of Byte;
  Fnd_attrib:Byte;
  Time:Word;
  Date:Word;
  File_Size:LongInt;
  File_name:Array[0..62]of Char;
 End;

IMPLEMENTATION

END.
