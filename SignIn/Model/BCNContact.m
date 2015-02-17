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

-(NSString *)description
{
    NSString *lastNameInitial;
    if (self.lastName.length > 0) {
        lastNameInitial = [self.lastName substringToIndex:1];
    }
    return [NSString stringWithFormat: @"%@ %@", self.firstName, lastNameInitial];
}

@end
