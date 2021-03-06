program Fonts;
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
  heapmgr,
  MBF.__CONTROLLERTYPE__.SystemCore,
  MBF.__CONTROLLERTYPE__.GPIO,
  MBF.__CONTROLLERTYPE__.LCD,
  FreeRTOS,
  FreeRTOS.Heap_4;

var
  BlinkyTaskHandle  : TTaskHandle;
  LCDInitTaskHandle : TTaskHandle;
  LCDFontTaskHandle : TTaskHandle;

procedure BlinkyTask({%H-}pvParameters:pointer);
var
  LastWakeTime:TMilliseconds;
begin
  LastWakeTime := SystemCore.GetTickCount;
  while true do
  begin
    GPIO.PinValue[PIN_LED] := 1;
    SystemCore.DelayUntil(LastWakeTime,500);
    GPIO.PinValue[PIN_LED] := 0;
    SystemCore.DelayUntil(LastWakeTime,500);
  end;
  vTaskDelete(nil);
end;

procedure LCD_TASK_INIT({%H-}pvParameters:pointer);
begin
  setRotation(3);

  fillScreen(color565(9,7,7)); // BLACK background
  setTextColor(color565(239,220,5)); // YELLOW text

  setTextSize(2);
  drawString('Font test', 100, 10, TTEXTFONT.FONT2);

  vTaskResume(LCDFontTaskHandle);

  vTaskDelete(nil);
end;

procedure LCD_TASK_FONT({%H-}pvParameters:pointer);
var
  LastWakeTime:TMilliseconds;
  aFont:TGFXFONT;
  aPChar:PChar;
  width,height:Smallint;
begin
  LastWakeTime := SystemCore.GetTickCount;

  width:=0;
  height:=0;

  while (true) do
  begin
    for aFont in TGFXFONT do
    begin
      //Smart erase previous string
      fillRect(10,80,width,height,TFT_BLACK);

      // Set font and draw string
      setGFXFont(aFont);
      drawString('Hello', 10, 80, TTEXTFONT.GFXFF);

      width:=textWidth('Hello', TTEXTFONT.GFXFF);
      height:=fontHeight(TTEXTFONT.GFXFF);

      fillRect(10,40,320-10,40,TFT_BLACK);
      drawString('w:', 10, 40, TTEXTFONT.FONT2);
      drawNumber(width, 40, 40, TTEXTFONT.FONT2);
      drawString('h:', 150, 40, TTEXTFONT.FONT2);
      drawNumber(height, 180, 40, TTEXTFONT.FONT2);

      aPChar:=@FONTNAMES[aFont][1];
      fillRect(10,200,320-10,240-200,TFT_BLACK);
      drawString(aPChar, 10, 200, TTEXTFONT.FONT2);

      SystemCore.DelayUntil(LastWakeTime,1000);
    end;
  end;
  vTaskDelete(nil);
end;

begin
  BasicSystemInit;

  SystemCoreClock:=SystemCore.GetMaxCPUFrequency;
  SystemCore.Initialize;

  GPIO.PinMode[PIN_LED] := TPinMode.Output;

  TFTCreate;
  initTFT;

  BlinkyTaskHandle := nil;
  if xTaskCreate(@BlinkyTask,
                 'BlinkyTask',
                 configMINIMAL_STACK_SIZE,
                 nil,
                 tskIDLE_PRIORITY+0,
                 BlinkyTaskHandle)=pdPass then
  begin
  end;

  LCDInitTaskHandle := nil;
  if xTaskCreate(@LCD_TASK_INIT,
                 'Task LCD Init',
                 configMINIMAL_STACK_SIZE,
                 nil,
                 tskIDLE_PRIORITY+1,
                 LCDInitTaskHandle)= pdPass then
  begin
  end;

  LCDFontTaskHandle := nil;
  if xTaskCreate(@LCD_TASK_FONT,
                 'Task Font',
                 configMINIMAL_STACK_SIZE*4,
                 nil,
                 tskIDLE_PRIORITY+2,
                 LCDFontTaskHandle)= pdPass then
  begin
  end;

  vTaskSuspend(LCDFontTaskHandle);

  vTaskStartScheduler;

  repeat
  until 1=0;

  TFTFree;
end.

