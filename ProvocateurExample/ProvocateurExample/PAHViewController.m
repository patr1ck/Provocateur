//
//  PAHViewController.m
//  ProvocateurExample
//
//  Created by Patrick B. Gibson on 2/17/14.
//  Copyright (c) 2014 Pacific Helm. All rights reserved.
//

#import "PAHViewController.h"

#import "Provocateur.h"
#import "HexColor.h"

@interface PAHViewController ()

@end

@implementation PAHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[Provocateur sharedInstance] configureKey:@"color"
                                    usingBlock:^(id value) {
                                        NSString *colorValue = (NSString *)value;
                                        self.view.backgroundColor = [UIColor colorWithHexString:colorValue];
                                    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
