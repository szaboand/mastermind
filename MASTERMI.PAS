Program MasterMi;
{****************************************************************************}
{***                                                                      ***}
{***                             MasterMind V1.0a                         ***}
{***                           2000.10.19.-2000.10.19.                    ***}
{***               (C) TwinNet Ltd 1997,2000 (P) Szab¢ Andr†s 2000        ***}
{***                  E-mail: szaboand@mail.petrikl.sulinet.hu            ***}
{***                    WWW: http://www.twinnet.hu/szaboand               ***}
{***                            All Rights Reserved                       ***}
{***                                                                      ***}
{****************************************************************************}
{***                            DOS VERZI‡                                ***}
{***                        TURBO PASCAL 7.0 FILE                         ***}
{****************************************************************************}

{$A+,B-,D+,E+,F+,G+,I+,L+,N-,O-,P-,Q+,R+,S+,T-,V+,X+}
{$M 32768,0,655360}
Uses TWSys{2.0d},TObject{4.3},TObjects{4.1e};

{****************************************************************************}
{***                              Konstansok                              ***}
{****************************************************************************}

Const
 VMode                 :  word    = _640x480_256;   { Vide¢m¢d k¢dja         }
 ProgramName           :  string  = 'MasterMind V1.0a (C) Szab¢ Andr†s 2000';
 Info1                 :  string  = 'e-mail:szaboand@mail.petrikl.sulinet.hu';
 MDVX                  :  word    = $0003;  { Mouse X oszt†sar†ny (SHR)      }
 MDVY                  :  word    = $0003;  { Mouse X oszt†sar†ny (SHR)      }
 PixRat                :  word    = $0001;  { Mouse Pixel/Ratio              }
 MouseAct              :  boolean = TRUE;   { Saj†t mouse megjelen°tÇs       }
 BackgroundColor       :  byte    = $07;    { H†ttÇrszin                     }
 DBackgroundColor      :  byte    = $08;    { SîtÇt h†ttÇrszin               }
 DDBackgroundColor     :  byte    = $00;    { SîtÇt h†ttÇrszin               }
 LBackgroundColor      :  byte    = $0F;    { Vil†gos h†ttÇrszin             }
 InfoTextColor         :  byte    = $0F;    { Info textszin                  }
 DInfoTextColor        :  byte    = $08;    { SîtÇt info textszin            }
 TimeTextColor         :  byte    = $08;    { Idã textsz°n                   }

 _ExitButtonCode                  = $0001;       { Command k¢dok             }
 _StartButtonCode                 = $0002;


 _ExitButtonString                = '  KilÇp  ';   { Button feliratok       }
 _StartButtonString               = '  Start  ';
 _OKButtonString                  = '    OK    ';
 _CancelButtonString              = '  MÇgse  ';


 KInfoTextColor                   = 253;
 KInfReg               : shortint = 63;
 KPlus                 : shortint = -1;
 maxSInfo                         = 4;
 ActSInfo              : byte     = 1;
 SInfo                 : array [1..MaxSInfo] of string[37]
                         = ('   MASTERMIND V1.0 - Szab¢ Andr†s  ',
                            '  szaboand@mail.petrikl.sulinet.hu ',
                            '       http://www.twinnet.hu       ',
                            '       TwinNet Kft. 1997,2000      ');
  _WTime                : integer  = 0;

{****************************************************************************}
{***                               T°pusok                                ***}
{****************************************************************************}
Type

 MyButtonType   = object(ButtonType)
  Procedure DoButton;virtual;
  Procedure SetInit;virtual;
 end;

 TimeType       = object(TextType)
  TF           : boolean;
  Time         : word;
  Constructor  Init(IDd,XX,YY:word);
  Procedure    SetInit;virtual;
  Procedure    Draw;virtual;
  Procedure    Timer;virtual;
 end;

{****************************************************************************}
{***                               V†ltoz¢k                               ***}
{****************************************************************************}

Var
 ExitButton           : MyButtonType;
 StartButton          : MyButtonType;
 OKButton             : MyButtonType;
 CancelButton         : MyButtonType;
 TimeText             : TimeType;

 CommandCode          : word;

{****************************************************************************}
{***                               HELP                                   ***}
{****************************************************************************}

Procedure TextHelp;
Begin
WriteLn;
WriteLn(ProgramName);
WriteLn;
End;

Procedure HaltError(MSG:string);
Begin
Asm mov  ax,0003h;int 10h End;
WriteLn('Fatal Error! '+MSG);Halt;
End;

{****************************************************************************}
{***                    MyButtonType objektum met¢dusai                   ***}
{****************************************************************************}

Procedure MyButtonType.DoButton;
Begin
CommandCode:=ID;
End;

Procedure MyButtonType.SetInit;
Begin
End;

{****************************************************************************}
{***                         TimeType objektum met¢dusai                  ***}
{****************************************************************************}

Constructor TimeType.Init(IDd,XX,YY:word);
Begin
Inherited Init(IDd,XX,YY,11,2,nil);
End;

Procedure TimeType.SetInit;
Begin
Chars:=1;LineSpace:=1;DY:=CDY*(8+LineSpace);
TextColor:=TimeTextColor;TextBackColor:=BackgroundColor;
End;

Procedure TimeType.Timer;
Begin
Draw;
End;

Procedure TimeType.Draw;
var t:string;tt:^byte;mh:boolean;
Begin
If _WTime>0 then Dec(_WTime);
KInfReg:=KInfReg+KPlus;If (KInfReg>62) or (KInfReg<1) then KPlus:=-KPlus;
If (KInfReg>0) and (KInfReg<64) then SetRGBReg(KInfotextColor,KInfReg,KInfReg,KInfReg);
If KinfReg<1
 then begin
      Inc(ActSInfo);If ActSInfo>MaxSInfo then ActSInfo:=1;
      SetColor(KInfoTextColor);SetTextBackColor(0);ROM_8x14;
      MouseHide;OutStringXY(110,GetMaxY-20,SInfo[ActSInfo]);MouseShow;
      end;
If Time<18 then begin Inc(Time);Exit;end;
T:='TEKI '+GetTimeStr(0);
If TF then T:=T+' ' else T:=T+'.';TF:=Not(TF);
T:=T+chr(10)+GetDateStr(false)+chr(0);
TT:=@T;Inc(TT);TextPointer:=TT;mh:=false;
If (GetMouseX<X+DX+16) and (GetMouseY+16>Y) then begin mh:=true;MouseHide;end;
Inherited Draw;
If MH then MouseShow;
Time:=0;
End;

{****************************************************************************}
{***                         Inicializ†l†sok                              ***}
{****************************************************************************}

Function Init_Video:word;
var I:word;
Begin
If SetGraphMode(VMode)<>0 then begin Init_Video:=1;Exit;end;
SetColor(1);Bar(0,0,GetMaxX-1,3*GetMaxY-1);SetBorder(BackGroundColor);
SetColor(BackGroundColor);Bar(0,GetMaxY-26,GetMaxX-1,GetMaxY-1);
BorderDraw_2b(2,GetMaxY-25,90,18,BackGroundColor,DBackGroundColor,LBackGroundColor);
BorderDraw_2b(100,GetMaxY-25,GetMaxX-340,18,0,DBackGroundColor,LBackGroundColor);
Init_Video:=0;
End;

Function Init_Mouse:byte;
Begin
If MouseInit(MouseAct,PixRat,MDVX,MDVY)=0
   then Init_Mouse:=1
   else begin Init_Mouse:=0;MouseShow;end;
End;

Procedure VideoDone;
Begin
Asm mov  ax,0003h;int 10h End;
WriteLn(ProgramName);
End;

{****************************************************************************}
{***                  Objektumok inicializ†l†sa/lez†r†sa                  ***}
{****************************************************************************}

Procedure ObjectInit;
Begin
StartButton.Init(_StartButtonCode,GetMaxX-168,GetMaxY-24,_StartButtonString);
ExitButton.Init(_ExitButtonCode,GetMaxX-84,GetMaxY-24,_ExitButtonString);
TimeText.Init(0,6,GetMaxY-21);TimeText.Time:=20;
SetTimer(1,1,0,0,Seg(TimeText),Ofs(TimeText));
End;

Procedure ObjectDone;
Begin
SetTimer(1,0,0,0,0,0);
TimeText.Done;
ExitButton.Done;
StartButton.Done;
End;

{****************************************************************************}
{***                     Inicializ†l†s/lez†r†s                            ***}
{****************************************************************************}

Procedure Init;
Begin
If Init_Video<>0
 then begin WriteLn('Nem sikerÅlt a videom¢d inicializ†l†sa!');Halt;end;
Init_Mouse;
ObjectInit;
End;

Procedure Done;
Begin
ObjectDone;
VideoDone;
End;

{****************************************************************************}
{***                             Fãprogram                                ***}
{****************************************************************************}

Procedure Main;
var I:byte;
Begin
ClearCommandPuffer;I:=0;
repeat
 Case I of
      0 : begin end;
      1 : repeat TObjectProcess until (CommandCode<>0) or (SystemExitFlag);
       end;
 Inc(I);If I>6 then I:=1;
until (CommandCode=_ExitButtonCode) or (SystemExitFlag);
End;

{****************************************************************************}
{****************************************************************************}
{****************************************************************************}

BEGIN
Randomize;
Init;
TProcOn;
Main;
TProcOff;
Done;
END.