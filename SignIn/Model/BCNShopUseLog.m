////
////  BCNShopUseLog.m
////  Bike Collective Sign In
////
////  Created by Momoko on 4/17/14.
////  Copyright (c) 2014 Bike Farm. All rights reserved.
////
//
//#import "BCNShopUseLog.h"
//#import "BCNShopUse.h"
//#import "BCNContact.h"
//
//
//@interface BCNShopUseLog ()
//
//@property (nonatomic, strong) NSMutableArray *privateShopUse;
//
//@end
//
//@implementation BCNShopUseLog
//
//+ (instancetype)sharedStore
//{
//    static BCNShopUseLog *sharedStore = nil;
//    
//    //do I need to create a sharedStore?
//    if (!sharedStore) {
//        sharedStore = [[self alloc] initPrivate];
//    }
//    
//    return sharedStore;
//}
//
////If a programmer calls [BCNShopUseLog alloc] init], let her
//// know the error of her ways
//- (instancetype)init
//{
//    @throw [NSException exceptionWithName:@"Singleton"
//                                   reason:@"Use +[BCNShopUseLog sharedStore]"
//                                 userInfo:nil];
//    return nil;
//}
//
////Here is the real (secret) initializer
//- (instancetype)initPrivate
//{
//    self = [super init];
//    if (self) {
//        _privateShopUse = [[NSMutableArray alloc] init];
//    }
//    // remove at time of launch
//    BCNContact *contact = [[BCNContact alloc] init];
//    contact.firstName = @"momoko";
//    BCNShopUse *a = [[BCNShopUse alloc] init];
//    a.userIdentity = @"momoko";
//    a.volunteer = YES;
//    a.signIn = [NSDate dateWithTimeIntervalSinceNow:-60*60*24];
//    a.signOut = [NSDate dateWithTimeIntervalSinceNow:-60*60*22];
//    a.contact = contact;
//    BCNShopUse *b = [[BCNShopUse alloc] init];
//    b.userIdentity = @"momoko";
//    b.volunteer = YES;
//    b.signIn = [NSDate dateWithTimeIntervalSinceNow:-60*60*24];
//    b.signOut = [NSDate dateWithTimeIntervalSinceNow:-60*60*22];
//    b.contact = contact;
//    BCNShopUse *c = [[BCNShopUse alloc] init];
//    c.userIdentity = @"momoko";
//    c.volunteer = NO;
//    c.signIn = [NSDate dateWithTimeIntervalSinceNow:-60*60*24];
//    c.signOut = [NSDate dateWithTimeIntervalSinceNow:-60*60*22];
//    c.contact = contact;
//    [_privateShopUse addObject:a];
//    [_privateShopUse addObject:b];
//    [_privateShopUse addObject:c];
//    //end of code to be removed
//    
//    return self;
//}
//
//- (NSArray *)shopUseLog
//{
//    return self.privateShopUse;
//}
//
//- (BCNShopUse *)createShopUse
//{
//    BCNShopUse *shopUse = [[BCNShopUse alloc] init];
//    
//    [[self privateShopUse] addObject:shopUse];
//    return shopUse;
//}
//
//- (void)removeItem:(BCNShopUse *)shopUse
//{    
//    [[self privateShopUse] removeObjectIdenticalTo:shopUse];
//}
//
//- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
//{
//    if (fromIndex == toIndex) {
//        return;
//    }
//    //Get pointer to object being moved so you can re-insert it
//    BCNShopUse *shopUse = [[self privateShopUse] objectAtIndex:fromIndex];
//    
//    // Remove item from arrray
//    BCNShopUse *removedItem = [[self privateShopUse] objectAtIndex:fromIndex];
//    [[self privateShopUse] removeObject:removedItem];
//    
//    //insert item in array at new location
//    [[self privateShopUse] insertObject:shopUse atIndex:toIndex];
//}
//
//@end
