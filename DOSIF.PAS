{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/CODER/DRDOSLIB-TP)
  @abstract(Target: Turbo Pascal 7)
}

Unit DOSIF;

INTERFACE

Uses COMMAND;

Function  Ioctl_Ver:Word;
Function  MS_Drv_Get:Word;
Procedure MS_Drv_Set(X:Byte);
Function  MS_F_GetVerify:Byte;
Function  MS_Idle_Ptr:Pointer;
Function  MS_P_GetPSP:Pointer;
Function  MS_S_Country(Var CountryInfo:INTERNAT):Word;
Function  MS_Switchar:Char;
Function  MS_X_Creat(FileName:PChar;Mode:Byte):Word;
Function  MS_X_FDup(DestHandle,CurrHandle:Word):Word;
Function  MS_X_Open(FileName:PChar;Mode:Byte):Word;
Function  MS_X_SetCP(GlobalCP:Word):Word;

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

END.