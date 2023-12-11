{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/CODER/DRDOSLIB-TP)
  @abstract(Target: Turbo Pascal 7)
}

Unit IDLE;

INTERFACE

Const
 IDLE_COMMAND=$0001;
 IDLE_DOSFUNC=$0002;
 IDLE_ON=$4000;
 IDLE_ENABLE=$8000;

Type
 IDLE_STATE=Record
  Count:Word;
  Max:Word;
  Flags:Word;
  Vec:Pointer;
  Delay:Word;
  Reload:Word;
  InDos:Word;
 End;

IMPLEMENTATION

END.