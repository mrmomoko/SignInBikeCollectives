//
//  BCNContact.m
//  Bike Collective Sign In
//
//  Created by Momoko on 4/8/14.
//  Copyright (c) 2014 Bike Farm. All rights reserved.
//

#import "BCNContact.h"

@implementation BCNContact

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.firstName forKey:@"firstName"];
    //does the contact have to keep track of it's hours?
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self =[super init];
    if (self) {
        _firstName = [aDecoder decodeObjectForKey:@"firstName"];
        if (_colour == nil) {
            _colour = [UIColor whiteColor];
        }
    }
    return self;
}

-(void)setMembershipType:(BCNMembershipType)membershipType
{
    NSDate *expirationDate;
    NSCalendar *cal = [NSCalendar currentCalendar];
    switch (membershipType) {
        case 0:
            expirationDate = [cal dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:[NSDate date] options:0];
            break;
        case 1:
            expirationDate = [cal dateByAddingUnit:NSCalendarUnitMonth value:6 toDate:[NSDate date] options:0];
            break;
        case 2:
            expirationDate = [cal dateByAddingUnit:NSCalendarUnitMonth value:12 toDate:[NSDate date] options:0];
            break;
        case 3:
            expirationDate = [cal dateByAddingUnit:NSCalendarUnitMonth value:1000 toDate:[NSDate date] options:0];
            break;
        case 4:
            expirationDate = [NSDate dateWithTimeIntervalSince1970:0];
            break;
        default:
            break;
    }
    self.membershipExpiration = expirationDate;
    _membershipType = membershipType;
}

-(NSString *)description
{
    NSString *lastNameInitial;
    if (self.lastName.length > 0) {
        lastNameInitial = [self.lastName substringToIndex:1];
        return [NSString stringWithFormat: @"%@ %@", self.firstName, lastNameInitial];
    } else {
        return self.firstName;
    }
}

@end
