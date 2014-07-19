//
//  PAHNumberControlCell.h
//  Headquarters
//
//  Created by Patrick Gibson on 6/10/14.
//  Copyright (c) 2014 Pacific Helm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PAHNumberControlCell;

@protocol PAHNumberControlCellDelegate <NSObject>
- (void)numberControlCell:(PAHNumberControlCell *)cell changedNumber:(NSNumber *)number;
@end

@interface PAHNumberControlCell : UITableViewCell

@property (strong, nonatomic) NSNumber *number;
@property (weak, nonatomic) id<PAHNumberControlCellDelegate> delegate;
@property (readonly, nonatomic) IBOutlet UISlider *numberSlider;

@end
