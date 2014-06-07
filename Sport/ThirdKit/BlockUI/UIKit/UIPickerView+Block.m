//
//  UIPickerView+Block.m
//  iOS Blocks
//
//  Created by Ignacio Romero Zurbuchen on 12/19/12.
//  Copyright (c) 2011 DZN Labs.
//  Licence: MIT-Licence
//

#import "UIPickerView+Block.h"

static NSString *contentKeyPath = @"UIPickerViewKey";
static RowPickedBlock _rowPickedBlock;

@implementation UIPickerView (Block)

+ (UIPickerView *)pickerViewWithContent:(NSArray *)content
                             showInView:(UIView *)view
                        onShouldDismiss:(RowPickedBlock)rowPickedBlock
{
    _rowPickedBlock = [rowPickedBlock copy];
    
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.showsSelectionIndicator = YES;
    picker.dataSource = [self class];
    picker.delegate = [self class];
    
    [[NSUserDefaults standardUserDefaults] setObject:content forKey:contentKeyPath];
    [[NSUserDefaults standardUserDefaults] synchronize];
        
    return picker;
}

+ (NSArray *)content
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:contentKeyPath];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

+ (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [[UIPickerView content] count];
}

+ (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[UIPickerView content] objectAtIndex:row];
}

+ (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _rowPickedBlock([[UIPickerView content] objectAtIndex:row]);
}

@end
