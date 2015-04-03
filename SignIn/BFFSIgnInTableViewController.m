//
//  TableViewController.m
//  SignIn
//
//  Created by Momoko Saunders on 1/16/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

#import "BFFSignInTableViewController.h"
#import "BFFNewUserViewController.h"
#import "SignIn-Swift.h"

#import "BCNShopUse.h"
//#import "BCNShopUseLog.h"
#import "BCNContact.h"
#import "BCNContactLog.h"

@interface BFFSignInTableViewController () <UITextFieldDelegate, BFFNewUserViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *uniqueIdentifier;
@property (weak, nonatomic) IBOutlet UIButton *addUser;

@property (strong, nonatomic) BCNContact *contact;
@property (strong, nonatomic) BCNShopUse *shopUse;
@property (strong, nonatomic) NSArray *filteredLog;
@property (strong, nonatomic) NSMutableArray *temporaryLog;

@end

@implementation BFFSignInTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueIdentifier = segue.identifier;
    
    if ([segueIdentifier isEqualToString:@"New User Segue"]) {
        BFFNewUserViewController *newUser =
        (BFFNewUserViewController *)[segue destinationViewController];
        newUser.identifier = self.uniqueIdentifier.text;
        newUser.delegate = self;
    }
    else if ([segueIdentifier isEqualToString:@"Thank You"]) {
       BFFThankYouForSigningIn *thankYou = (BFFThankYouForSigningIn *)[segue destinationViewController];
        thankYou.contact = self.contact;
        thankYou.shopUse = self.shopUse;
    }
}

#pragma mark TableView Delegates

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];
    
    NSInteger lastRowIndex = [self.filteredLog count];
    UITableViewCell *cell;
    if (index == lastRowIndex ) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"New User"
                                               forIndexPath:indexPath];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"personTableViewCell"
                                               forIndexPath:indexPath];
        BCNContact *contact = [self.filteredLog objectAtIndex:index];
        [[cell textLabel] setText:contact.firstName];
        if (contact.colour) {
            cell.backgroundColor = contact.colour;
        } else {
            cell.backgroundColor = [UIColor whiteColor];
        }
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];
    NSInteger lastRowIndex = [self.filteredLog count];
    
    if (index == lastRowIndex ) {
        [self performSegueWithIdentifier:@"New User Segue" sender:self];
    }
    else {
        self.contact = [self.filteredLog objectAtIndex:index];
        [self _createShopUse];
        [self performSegueWithIdentifier:@"Thank You" sender:self];
    }
}

#pragma mark TextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.filteredLog = [[BCNContactLog sharedStore] filteredVolunteerLog];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring
                 stringByReplacingCharactersInRange:range withString:string];
    [self searchAutocompleteEntriesWithSubstring:substring];
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredLog.count + 1;
}

#pragma mark - Helper Methods
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    // Put anything that starts with this substring into the autocompleteUrls array
    // The items in this array is what will show up in the table view
    NSMutableArray *temporaryLog = [[NSMutableArray alloc] init];
    self.temporaryLog = temporaryLog;
    BCNContactLog *log = [BCNContactLog sharedStore];
    self.filteredLog = [log findContactsWhichContainsString:substring];
    [self.tableView reloadData];
}

-(void)showVolunteerPopUp
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Are you here to work on your bike or volunteer?"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Peronal Use" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             [self _createShopUse];
                                                             self.shopUse.volunteer = NO;
                                                         }];
    
    [alert addAction:cancelAction];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Volunteering"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self _createShopUse];
                                                              self.shopUse.volunteer = YES;
                                                          }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];

}

-(void)_createShopUse
{
    BCNShopUse *shopUse = [[[ShopUseLogSwift alloc] init] createShopUse];
    [shopUse setUserIdentity:self.uniqueIdentifier.text];
    [shopUse setSignIn:[NSDate date]];
    [shopUse setSignOut:[NSDate dateWithTimeIntervalSinceNow:(2*60*60)]];
    shopUse.contact = self.contact;
    self.shopUse = shopUse;
}

#pragma mark - New User Delegate Methods

-(void)contactWasSaved
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
