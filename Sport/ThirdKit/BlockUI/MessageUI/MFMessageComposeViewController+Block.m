//
//  MFMessageComposeViewController+Block.m
//  iOS Blocks
//
//  Created by Ignacio Romero Zurbuchen on 12/11/12.
//  Copyright (c) 2011 DZN Labs.
//  Licence: MIT-Licence
//

#import "MFMessageComposeViewController+Block.h"

static ComposeCreatedBlock _composeCreatedBlock;
static ComposeFinishedBlock _composeFinishedBlock;

@implementation MFMessageComposeViewController (Block)

+ (void)messageWithBody:(NSString *)body
             recipients:(NSArray *)recipients
             onCreation:(ComposeCreatedBlock)creation
               onFinish:(ComposeFinishedBlock)finished
{
    _composeCreatedBlock = [creation copy];
    _composeFinishedBlock = [finished copy];
    
    MFMessageComposeViewController *messageComposerViewController = [[MFMessageComposeViewController alloc] init];
    messageComposerViewController.messageComposeDelegate = [self class];
    [messageComposerViewController setBody:body];
    [messageComposerViewController setRecipients:recipients];
    
    messageComposerViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    if (_composeCreatedBlock) {
        _composeCreatedBlock(messageComposerViewController);
    }
}


#pragma mark - MFMessageComposeViewControllerDelegate

+ (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if (_composeFinishedBlock) {
        _composeFinishedBlock(controller, nil);
    }
}

@end
