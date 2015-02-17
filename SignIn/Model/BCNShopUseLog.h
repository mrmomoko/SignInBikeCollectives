//
//  BCNShopUseLog.h
//  Bike Collective Sign In
//
//  Created by Momoko on 4/17/14.
//  Copyright (c) 2014 Bike Farm. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BCNShopUse;
@class BCNContact;

@interface BCNShopUseLog : NSObject

@property (nonatomic, strong, readonly) NSArray *shopUseLog;

// Notice that this is a class method and prefixed with a + instead of a -
+ (instancetype)sharedStore;

// create a method that calls for an new bnrItem to be created
- (BCNShopUse *)createShopUse;

// deleteing an item
- (void)removeItem:(BCNShopUse *)shopUse;

//move an item
-(void)moveItemAtIndex:(NSUInteger)fromIndex
               toIndex:(NSUInteger)toIndex;

@end
