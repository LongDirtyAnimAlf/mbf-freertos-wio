program Blinky;
{
  This file is part of Pascal Microcontroller Board Framework (MBF)
  Copyright (c) 2015 -  Michael Ring
  based on Pascal eXtended Library (PXL)
  Copyright (c) 2000 - 2015  Yuriy Kotsarenko

  This program is free software: you can redistribute it and/or modify it under the terms of the FPC modified GNU
  Library General Public License for more

  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
  warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the FPC modified GNU Library General Public
  License for more details.
}

{
  This example uses dynamic Initialization of FreeRTOS, this means you need to include
  freetos.heap_4 heapmanager that will do memory alllocation for FreeRTOS Objects
}

{$INCLUDE MBF.Config.inc}

uses
  MBF.__CONTROLLERTYPE__.SystemCore,
  MBF.__CONTROLLERTYPE__.GPIO,
  FreeRTOS,
  FreeRTOS.Heap_4;

procedure BlinkyTask({%H-}pvParameters:pointer);
begin
  while true do
  begin
    GPIO.PinValue[PIN_LED] := 1;
    SystemCore.Delay(250);
    GPIO.PinValue[PIN_LED] := 0;
    SystemCore.Delay(250);
  end;
  //In case we ever break out the while loop the task must end itself
  vTaskDelete(nil);
end;

procedure BlinkyPlain(Delay:DWORD);
var
  i,j:DWORD;
begin
  begin
    GPIO.PinValue[PIN_LED] := 0;
    for i:=0 to Delay do
    begin
      Inc(j);
    end;
    GPIO.PinValue[PIN_LED] := 1;
    for i:=0 to Delay do
    begin
      Inc(j);
    end;
  end;
end;

var
  BlinkyTaskHandle : TTaskHandle;
  k:integer;

begin
  BasicSystemInit;

  SystemCoreClock:=SystemCore.GetMaxCPUFrequency;
  SystemCore.Initialize;

  GPIO.PinMode[PIN_LED] := TPinMode.Output;

  BlinkyTaskHandle := nil;
  if xTaskCreate(@BlinkyTask,
                 'BlinkyTask',
                 configMINIMAL_STACK_SIZE,
                 nil,
                 tskIDLE_PRIORITY+1,
                 BlinkyTaskHandle) = pdPass then
  begin
  end;

  vTaskStartScheduler;

  repeat
  until 1=0;
end.

