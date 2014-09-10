//
//  PAHNumberControlCell.h
//  Headquarters
//
//  Created by Patrick Gibson on 6/10/14.
//  Copyright (c) 2014 Pacific Helm. All rights reserved.
//

#import "PAHNumberControlCell.h"

#import <KVOController/FBKVOController.h>

@interface PAHNumberControlCell () <UITextFieldDelegate>

@property (strong, nonatomic) FBKVOController *kvoController;

@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UISlider *numberSlider;


@end


@implementation PAHNumberControlCell

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
    self.number = @0;
    
    self.numberSlider.minimumValue = 0;
    self.numberSlider.maximumValue = 255;
    [self.numberSlider addTarget:self action:@selector(update:) forControlEvents:UIControlEventValueChanged];
    
    [self.numberTextField addTarget:self action:@selector(update:) forControlEvents:UIControlEventEditingDidEnd];
    self.numberTextField.delegate = self;
    self.numberTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [self.kvoController observe:self
                        keyPath:@"number"
                        options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew
                          block:^(id observer, NSNumber *number, NSDictionary *change) {
                              NSNumber *newNumber = change[NSKeyValueChangeNewKey];
                              
                              self.numberTextField.text = [NSString stringWithFormat:@"%.2f", newNumber.floatValue];
                              self.numberSlider.value = newNumber.floatValue;
                          }];
}


- (void)setNumber:(NSNumber *)number
{
    if (![_number isEqual:number]) {
        [self willChangeValueForKey:@"number"];
        _number = number;
        [self didChangeValueForKey:@"number"];
    }
}

- (void)update:(id)sender
{
    NSNumber *newNumber = nil;
    
    if (sender != self.numberTextField) {
        newNumber = @(self.numberSlider.value);
    } else {
        newNumber = @([self.numberTextField.text floatValue]);
    }
    
    if (newNumber) {
        self.number = newNumber;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(numberControlCell:changedNumber:)]) {
            [self.delegate numberControlCell:self changedNumber:self.number];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    return YES;
}


@end
