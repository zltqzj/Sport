//
//  iOSBlocks.h
//  iOS Blocks
//
//  Created by Ignacio Romero Zurbuchen on 2/12/13.
//  Copyright (c) 2011 DZN Labs.
//  Licence: MIT-Licence
//

// CoreLocation
#import "CLLocationManager+Block.h"

// Foundation
#import "NSURLConnection+Block.h"

// MessageUI
#import "MFMailComposeViewController+Block.h"
#import "MFMessageComposeViewController+Block.h"

// UIKit
#import "UIActionSheet+Block.h"
#import "UIAlertView+Block.h"
#import "UIPickerView+Block.h"
#import "UIPopoverController+Block.h"
#import "UINavigationController+Block.h"


#pragma mark - 定时器
/*
if (_timer) {
    [_timer invalidate];
    [_timer release], _timer = nil;
    return;
}

_timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer *timer) {
    UITextView* textView = (UITextView*)[self.view viewWithTag:TEXTVIEW_TAG];
    textView.text = [textView.text stringByAppendingFormat:@"repeats\n"];
} repeats:YES];
[_timer retain];
 
 */


#pragma mark - 定位
/*
[[CLLocationManager sharedManager] updateLocationWithDistanceFilter:1.0
                                                 andDesiredAccuracy:kCLLocationAccuracyBest
                                                 didUpdateLocations:^(NSArray *locations){
                                                     
                                                     NSLog(@"locations : %@",locations);
                                                 }
                                                   didFailWithError:^(NSError *error){
                                                       NSLog(@"error : %@",error.localizedDescription);
                                                   }];


*/


#pragma mark - 控件
/** example

 - (IBAction)triggerNewEmail:(id)sender {
 
 NSString *subjet = @"Remembering Steve";
 NSString *message = @"Over a million people from all over the world have shared their memories, thoughts, and feelings about Steve. One thing they all have in common — from personal friends to colleagues to owners of Apple products — is how they’ve been touched by his passion and creativity. You can view some of these messages below.";
 
 NSArray *recipients = @[@"rememberingsteve@apple.com"];
 
 NSArray *attachment = @[@{kMFAttachmentData: [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Default" ofType:@"png"]], kMFAttachmentMimeType: @"image/png", kMFAttachmentFileName: @"Attachment"}];
 
 [MFMailComposeViewController mailWithSubject:subjet
 message:message
 recipients:recipients
 bccRecipients:nil
 ccRecipients:nil
 andAttachments:attachment
 onCreation:^(UIViewController *controller){
 [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:controller animated:YES completion:nil];
 }
 onFinish:^(UIViewController *controller, NSError *error){
 NSLog(@"MFMailComposeViewController Cancelled");
 [controller dismissViewControllerAnimated:YES completion:NULL];
 }
 ];
 }
 
 - (IBAction)triggerNewMessage:(id)sender {
 
 NSString *message = @"We miss you Steve.";
 
 NSArray *recipients = @[@"steve@apple.com"];
 
 [MFMessageComposeViewController messageWithBody:message
 recipients:recipients
 onCreation:^(UIViewController *controller){
 [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:controller animated:YES completion:nil];
 }
 onFinish:^(UIViewController *controller, NSError *error){
 NSLog(@"MFMessageComposeViewController Cancelled");
 [controller dismissViewControllerAnimated:YES completion:NULL];
 }
 ];
 }
 
 - (IBAction)triggerNewSheet:(id)sender {
 
 UIView *view = (UIButton *)sender;
 
 NSString *title = @"ActionSheet";
 NSString *cancelTitle = @"Cancel";
 NSString *destructiveTitle = @"Delete";
 
 NSArray *buttonTitles = @[@"Button 1",@"Button 2",@"Button 3"];
 NSArray *disabledTitles = @[@"Button 2"];
 
 
 [UIActionSheet actionSheetWithTitle:title
 style:UIActionSheetStyleAutomatic
 cancelButtonTitle:cancelTitle
 destructiveButtonTitle:destructiveTitle
 buttonTitles:buttonTitles
 disabledTitles:disabledTitles
 showInView:view
 onDismiss:^(int buttonIndex, NSString *buttonTitle){
 NSLog(@"Pressed button : %@",buttonTitle);
 }
 onCancel:^(void){
 NSLog(@"UIActionSheet Cancelled");
 }];
 
 
 //    [UIActionSheet actionSheetWithTitle:title
 //                           buttonTitles:buttonTitles
 //                             showInView:view
 //                              onDismiss:^(int buttonIndex, NSString *buttonTitle){
 //                                  NSLog(@"Pressed button : %@",buttonTitle);
 //                              }];
 }
 
 - (IBAction)triggerNewPicker:(id)sender {
 
 UIButton *button = (UIButton *)sender;
 
 [UIActionSheet photoPickerWithTitle:@"Photo Picker With Block"
 cancelButtonTitle:@"Cancel"
 showInView:button
 presentVC:self
 onPhotoPicked:^(UIImage *chosenImage){
 NSLog(@"Choosed an image with size: %@", NSStringFromCGSize(chosenImage.size));
 }
 onCancel:^(void){
 NSLog(@"UIActionSheet Cancelled");
 }
 ];
 }
 
 - (IBAction)triggerNewAlert:(id)sender {
 
 [UIAlertView alertViewWithTitle:@"AlertView"
 message:@"It's never been this easy to call an UIAlertView!"
 cancelButtonTitle:@"Cancel"
 otherButtonTitles:[NSArray arrayWithObjects:@"OK", nil]
 onDismiss:^(int buttonIndex, NSString *buttonTitle){
 NSLog(@"Pressed button : %@",buttonTitle);
 }
 onCancel:^(void){
 NSLog(@"UIAlertView Cancelled");
 }
 ];
 }
 
 - (IBAction)triggerNewPopover:(id)sender {
 
 UIButton *button = (UIButton *)sender;
 
 UIViewController *contentViewController = [UIViewController new];
 contentViewController.contentSizeForViewInPopover = CGSizeMake(320.0, 500.0);
 contentViewController.view.backgroundColor = [UIColor greenColor];
 
 [UIPopoverController popOverWithContentViewController:contentViewController
 showInView:button
 onShouldDismiss:^(void){
 [[UIPopoverController sharedPopover] dismissPopoverAnimated:YES];
 }
 onCancel:^(void){
 NSLog(@"UIPopoverController Cancelled");
 }
 ];
 }


*/

////////////////////////////////////////////////////////////////


#pragma mark - 导航


/*   导航
 if (indexPath.section == 0) {
 
 NavigationSampleViewController *viewController = [NavigationSampleViewController new];
 
 [self.navigationController pushViewController:viewController animated:YES
 onCompletion:^(){
 NSLog(@"Push Completed!");
 }];
 }
 else {
 if (indexPath.row == 0) {
 
 if (stackCount > 1) {
 UIViewController *secondViewController = [self.navigationController.viewControllers objectAtIndex:1];
 
 [self.navigationController popToViewController:secondViewController
 animated:YES
 onCompletion:^(){
 NSLog(@"Pop To ViewController 2 Completed!");
 }];
 }
 }
 else if (indexPath.row == 1) {
 
 [self.navigationController popViewControllerAnimated:YES
 onCompletion:^(){
 NSLog(@"Pop ViewController Completed!");
 }];
 }
 else if (indexPath.row == 2) {
 
 [self.navigationController popToRootViewControllerAnimated:YES
 onCompletion:^(){
 NSLog(@"Pop To Root ViewController Completed!");
 }];
 }
 }

 
 
 */





