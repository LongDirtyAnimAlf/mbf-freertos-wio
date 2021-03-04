program USBTask;
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
  MBF.__CONTROLLERTYPE__.USB,
  FreeRTOS,
  FreeRTOS.Heap_4;

procedure BlinkyTask({%H-}pvParameters:pointer);
var
  i,j:integer;
begin
  while true do
  begin
    GPIO.PinValue[PIN_LED] := 1;
    SystemCore.Delay(500);
    GPIO.PinValue[PIN_LED] := 0;
    SystemCore.Delay(500);
  end;
  //In case we ever break out the while loop the task must end itself
  vTaskDelete(nil);
end;

procedure USBDeviceTask({%H-}pvParameters:pointer);
begin
  CoreUSBInit;
  while true do
  begin
    CoreUSBTask;
    SystemCore.Delay(10);
  end;
  //In case we ever break out the while loop the task must end itself
  vTaskDelete(nil);
end;

procedure USBCDCTask({%H-}pvParameters:pointer);
const
  BUFSIZE=64;
  LINEFEED:Byte=Ord(#10);
var
  buf: array[0..(BUFSIZE-1)] of byte;
  i,count:dword;
begin
  // This CDC task just echo's back the characters !!
  while true do
  begin
    //if tud_cdc_connected then
    begin
      if (tud_cdc_available(0)<>0) then
      begin
        count := tud_cdc_read(0, buf, sizeof(buf));
        for i:=0 to Pred(count) do
        begin
          tud_cdc_n_write(0, @buf[i], 1);
          if (buf[i]=Ord(#13)) then tud_cdc_n_write(0, @LINEFEED , 1);
        end;
        tud_cdc_write_flush(0);
      end;
    end;
    SystemCore.Delay(10);
  end;
  //In case we ever break out the while loop the task must end itself
  vTaskDelete(nil);
end;

var
  BlinkyTaskHandle : TTaskHandle;
  USBDeviceTaskHandle : TTaskHandle;
  USBCDCTaskHandle : TTaskHandle;

begin
  BasicSystemInit;

  CoreUSBHardwareInit;

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


  USBDeviceTaskHandle := nil;
  if xTaskCreate(@USBDeviceTask,
                 'USBDeviceTask',
                 configMINIMAL_STACK_SIZE,
                 nil,
                 tskIDLE_PRIORITY+2,
                 USBDeviceTaskHandle) = pdPass then
  begin
  end;


  USBCDCTaskHandle := nil;
  if xTaskCreate(@USBCDCTask,
                 'USBCDCTask',
                 configMINIMAL_STACK_SIZE,
                 nil,
                 tskIDLE_PRIORITY+3,
                 USBCDCTaskHandle) = pdPass then
  begin
  end;

  vTaskStartScheduler;

  repeat
  until 1=0;
end.

