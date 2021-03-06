program Tasks;
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
  Handle_aTask      : TTaskHandle;
  Handle_bTask      : TTaskHandle;

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
  drawString('Thread A', 20, 50, TTEXTFONT.FONT2);
  drawString('Thread B', 180, 50, TTEXTFONT.FONT2);

  vTaskResume(Handle_aTask);
  vTaskResume(Handle_bTask);

  vTaskDelete(nil);
end;

procedure LCD_TASK_1({%H-}pvParameters:pointer);
var
  img : SpriteHandle;
  i   : integer;
  LastWakeTime:TMilliseconds;
begin
  img:=SpriteInit;
  SpriteCreate(img, 100, 100);
  SpriteFill(img, color565(229,58,64)); // RED
  SpriteSetTextSize(img, 6);
  SpriteSetTextColor(img, TFT_WHITE);
  i:=0;
  LastWakeTime := SystemCore.GetTickCount;
  while (i<100) do
  begin
    SpriteDrawNumber(img, i, 2, 2, TTEXTFONT.FONT2);
    SpritePushSprite(img, 30, 90);
    SpriteFill(img, color565(229,58,64));
    //SystemCore.Delay(1000);
    SystemCore.DelayUntil(LastWakeTime,1000);
    Inc(i);
    if (i=100) then i:=0;
  end;
  vTaskDelete(nil);
end;

procedure LCD_TASK_2({%H-}pvParameters:pointer);
var
  img : SpriteHandle;
  i   : integer;
  LastWakeTime:TMilliseconds;
begin
  img:=SpriteInit;
  SpriteCreate(img, 100, 100);
  SpriteFill(img, color565(48,179,222)); // BLUE
  SpriteSetTextSize(img, 6);
  SpriteSetTextColor(img, TFT_WHITE);
  i:=0;
  LastWakeTime := SystemCore.GetTickCount;
  while (i<100) do
  begin
    SpriteDrawNumber(img, i, 2, 2, TTEXTFONT.FONT2);
    SpritePushSprite(img, 190, 90);
    SpriteFill(img, color565(48,179,222)); // BLUE
    //SystemCore.Delay(500);
    SystemCore.DelayUntil(LastWakeTime,500);
    Inc(i);
    if (i=100) then i:=0;
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

  Handle_aTask := nil;
  if xTaskCreate(@LCD_TASK_1,
                 'Task A',
                 configMINIMAL_STACK_SIZE*2,
                 nil,
                 tskIDLE_PRIORITY+2,
                 Handle_aTask)= pdPass then
  begin
  end;

  Handle_bTask := nil;
  if xTaskCreate(@LCD_TASK_2,
                 'Task B',
                 configMINIMAL_STACK_SIZE*3,
                 nil,
                 tskIDLE_PRIORITY+3,
                 Handle_bTask)= pdPass then
  begin
  end;

  vTaskSuspend(Handle_aTask);
  vTaskSuspend(Handle_bTask);

  vTaskStartScheduler;

  repeat
  until 1=0;

  TFTFree;
end.

