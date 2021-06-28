//
//  RNRongta.m
//  rongtaModule
//
//  Created by Daniel Ndoni on 23.2.21.
//

// RNRongta.m
#import <React/RCTLog.h>
#import "ReactNativeRongta2.h"

// SDK
#import "RTBlueToothPI.h"
#import "PrinterManager.h"
#import "BlueToothFactory.h"
#import "ObserverObj.h"
#import "RTDeviceinfo.h"
#import "PrinterInterface.h"

@interface RNRongta(){
  RTBlueToothPI * _blueToothPI;
  PrinterManager * _printerManager;
}
@property (nonatomic) BlueToothKind bluetoothkind;
@end

@implementation RNRongta

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

// To export a module named RNRongta
RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(connectToDevice:(NSString *)UUID callback:(RCTResponseSenderBlock)callback)
{
  RCTLogInfo(@"Pretending to print '%@'", UUID);
  [_printerManager DoConnectBle:UUID];
  double delayInSeconds = 1.0;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      //code to be executed on the main queue after delay
    if ([self->_printerManager.CurrentPrinter IsOpen]) {
      RCTLogInfo(@"connect success");
      callback(@[@"1"]);
    } else {
      RCTLogInfo(@"connect failed");
      callback(@[@"0"]);
    }
  });
}
RCT_EXPORT_METHOD(print:(NSString *)text)
{
  RCTLogInfo(@"Pretending to print '%@'", text);
  // todo print
  Printer * currentprinter = _printerManager.CurrentPrinter;
  if (currentprinter.IsOpen){
      NSString* inputStr = text;
      NSLog(@"inputStr=%@",inputStr);
      TextSetting *textst = currentprinter.TextSets;
      [textst setAlignmode:Align_Left];
      [textst setIsTimes_Wide:Set_DisEnable];
      [textst setIsTimes_Heigh:Set_DisEnable];
      [textst setIsUnderline:Set_DisEnable];
      Cmd *cmd =  [_printerManager CreateCmdClass:_printerManager.CurrentPrinterCmdType];
      [cmd Clear];
      [cmd setEncodingType:Encoding_GBK];
      NSData *headercmd = [_printerManager GetHeaderCmd:cmd cmdtype:_printerManager.CurrentPrinterCmdType];//
      [cmd Append:headercmd];
      
      
      //
      //        NSArray * textArray = [inputStr componentsSeparatedByString:@"\n"];
      //        for(NSString * str in textArray ){
      //           NSData *data = [cmd GetTextCmd:currentprinter.TextSets text:str];
      //           textst.Y_start = textst.Y_start+30;
      //           [cmd Append:data];
      //           [cmd Append:cmd.GetLFCRCmd];
      //           data = nil;
      //        }
      // inputStr = @"_____________________________________________________________";
      //        NSMutableString *stlist = [[NSMutableString alloc] init];
      //        [stlist appendString:@"┌─────┬──────┬─────┬───────┬───────┬──────┬──────┐\r\n"];
      //        [stlist appendString:@"├─────┼──────┼─────┼───────┼───────┼──────┼──────┤\r\n"];
      //        [stlist appendString:@"├─────┼──────┼─────┼───────┼───────┼──────┼──────┤\r\n"];
      //        [stlist appendString:@"└─────┴──────┴─────┴───────┴───────┴──────┴──────┘\r\n"];
      //        inputStr = [NSString stringWithFormat:@"%@",stlist];
      NSData *data = [cmd GetTextCmd:currentprinter.TextSets text:inputStr];
      [cmd Append:data];
      
      //
      //        NSData *data0 = [(PinCmd*)cmd GetAbsolutePrintPositionCmd:5];
      //        [cmd Append:data0];
      //        NSData *data = [cmd GetTextCmd:currentprinter.TextSets text:@"中国人民000001"];
      //        [cmd Append:data];
      //        [cmd Append:[cmd GetLFCRCmd]];
      //        [cmd Append:[(PinCmd*)cmd GetJumpingRow180thCmd:JumpMode_Forward n:100]];
      //
      //
      //        [textst setIsTimes_Wide:Set_DisEnable];
      //        [textst setIsTimes_Heigh:Set_DisEnable];
      //       // data0 = [(PinCmd*)cmd GetAbsolutePrintPositionCmd:50];
      //        [cmd Append:data0];
      //        NSData *data2 = [cmd GetTextCmd:currentprinter.TextSets text:@"中国人民000002"];
      //        [cmd Append:data2];
      //        [cmd Append:[cmd GetLFCRCmd]];
      //        [textst setIsTimes_Wide:Set_DisEnable];
      //        [textst setIsTimes_Heigh:Set_DisEnable];
      // data0 = [(PinCmd*)cmd GetAbsolutePrintPositionCmd:100];
      //        [cmd Append:data0];
      //        NSData *data3 = [cmd GetTextCmd:currentprinter.TextSets text:@"中国人民000003"];
      //        [cmd Append:data3];
      //
      [cmd Append:[cmd GetLFCRCmd]]; //一定要加回车换行，否则打印不了，Be sure to add a carriage return to the    line, otherwise it will not print.
      
      ////        [cmd Append:[(PinCmd*)cmd GetJumpingRow180thCmd:JumpMode_Forward n:1]];
      //        NSString *sjump= @"I will jump row";
      //        [cmd Append:[cmd ImportData:sjump]];
      //        [cmd Append:[cmd GetLFCRCmd]];
      
      [cmd Append:[cmd GetPrintEndCmd]];
      
      if ([currentprinter IsOpen]){
          NSData *data=[cmd GetCmd];
          NSLog(@"data bytes=%@",data);
          [currentprinter Write:data];
          
      }
  }

}
RCT_EXPORT_METHOD(getDevicesList:(RCTResponseSenderBlock)callback) {
  @try {
    if (_blueToothPI == nil) {
      _blueToothPI  = [BlueToothFactory Create:self.bluetoothkind];
    }
    if (_printerManager == nil) {
      _printerManager = [PrinterManager sharedInstance];
    }

    // scan device
    [_blueToothPI startScan:15 isclear:YES];
    
    // init array
    NSMutableArray *devlist = _blueToothPI.getBleDevicelist;
    NSMutableArray *listDevice = [[NSMutableArray alloc] init];
    
    double delayInSeconds = 10.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
      for (RTDeviceinfo *device in devlist) {
        NSDictionary *dic = @{@"id": device.UUID, @"name": device.name};
        [listDevice addObject:dic];
      }
      callback(@[[NSNull null], listDevice]);
    });
  } @catch (NSException *exception) {
    callback(@[exception.reason, [NSNull null]]);
  }
}

@end
