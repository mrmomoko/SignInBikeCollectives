//
//  BCNShopUse.m
//  Bike Collective Sign In
//
//  Created by Momoko on 4/8/14.
//  Copyright (c) 2014 Bike Farm. All rights reserved.
//

#import "BCNShopUse.h"

@implementation BCNShopUse

-(instancetype)init
{
    self = [super init];
    _timeStamp = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    return self;
}

-(void)setSignOut:(NSDate *)signOut
{
    _signOut = signOut;
    double loggedSeconds = [self.signIn timeIntervalSinceDate:signOut];
    double hours = -loggedSeconds/60/60;
    _numberOfHoursLogged = hours;
}

@end
