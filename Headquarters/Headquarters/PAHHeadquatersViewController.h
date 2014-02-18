//
//  PAHViewController.h
//  Headquarters
//
//  Created by Patrick B. Gibson on 2/17/14.
//  Copyright (c) 2014 Pacific Helm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAHHeadquatersViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *textField;

- (IBAction)colorDidUpdate:(id)sender;
- (IBAction)showConnectModal:(id)sender;

@end
