//
//  Provocateur.h
//  Provocateur
//
//  Created by Patrick B. Gibson on 2/17/14.
//  Copyright (c) 2014 Target. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ProvocateurBlock)(id value);

@interface Provocateur : NSObject
+ (id)sharedInstance;

- (void)listen;
- (void)configureKey:(NSString *)key usingBlock:(ProvocateurBlock)block;
@end
