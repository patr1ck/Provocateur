//
//  PAHNumberContorCell.h
//  Headquarters
//
//  Created by Patrick Gibson on 6/10/14.
//  Copyright (c) 2014 Pacific Helm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PAHNumberContorCell;

@protocol PAHNumberControlCellDelegate <NSObject>
- (void)numberControlCell:(PAHNumberContorCell *)cell changedNumber:(NSNumber *)number;
@end

@interface PAHNumberContorCell : UITableViewCell

@property (strong, nonatomic) NSNumber *number;
@property (weak, nonatomic) id<PAHNumberControlCellDelegate> delegate;

@end
