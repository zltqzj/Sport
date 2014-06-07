//
//  PinYin4Objc.h
//  PinYin4ObjcExample
//
//  Created by kimziv on 13-9-16.
//  Copyright (c) 2013年 kimziv. All rights reserved.
//

//#ifndef PinYin4ObjcExample_PinYin4Objc_h
//#define PinYin4ObjcExample_PinYin4Objc_h
//
//
//
//#endif

#import "HanyuPinyinOutputFormat.h"
#import "PinyinHelper.h"


/**  用法 （汉子转为拼音库）
 #import "PinYin4Objc.h"
 
 -(IBAction)doClick:(id)sender
 {
 NSString *sourceText=_inputTf.text;
 HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
 [outputFormat setToneType:ToneTypeWithoutTone];
 [outputFormat setVCharType:VCharTypeWithV];
 [outputFormat setCaseType:CaseTypeLowercase];
 NSTimeInterval startTime=[[NSDate date] timeIntervalSince1970];
 
 [PinyinHelper toHanyuPinyinStringWithNSString:sourceText withHanyuPinyinOutputFormat:outputFormat withNSString:@" " outputBlock:^(NSString *pinYin) {
 NSTimeInterval endTime=[[NSDate date] timeIntervalSince1970];
 NSTimeInterval totalTime=endTime-startTime;
 _timeLb.text=[NSString stringWithFormat:@"Total Time:%fs",totalTime];
 _wordsLb.text=[NSString stringWithFormat:@"Total Words:%i characters",sourceText.length];
 _outputTv.text=pinYin;
 
 }];
 //    NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:sourceText withHanyuPinyinOutputFormat:outputFormat withNSString:@" "];
 //    NSTimeInterval endTime=[[NSDate date] timeIntervalSince1970];
 //    NSTimeInterval totalTime=endTime-startTime;
 //    _timeLb.text=[NSString stringWithFormat:@"Total Time:%fs",totalTime];
 //    _wordsLb.text=[NSString stringWithFormat:@"Total Words:%i characters",sourceText.length];
 //    _outputTv.text=outputPinyin;
 }

*/

////////////////////////////////////////////////////////////////////////////////////////

/**   异步
 NSString *sourceText=@"我爱中文";
 HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
 [outputFormat setToneType:ToneTypeWithoutTone];
 [outputFormat setVCharType:VCharTypeWithV];
 [outputFormat setCaseType:CaseTypeLowercase];
 [PinyinHelper toHanyuPinyinStringWithNSString:sourceText
 withHanyuPinyinOutputFormat:outputFormat
 withNSString:@" "
 outputBlock:^(NSString *pinYin) {
 _outputTv.text=pinYin; //update ui
 
 }];
 
 
*/

/**   同步
 
 NSString *sourceText=@"我爱中文";
 HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
 [outputFormat setToneType:ToneTypeWithoutTone];
 [outputFormat setVCharType:VCharTypeWithV];
 [outputFormat setCaseType:CaseTypeLowercase];
 NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:sourceText withHanyuPinyinOutputFormat:outputFormat withNSString:@" "];
 
   
 */





