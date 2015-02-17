//
//  NewUserViewController.h
//  SignIn
//
//  Created by Momoko Saunders on 1/16/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BCNContact;

@protocol BFFNewUserViewControllerDelegate;

@interface BFFNewUserViewController : UIViewController

@property (strong, nonatomic) BCNContact *contact;
@property (strong, nonatomic) NSString *identifier;
@property (weak, nonatomic) id <BFFNewUserViewControllerDelegate> delegate;

@end

@protocol BFFNewUserViewControllerDelegate <NSObject>

- (void)contactWasSaved;

@end