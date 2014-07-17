//
//  PAHColorControlCell.h
//  Headquarters
//
//  Created by Patrick Gibson on 6/10/14.
//  Copyright (c) 2014 Pacific Helm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PAHColorControlCell;

@protocol PAHColorControlCellDelegate <NSObject>
- (void)colorControlCell:(PAHColorControlCell *)cell changedColor:(UIColor *)color;
@end

@interface PAHColorControlCell : UITableViewCell

@property (copy, nonatomic) UIColor *color;
@property (weak, nonatomic) id<PAHColorControlCellDelegate> delegate;

@end
