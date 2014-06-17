//
//  SplitCell.m
//  Sport
//
//  Created by zhaojian on 14-6-17.
//  Copyright (c) 2014年 ZKR. All rights reserved.
//

#import "SplitCell.h"

@implementation SplitCell
@synthesize sectionLabel = _sectionLabel;
@synthesize elevateLabel = _elevateLabel;
@synthesize paceLabel = _paceLabel;
@synthesize split_view = _split_view;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"SplitCell" owner:self options:nil];
        SplitCell* cell = [array objectAtIndex:0];
        if (cell == nil) {
            return nil;
        }
        self = cell;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
