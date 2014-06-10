//
//  PAHColorControlCell.m
//  Headquarters
//
//  Created by Patrick Gibson on 6/10/14.
//  Copyright (c) 2014 Pacific Helm. All rights reserved.
//

#import "PAHColorControlCell.h"

@implementation PAHColorControlCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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

- (IBAction)redChanged:(id)sender {
}

- (IBAction)greenChanged:(id)sender {
}

- (IBAction)blueChanged:(id)sender {
}

- (IBAction)hexChanged:(id)sender {
}
@end
