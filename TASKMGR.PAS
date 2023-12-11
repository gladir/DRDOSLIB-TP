{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/CODER/DRDOSLIB-TP)
  @abstract(Target: Turbo Pascal 7)
}

Unit TASKMGR;

INTERFACE

Const
 PseudoMaxTasks=5000;

Type
 TaskName=String[8];
 IDTable=Array[0..PseudoMaxTasks]of Word;
 PIDTable=^IDTable;
 TaskNameC=Array[0..7]of Char;
 NameTable=Array[0..PseudoMaxTasks]of TaskNameC;
 PNameTable=^NameTable;

Function  TaskMgrCheckOpenFiles(TaskIndex:word):Word;
Function  TaskMgrGetForegroundTaskIndex:Word;
Function  TaskMgrGetNameTablePointer:PNameTable;
Function  TaskMgrGetPerTaskEMSlimit:Word;
Procedure TaskMgrGetStatus(Var Tasks,MaximumTasks,ForegroundTaskIndex:Word);
Procedure TaskMgrGetSwapSpaceInfo(Var AvailableKB,TotalKB:Word);
Function  TaskMgrGetTaskName(Index:Word):TaskName;
Procedure TaskMgrGetVersion(Var MajorVersion,MinorVersion:Byte);
Function  TaskMgrIDToIndex(ID:Word):Word;
Function  TaskMgrIndexToID(Index:Word):Word;
Function  TaskMgrInstall:Boolean;
Procedure TaskMgrNameTask(TaskIndex:Word;Const Name:TaskName;Var Flag:Byte;Var ID:Word);
Procedure TaskMgrNameTaskC(TaskIndex,NSeg,NOfs:Word;Var Flag:Byte;Var ID:Word);
Function  TaskMgrReleaseTimeSlice:Boolean;
Procedure TaskMgrShell(Const ComLine:String);
Procedure TaskMgrSwitchTo(TaskIndex:Word);
Procedure TaskMgrSwitchToTaskManager;

IMPLEMENTATION

Uses DOS;

Function TaskMgrInstall:Boolean;Assembler;ASM
 MOV AX,02700h
 INT 02Fh
 CMP AL,0FFh
 MOV AL,000h
 JNZ @@F01non
 INC AX
@@F01non:
END;

Procedure TaskMgrGetStatus(Var Tasks,MaximumTasks,ForegroundTaskIndex:Word);Assembler;ASM
 MOV AX,02701h
 INT 02Fh
 LES DI,Tasks
 MOV ES:[DI],CX
 LES DI,MaximumTasks
 MOV ES:[DI],AX
 LES DI,ForegroundTaskIndex
 MOV ES:[DI],BX
END;

Procedure TaskMgrGetVersion(Var MajorVersion,MinorVersion:Byte);Assembler;ASM
 MOV AX,02701h
 INT 02Fh
 LES DI,MajorVersion
 MOV ES:[DI],DL
 LES DI,MinorVersion
 MOV ES:[DI],DH
END;

Function TaskMgrGetNameTablePointer:PNameTable;Assembler;ASM
 MOV AX,02701h
 INT 02Fh
 MOV DX,ES
 XCHG AX,DI {resultat <- Pointeur(DX,AX) }
END;

Function TaskMgrGetForegroundTaskIndex:Word;Assembler;ASM
 MOV AX,02701h
 INT 02Fh
 XCHG AX,BX
END;

Function TaskMgrGetPerTaskEMSlimit:Word;Assembler;ASM
 MOV AX,02702h
 INT 02Fh
 XCHG AX,DX
END;

Procedure TaskMgrSetPerTaskEMSLimit(Limit:Word;Var NewLimit:Word);Assembler;ASM
 MOV AX,02703h
 MOV DX,Limit
 INT 02Fh
 LES DI,NewLimit
 MOV ES:[DI],DX
END;

Procedure TaskMgrSwitchTo(TaskIndex:Word);Assembler;ASM
 MOV AX,02706h
 MOV DX,TaskIndex
 INT 02Fh
END;

Procedure TaskMgrSwitchToTaskManager;Assembler;ASM
 MOV AX,02715h
 INT 02Fh
END;

Function TaskMgrReleaseTimeSlice:Boolean;Assembler;ASM
 MOV AX,01680h
 INT 02Fh
 AND AX,AX
 MOV AL,0
 JNZ @PasDepret
 INC AX
@PasDepret:
END;

Function TaskMgrGetTaskName(Index:Word):TaskName;
Var
 R:TaskName;
 N:TaskNameC;
Begin
 N:=TaskMgrGetNameTablePointer^[Index];
 R:='';
 While(Length(R)<=7)and(N[length(R)]<>#0)do R:=R+N[Length(R)];
 TaskMgrGetTaskName:=R
End;

Procedure TaskMgrNameTaskC(TaskIndex,NSeg,NOfs:Word;Var Flag:Byte;Var ID:Word);Assembler;ASM
 PUSH DS
  MOV AX,02709h
  MOV DX,TaskIndex
  MOV BX,NSeg
  MOV CX,NOfs
  MOV DS,BX
  MOV SI,CX
  INT 02Fh
  LES DI,Flag
  MOV ES:[DI],AL
  LES DI,ID
  MOV ES:[DI],BX
 POP DS
END;

Procedure TaskMgrNameTask(TaskIndex:Word;Const Name:TaskName;Var Flag:Byte;Var ID:Word);
Var
 NameC:TaskNameC;
 I,L:Byte;
Begin
 FillChar(NameC,SizeOf(NameC),0);
 L:=Length(Name);
 If L>8Then L:=8;
 For I:=1to(L)do NameC[I-1]:=Name[I];
 TaskMgrNameTaskC(TaskIndex,Seg(NameC),Ofs(NameC),Flag,ID);
End;

Function TaskMgrIndexToID(Index:Word):Word;Assembler;ASM
 MOV AX,0270Ah
 MOV DX,Index
 INT 02Fh
 XCHG AX,DX
END;

Function TaskMgrIDToIndex(ID:Word):Word;Assembler;ASM
 MOV AX,0270Bh
 MOV DX,ID
 INT 02Fh
 XCHG AX,DX
END;

Function TaskMgrCheckOpenFiles(TaskIndex:word):Word;Assembler;ASM
 MOV AX,0270Ch
 MOV DX,TaskIndex
 INT 02Fh
END;

Procedure TaskMgrGetSwapSpaceInfo(Var AvailableKB,TotalKB:Word);Assembler;ASM
 MOV AX,02714h
 INT 02Fh
 LES DI,AvailableKB
 MOV ES:[DI],DX
 LES DI,TotalKB
 MOV ES:[DI],CX
END;

Procedure TaskMgrShell(Const ComLine:String);

 Procedure Command(Const CP:String);Begin
  SwapVectors;
  Exec(GetEnv('OPENDOSCFG')+'\TASKMGR.EXE','/C'+CP);
  SwapVectors
 End;

Begin
 If(TaskMgrInstall)Then Begin
  If ComLine=''Then Command(GetEnv('COMSPEC'))
               Else Command(ComLine)
 End;
End;


END.