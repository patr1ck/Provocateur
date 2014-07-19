//
//  PAHColorControlCell.m
//  Headquarters
//
//  Created by Patrick Gibson on 6/10/14.
//  Copyright (c) 2014 Pacific Helm. All rights reserved.
//

#import "PAHColorControlCell.h"
#import "UIColor+Additions.h"

#import <KVOController/FBKVOController.h>

@interface PAHColorControlCell ()

@property (strong, nonatomic) FBKVOController *kvoController;

@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueLabel;

@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UITextField *hexTextField;

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
    
    self.kvoController = [FBKVOController controllerWithObserver:self];
    self.color = [UIColor whiteColor];
    
    self.redSlider.minimumValue = 0;
    self.redSlider.maximumValue = 255;
    [self.redSlider addTarget:self action:@selector(update:) forControlEvents:UIControlEventValueChanged];

    self.greenSlider.minimumValue = 0;
    self.greenSlider.maximumValue = 255;
    [self.greenSlider addTarget:self action:@selector(update:) forControlEvents:UIControlEventValueChanged];
    
    self.blueSlider.minimumValue = 0;
    self.blueSlider.maximumValue = 255;
    [self.blueSlider addTarget:self action:@selector(update:) forControlEvents:UIControlEventValueChanged];
    
    [self.hexTextField addTarget:self action:@selector(update:) forControlEvents:UIControlEventEditingChanged];
    
    [self.kvoController observe:self
                        keyPath:@"color"
                        options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew
                          block:^(id observer, UIColor *color, NSDictionary *change) {
                              UIColor *newColor = change[NSKeyValueChangeNewKey];
                              
                              self.hexTextField.text = [newColor RGBHexString];
                              
                              const CGFloat *components = CGColorGetComponents([newColor CGColor]);
                              CGFloat red = components[0] * 255.0;
                              CGFloat green = components[1] * 255.0;
                              CGFloat blue = components[2] * 255.0;
                              
                              self.redSlider.value = red;
                              self.redLabel.text = [NSString stringWithFormat:@"%.0f", red];
                              
                              self.greenSlider.value = green;
                              self.greenLabel.text = [NSString stringWithFormat:@"%.0f", green];
                              
                              self.blueSlider.value = blue;
                              self.blueLabel.text = [NSString stringWithFormat:@"%.0f", blue];
                          }];
}

- (void)setColor:(UIColor *)color
{
    if (![_color isEqual:color]) {
        [self willChangeValueForKey:@"color"];
        _color = color;
        [self didChangeValueForKey:@"color"];
    }
}

- (void)update:(id)sender
{
    UIColor *newColor = nil;
    if (sender != self.hexTextField) {
        newColor = [UIColor colorWithRed255:self.redSlider.value
                                   green255:self.greenSlider.value
                                    blue255:self.blueSlider.value
                                   alpha255:255];
    } else {
        newColor = [UIColor colorWithRGBHexString:self.hexTextField.text];
    }
    
    if (newColor) {
        self.color = newColor;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(colorControlCell:changedColor:)]) {
            [self.delegate colorControlCell:self changedColor:self.color];
        }
    }
}


@end
