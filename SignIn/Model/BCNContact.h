//
//  BCNContact.h
//  Bike Collective Sign In
//
//  Created by Momoko on 4/8/14.
//  Copyright (c) 2014 Bike Farm. All rights reserved.
//

@import Foundation;
@import UIKit;

typedef NS_ENUM(NSInteger, BCNMembershipType){
    BCNMembershipTypeMonthly = 0,
    BCNMembershipType6Month = 1,
    BCNMembershipTypeYearly = 2,
    BCNMembershipTypeLifeTime = 3,
    BCNMembershipTypeNonMember = 4
};

@interface BCNContact: NSObject <NSCoding>

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *emailAddress;
@property (strong, nonatomic) NSString *pin;
@property (strong, nonatomic) UIColor *colour;
@property (strong, nonatomic) NSDate *membershipExpiration;
@property (assign, nonatomic) BCNMembershipType membershipType;

// uncertain if all these properties are necessary
@property (strong, nonatomic) NSString *zipCode;
@property (assign, nonatomic) BOOL okToContact;
@property (assign, nonatomic) BOOL addToListServe;
@property (strong, nonatomic) NSString *interestedIn;
// should be a last volunteer date, or currentVolunteer, like MembershipExpiration
@property (assign, nonatomic) BOOL volunteer;

-(NSString *)description;
+(NSArray *)existingContacts;

@end

@protocol NSCoding

-(void)encodeWithCoder:(NSCoder *)aCoder;
-(instancetype)initWithCoder:(NSCoder *)aDecoder;

@end