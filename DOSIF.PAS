{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/CODER/DRDOSLIB-TP)
  @abstract(Target: Turbo Pascal 7)
}

Unit DOSIF;

INTERFACE

Function  Ioctl_Ver:Word;
Function  MS_F_GetVerify:Byte;
Function  MS_Idle_Ptr:Pointer;
Function  MS_P_GetPSP:Pointer;
Function  MS_Switchar:Char;
Function  MS_X_SetCP(GlobalCP:Word):Word;

IMPLEMENTATION

Uses MSDOS;

Const
 DOS_INT=$21;

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