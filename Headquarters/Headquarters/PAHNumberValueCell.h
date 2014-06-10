//
//  PAHNumberValueCell.h
//  Headquarters
//
//  Created by Patrick Gibson on 6/10/14.
//  Copyright (c) 2014 Pacific Helm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAHNumberValueCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISlider *numberSlider;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;

- (IBAction)numberChanged:(id)sender;

@end
