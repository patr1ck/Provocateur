//
//  PAHViewController.m
//  ProvocateurExample
//
//  Created by Patrick B. Gibson on 2/17/14.
//  Copyright (c) 2014 Pacific Helm. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "PAHViewController.h"

#import "Provocateur.h"
#import "HexColor.h"

@interface PAHViewController ()

@property (nonatomic, assign) NSUInteger ballCount;
@property (nonatomic, assign) CGFloat staggerBounce;

@property (nonatomic, strong) UIDynamicAnimator *animator;

@end

@implementation PAHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _ballCount = 4;
    _staggerBounce = 0;
    
    [[Provocateur sharedInstance] configureKey:@"color"
                                    usingBlock:^(id value) {
                                        NSString *colorValue = (NSString *)value;
                                        self.view.backgroundColor = [UIColor colorWithHexString:colorValue];
                                    }];
    
    [[Provocateur sharedInstance] configureKey:@"ballCount"
                                    usingBlock:^(id value) {
                                        NSUInteger ballCount = [(NSNumber *)value unsignedIntegerValue];
                                        _ballCount = ballCount;
                                        [self restartBouncing];
                                    }];
    
    [[Provocateur sharedInstance] configureKey:@"staggerBounce"
                                    usingBlock:^(id value) {
                                        CGFloat staggerBounce = [(NSNumber *)value floatValue];
                                        _staggerBounce = staggerBounce;
                                    }];

    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    [self restartBouncing];
}

- (void)restartBouncing
{
    
    for (UIView *ball in self.view.subviews) {
        [ball removeFromSuperview];
    }
    
    CGFloat centerOfViewX = self.view.bounds.size.width/2;
    CGFloat distanceBetweenBalls = 8.f;
    CGSize ballSize = CGSizeMake(50, 50);
    
    for (int i = 0; i < _ballCount; i++) {
        CGPoint startPoint = {};
        NSUInteger middleball = floorf(_ballCount/2.0);
        
        if (i <= middleball) {
            startPoint = CGPointMake( centerOfViewX - (distanceBetweenBalls + ballSize.width) * (middleball - i), 100 );
        } else {
            startPoint = CGPointMake( centerOfViewX + (distanceBetweenBalls + ballSize.width) * (i-middleball), 100 );
        }
        
        if (_ballCount % 2 == 0) {
            startPoint.x = startPoint.x + ballSize.width/2 + distanceBetweenBalls/2;
        }
        
        UIView *ball = [[UIView alloc] initWithFrame:CGRectMake(startPoint.x, startPoint.y, ballSize.width, ballSize.height)];
        ball.center = startPoint;
        ball.layer.cornerRadius = ballSize.width/2;
        ball.backgroundColor = [UIColor blueColor];
        
        [self.view addSubview:ball];
    }
    
    UICollisionBehavior* collisionBehavior = [[UICollisionBehavior alloc] initWithItems:self.view.subviews];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:collisionBehavior];
    
    UIDynamicItemBehavior *elasticityBehavior = [[UIDynamicItemBehavior alloc] initWithItems:self.view.subviews];
    elasticityBehavior.elasticity = 1.0f;
    elasticityBehavior.resistance = 0.001f;
    [self.animator addBehavior:elasticityBehavior];
    
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:self.view.subviews];
    [self.animator addBehavior:gravity];
    

}


@end
