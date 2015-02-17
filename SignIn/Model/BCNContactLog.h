//
//  BCNContactLog.h
//  Bike Collective Sign In
//
//  Created by Momoko on 4/29/14.
//  Copyright (c) 2014 Bike Farm. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BCNContact;

@interface BCNContactLog : NSObject

@property (nonatomic, strong, readonly) NSArray *contactLog;
@property (nonatomic, strong, readonly) NSArray *filteredVolunteerLog;

+ (instancetype)sharedStore;

// create a method that calls for an new BCNContact to be created
- (BCNContact *)createContact;

- (NSArray *)findContactsWhichContainsString:(NSString *)substring;

// deleteing an item
- (void)removeItem:(BCNContact *)contact;

//move an item
- (void)moveItemAtIndex:(NSUInteger)fromIndex
               toIndex:(NSUInteger)toIndex;

- (void)saveContact:(BCNContact *)contact;

- (NSString *)commaSeporatedStyle;

@end
