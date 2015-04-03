//
//  NewUserViewController.m
//  SignIn
//
//  Created by Momoko Saunders on 1/16/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

#import "BFFNewUserViewController.h"
#import "BCNContact.h"
#import "BCNContactLog.h"
#import "BCNShopUse.h"
#import "BCNShopUseLog.h"

#import "SignIn-Swift.h"

@interface BFFNewUserViewController ()

@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *pin;

@property (strong, nonatomic) BCNShopUse *shopUse;

@property (weak, nonatomic) IBOutlet UITableView *colourTableView;

@end

@implementation BFFNewUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contact = [[BCNContact alloc] init];
    if (self.identifier) {
        self.firstName.text = self.identifier;
    } else {
        [self.firstName becomeFirstResponder];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Thank You"]) {
        BFFThankYouForSigningIn *thankYou = (BFFThankYouForSigningIn *)[segue destinationViewController];
        thankYou.contact = self.contact;
        thankYou.shopUse = self.shopUse;
    }
}
- (IBAction)usingTheShop:(id)sender
{
    [self _createShopUse];
    self.shopUse.volunteer = NO;
    [self showWaiver];
}

- (IBAction)volunteering:(id)sender
{
    [self _createShopUse];
    // my thought is that we set volunteer to something too late.
    self.shopUse.volunteer = YES;
    [self showWaiver];
}

- (void)showWaiver;
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Waiver - You're working on your bike - Please don't sue us"
                                                                   message:@" I, and my heirs, in consideration of my participation in Bike Farm Inc., hereby release Bike Farm Inc., its officers, employees and agents, and any other people officially connected with this event, from any and all liability for damage to or loss of personal property, sickness or injury from whatever source, legal entanglements, imprisonment, death, or loss of money, which might occur while participating in this event. Specifically, I release said persons from any liability or responsibility for injury while working on my bike and other accidents relating to riding this bicycle. I am aware of the risks of participation, which include, but are not limited to, the possibility of sprained muscles and ligaments, broken bones and fatigue. I hereby state that I am in sufficient physical condition to accept a rigorous level of physical activity. I understand that participation in this program is strictly voluntary and I freely chose to participate. I understand that Bike Farm does not provide medical coverage for me. I verify that I will be responsible for any medical costs I incur as a result of my participation."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:cancelAction];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"I Agree"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self.delegate contactWasSaved];
                                                              [self performSegueWithIdentifier:@"Thank You" sender:self];
                                                          }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)_createShopUse
{
    self.contact.firstName = self.firstName.text;
    self.contact.lastName = self.lastName.text;
    self.contact.emailAddress = self.email.text;
    self.contact.pin = self.pin.text;

    [[BCNContactLog sharedStore] saveContact:self.contact];
    ShopUseLogSwift *shopUseLog = [[ShopUseLogSwift alloc] init];
    BCNShopUse *shopUse = shopUseLog.createShopUse;
    if (![self.pin.text isEqual:@""]) {
        [shopUse setUserIdentity:self.pin.text];
    } else if (![self.email.text isEqual:@""]) {
        [shopUse setUserIdentity:self.email.text];
    } else {
        [shopUse setUserIdentity:[NSString stringWithFormat:@"%@%@", self.firstName.text, self.lastName.text]];
    }
    [shopUse setSignIn:[NSDate date]];
    [shopUse setSignOut:[NSDate dateWithTimeIntervalSinceNow:(2*60*60)]];
    shopUse.contact = self.contact;
    self.shopUse = shopUse;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

#pragma mark - TableView Delegates
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Purple Cell"
                                               forIndexPath:indexPath];
        cell.backgroundColor = [UIColor purpleColor];
    }
    else if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Blue Cell"
                                               forIndexPath:indexPath];
        cell.backgroundColor = [UIColor cyanColor];
    }
    else if (indexPath.row == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Green Cell"
                                               forIndexPath:indexPath];
        cell.backgroundColor = [UIColor greenColor];
    }
    else if (indexPath.row == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Yellow Cell"
                                               forIndexPath:indexPath];
        cell.backgroundColor = [UIColor yellowColor];
    }
    else if (indexPath.row == 4) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Orange Cell"
                                               forIndexPath:indexPath];
        cell.backgroundColor = [UIColor orangeColor];
    }
    else if (indexPath.row == 5) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Red Cell"
                                               forIndexPath:indexPath];
        cell.backgroundColor = [UIColor redColor];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.contact.colour = [tableView cellForRowAtIndexPath:indexPath].backgroundColor;
    self.view.backgroundColor = self.contact.colour;
}

@end
