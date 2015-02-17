//
//  BFFMyAccountViewController.m
//  SignIn
//
//  Created by Momoko Saunders on 1/16/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

#import "BFFMyAccountViewController.h"
#import "BCNContactLog.h"

@interface BFFMyAccountViewController ()

@end

@implementation BFFMyAccountViewController
 

- (IBAction)sendData:(id)sender
{
    BCNContactLog *contactLog = [BCNContactLog sharedStore];
    NSArray *activityItems = [NSArray arrayWithObjects: contactLog.commaSeporatedStyle, nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypePrint, UIActivityTypeAirDrop, UIActivityTypePostToFlickr, UIActivityTypePostToTencentWeibo, UIActivityTypePrint, UIActivityTypeAddToReadingList];
    __weak UIActivityViewController *weakActivityViewController = activityViewController;
    [activityViewController setCompletionWithItemsHandler:^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError){
        if (completed) {
         }
        [weakActivityViewController setCompletionWithItemsHandler:nil];
    }];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}


@end
