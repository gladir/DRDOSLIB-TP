{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/CODER/DRDOSLIB-TP)
  @abstract(Target: Turbo Pascal 7)
}

Unit DOSIF;

INTERFACE

Uses COMMAND;

Var
 DBCS_Table_Ptr:Pointer;

Function  DBCS_Expected:Boolean;
Function  Ioctl_Ver:Word;
Function  MS_Drv_Get:Word;
Procedure MS_Drv_Set(X:Byte);
Function  MS_F_GetVerify:Byte;
Procedure MS_GetDate(Var Buffer:SYSDATE);
Procedure MS_GetDate_(Var Year,Month,Day,DayOfWeek:Word);
Function  MS_Idle_Ptr:Pointer;
Function  MS_P_GetPSP:Pointer;
Function  MS_S_Country(Var CountryInfo:INTERNAT):Word;
Procedure MS_SetDate(Var Buffer:SYSDATE);
Procedure MS_SetDate_(Year,Month,Day:Word);
Function  MS_Switchar:Char;
Function  MS_X_Close(Handle:Word):Word;
Function  MS_X_Creat(FileName:PChar;Mode:Byte):Word;
Function  MS_X_FDup(DestHandle,CurrHandle:Word):Word;
Function  MS_X_IoCtl(Handle:Word):Word;
Function  MS_X_LSeek(Handle:Word;Pos:LongInt;SeekMode:Byte):LongInt;
Function  MS_X_Open(FileName:PChar;Mode:Byte):Word;
Function  MS_X_SetCP(GlobalCP:Word):Word;
Function  MS_X_SetDev(Handle:Word;ValueToSet:Byte):Word;
Function  MS_X_Wait:Word;

IMPLEMENTATION

Uses DOS,MSDOS;

Const
 DOS_INT=$21;

Function MS_Drv_Get:Word;Assembler;ASM
 MOV AH,MSDOS.MS_DRV_GET
 INT DOS_INT
 CBW
END;

Procedure MS_Drv_Set(X:Byte);Assembler;ASM
 MOV DL,X
 MOV AH,MSDOS.MS_DRV_SET
 INT DOS_INT
END;

Function MS_F_GetVerify:Byte;Assembler;ASM
 MOV AH,MSDOS.MS_F_GETVERIFY
 INT DOS_INT
 CBW
END;

Function MS_Idle_Ptr:Pointer;Assembler;ASM
 PUSH ES
  PUSH SI
   PUSH DI
    MOV	AX,4458h
    INT DOS_INT
    MOV DX,ES
   POP DI
  POP SI
 POP ES
END;

Function MS_P_GetPSP:Pointer;Assembler;ASM
 MOV  AH,51h
 INT  DOS_INT
 XCHG AX,BX
END;

Function MS_S_Country(Var CountryInfo:INTERNAT):Word;
Var
 Regs:Registers;
Begin
 Regs.AX:=MSDOS.MS_S_COUNTRY shl 8;
 Regs.DS:=Seg(CountryInfo);
 Regs.DX:=Ofs(CountryInfo);
 Intr($21,Regs);
 MS_S_Country:=Regs.BX;
End;

Function MS_Switchar:Char;Assembler;ASM
 MOV AX,3700h
 INT DOS_INT
 SUB AH,AH
 MOV AL,DL
END;

Function Ioctl_Ver:Word;Assembler;ASM
 {$IFDEF DOSPLUS}
  MOV AX,4452h
 {$ELSE}
  MOV AX,4451h
 {$ENDIF}
 INT DOS_INT
 JC  @cdos_v10
 AND AX,Not 0200h
 JMP @Finish
@cdos_v10:
 XOR AX,AX
@Finish:
END;

Function MS_X_Close(Handle:Word):Word;Assembler;ASM
 MOV BX,Handle
 MOV AH,MSDOS.MS_X_CLOSE
 INT DOS_INT
 JNC @ms_dos_ok
 NEG AX
 JMP @ms_dos_ret
@ms_dos_ok:
 SUB AX,AX
@ms_dos_ret:
END;

Function MS_X_Creat(FileName:PChar;Mode:Byte):Word;Assembler;ASM
 PUSH DS
  MOV AH,MSDOS.MS_X_CREAT
  LDS DX,FileName
  MOV AL,Mode
  INT DOS_INT
 POP DS
 JNC @ms_creat_ret
 NEG AX
@ms_creat_ret:
END;

Function MS_X_FDup(DestHandle,CurrHandle:Word):Word;Assembler;ASM
 MOV CX,DestHandle
 MOV BX,CurrHandle
 MOV AH,MSDOS.MS_X_DUP2
 INT DOS_INT
 JNC @ms_dos_ok
 NEG AX
 JMP @ms_dos_ret
@ms_dos_ok:
 SUB AX,AX
@ms_dos_ret:
END;

Function MS_X_IoCtl(Handle:Word):Word;Assembler;ASM
 MOV BX,Handle
 MOV AH,MSDOS.MS_X_IOCTL
 MOV AL,0
 INT DOS_INT
 JNC @ms_x_i10
 NEG AX
@ms_x_i10:
END;

Function MS_X_LSeek(Handle:Word;Pos:LongInt;SeekMode:Byte):LongInt;Assembler;ASM
 MOV AH,MSDOS.MS_X_LSEEK
 MOV BX,Handle
 MOV DX,Pos.Word[0]
 MOV CX,Pos.Word[2]
 MOV AL,SeekMode
 INT DOS_INT
 JNC @ms_lseek_ok
 NEG AX
 CWD
@ms_lseek_ok:
 MOV BX,DX
END;

Function MS_X_Open(FileName:PChar;Mode:Byte):Word;Assembler;ASM
 PUSH DS
  MOV AH,MSDOS.MS_X_OPEN
  LDS DX,FileName
  MOV AL,Mode
  INT DOS_INT
 POP DS
 JNC @ms_open_ret
 NEG AX
@ms_open_ret:
END;

Function MS_X_SetCP(GlobalCP:Word):Word;Assembler;ASM
 MOV BX,GlobalCP
 MOV AX,MSDOS.MS_X_SETCP
 INT DOS_INT
 JC  @ms_x_getcp10
 XOR AX,AX
 JMP @Finish
@ms_x_getcp10:
 NEG AX
@Finish:
END;

Function MS_X_SetDev(Handle:Word;ValueToSet:Byte):Word;Assembler;ASM
 MOV BX,Handle
 MOV DL,ValueToSet
 SUB DH,DH
 MOV AH,MSDOS.MS_X_IOCTL
 MOV AL,1
 INT DOS_INT
 JNC @ms_x_sd10
 NEG AX
@ms_x_sd10:
END;

Function MS_X_Wait:Word;Assembler;ASM
 MOV AH,MSDOS.MS_X_WAIT
 INT DOS_INT
END;

Procedure MS_GetDate(Var Buffer:SYSDATE);Assembler;ASM
 MOV AH,MSDOS.MS_T_GETDATE
 INT DOS_INT
 LES BX,Buffer
 MOV ES:[BX].SYSDATE.Year,CX
 XCHG DH,DL
 MOV ES:[BX].SYSDATE.Month,DH
 MOV ES:[BX].SYSDATE.Day,DL
 MOV ES:[BX].SYSDATE.DOW,AL
END;

Procedure MS_GetDate_(Var Year,Month,Day,DayOfWeek:Word);Assembler;ASM
 MOV AH,2Ah
 INT DOS_INT
 XOR AH,AH
 LES DI,DayOfWeek
 STOSW
 MOV AL,DL
 LES DI,Day
 STOSW
 MOV AL,DH
 LES DI,Month
 STOSW
 XCHG AX,CX
 LES DI,Year
 STOSW
END;

Procedure MS_SetDate_(Year,Month,Day:Word);Assembler;ASM
 MOV CX,Year
 MOV DH,BYTE PTR Month
 MOV DL,BYTE PTR Day
 MOV AH,2Bh
 INT 21h
END;

Procedure MS_SetDate(Var Buffer:SYSDATE);Assembler;ASM
 LES BX,Buffer
 MOV CX,ES:[BX].SYSDATE.Year
 MOV DH,ES:[BX].SYSDATE.Month
 MOV DL,ES:[BX].SYSDATE.Day
 MOV AH,2Bh
 INT 21h
END;

Function DBCS_Expected:Boolean;Assembler;ASM
 PUSH DS
  PUSH SI
   LDS SI,DBCS_Table_Ptr
   LODSW
   TEST AX,AX
   JZ	@de_exit
   MOV AX,1
@de_exit:
  POP SI
 POP DS
END;

BEGIN
 DBCS_Table_Ptr:=NIL;
END.