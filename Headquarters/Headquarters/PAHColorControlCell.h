//
//  PAHColorControlCell.h
//  Headquarters
//
//  Created by Patrick Gibson on 6/10/14.
//  Copyright (c) 2014 Pacific Helm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAHColorControlCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UITextField *hexTextField;

- (IBAction)redChanged:(id)sender;
- (IBAction)greenChanged:(id)sender;
- (IBAction)blueChanged:(id)sender;
- (IBAction)hexChanged:(id)sender;

@end
