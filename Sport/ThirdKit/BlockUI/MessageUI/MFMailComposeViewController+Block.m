//
//  MFMailComposeViewController+Block.m
//  iOS Blocks
//
//  Created by Ignacio Romero Zurbuchen on 12/11/12.
//  Copyright (c) 2011 DZN Labs.
//  Licence: MIT-Licence
//

#import "MFMailComposeViewController+Block.h"

static ComposeCreatedBlock _composeCreatedBlock;
static ComposeFinishedBlock _composeFinishedBlock;

@implementation MFMailComposeViewController (Block)

+ (void)mailWithSubject:(NSString *)subject
                message:(NSString *)message
             recipients:(NSArray *)recipients
             onCreation:(ComposeCreatedBlock)creation
               onFinish:(ComposeFinishedBlock)finished
{
    [MFMailComposeViewController mailWithSubject:subject
                                         message:message
                                      recipients:recipients
                                   bccRecipients:nil
                                    ccRecipients:nil
                                  andAttachments:nil
                                      onCreation:creation
                                        onFinish:finished];
}

+ (void)mailWithSubject:(NSString *)subject
                message:(NSString *)message
             recipients:(NSArray *)recipients
          bccRecipients:(NSArray *)bccRecipients
           ccRecipients:(NSArray *)ccRecipients
         andAttachments:(NSArray *)attachments
             onCreation:(ComposeCreatedBlock)creation
               onFinish:(ComposeFinishedBlock)finished
{
    _composeCreatedBlock = [creation copy];
    _composeFinishedBlock = [finished copy];
    
    MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
    mailComposeViewController.mailComposeDelegate = [self class];
    [mailComposeViewController setSubject:subject];
    [mailComposeViewController setMessageBody:message isHTML:YES];
    [mailComposeViewController setToRecipients:recipients];
    [mailComposeViewController setBccRecipients:bccRecipients];
    [mailComposeViewController setCcRecipients:ccRecipients];
    
    for (NSDictionary *attachment in attachments) {
        NSData *data = [attachment objectForKey:kMFAttachmentData];
        NSString *mimeType = [attachment objectForKey:kMFAttachmentMimeType];
        NSData *filename = [attachment objectForKey:kMFAttachmentFileName];
        
        [mailComposeViewController addAttachmentData:data mimeType:mimeType fileName:filename];
    }
    
    mailComposeViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    if (_composeCreatedBlock) {
        _composeCreatedBlock(mailComposeViewController);
    }
}


#pragma mark - MFMailComposeViewControllerDelegate

+ (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (_composeFinishedBlock) {
        _composeFinishedBlock(controller, error);
    }
}

@end
