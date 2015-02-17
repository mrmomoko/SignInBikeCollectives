//
//  BFFOrganization.h
//  SignIn
//
//  Created by Momoko Saunders on 1/16/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFFOrganization : NSObject

@property (strong, nonatomic) NSString *nameOfOrg;
@property (strong, nonatomic) NSString *emailAddress;
@property (strong, nonatomic) NSString *physicalAddress;
@property (strong, nonatomic) NSString *zipCode;
@property (strong, nonatomic) NSURL *website;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *yearEstabished;
@property (strong, nonatomic) NSString *orgDescription;


@end
