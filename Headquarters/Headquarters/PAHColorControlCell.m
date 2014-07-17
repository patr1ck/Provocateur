//
//  PAHColorControlCell.m
//  Headquarters
//
//  Created by Patrick Gibson on 6/10/14.
//  Copyright (c) 2014 Pacific Helm. All rights reserved.
//

#import "PAHColorControlCell.h"

@interface PAHColorControlCell ()

@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueLabel;

@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UITextField *hexTextField;

- (IBAction)redChanged:(id)sender;
- (IBAction)greenChanged:(id)sender;
- (IBAction)blueChanged:(id)sender;
- (IBAction)hexChanged:(id)sender;

@end

@implementation PAHColorControlCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.redSlider.minimumValue = 0;
    self.redSlider.maximumValue = 255;
    [self.redSlider addTarget:self action:@selector(update:) forControlEvents:UIControlEventValueChanged];

    self.greenSlider.minimumValue = 0;
    self.greenSlider.maximumValue = 255;
    [self.greenSlider addTarget:self action:@selector(update:) forControlEvents:UIControlEventValueChanged];
    
    self.blueSlider.minimumValue = 0;
    self.blueSlider.maximumValue = 255;
    [self.blueSlider addTarget:self action:@selector(update:) forControlEvents:UIControlEventValueChanged];
}

- (IBAction)redChanged:(id)sender
{
    self.redLabel.text = [NSString stringWithFormat:@"%.0f", self.redSlider.value];
}

- (IBAction)greenChanged:(id)sender
{
    self.greenLabel.text = [NSString stringWithFormat:@"%.0f", self.greenSlider.value];
}

- (IBAction)blueChanged:(id)sender
{
    self.blueLabel.text = [NSString stringWithFormat:@"%.0f", self.blueSlider.value];
}

- (IBAction)hexChanged:(id)sender
{
    
}

- (void)update:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(colorControlCell:changedColor:)]) {
        [self.delegate colorControlCell:self changedColor:[UIColor colorWithRed:(self.redSlider.value / 255.0f)
                                                                          green:(self.greenSlider.value / 255.0f)
                                                                           blue:(self.blueSlider.value / 255.0f)
                                                                          alpha:1.0]];
    }
}


@end
