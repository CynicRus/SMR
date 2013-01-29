program smr;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, smr_main, smr_types, smr_win_hook, smr_lin_hook, smr_utils, smr_base,
  smr_selector, smr_stop, GR32_L
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TRecorder, Recorder);
  Application.CreateForm(TStopForm, StopForm);
  Application.Run;
end.

