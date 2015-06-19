//
//  Copyright (c) 2014 Bike Farm. All rights reserved.
//

#import "BCNContactLog.h"
#import "BCNContact.h"
#import "BCNShopUse.h"
#import "BCNShopUseLog.h"

@interface BCNContactLog ()

@property (nonatomic, strong) NSMutableArray *privateContacts;

@end

// rememeber to change "item" to Contact

@implementation BCNContactLog

+ (instancetype)sharedStore
{
    static BCNContactLog *sharedStore = nil;
    
    //do I need to create a sharedStore?
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}

//If a programmer calls [BCNContactLog alloc] init], let her
// know the error of her ways
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[BCNContactLog sharedStore]"
                                 userInfo:nil];
    return nil;
}

//Here is the real (secret) initializer
- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        NSString *path = [self contactsArchivePath];
        _privateContacts = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (!_privateContacts) {
            _privateContacts = [[NSMutableArray alloc] init];
        }
    }
    // this will be where we add the data base of bike farm contacts
    BCNContact *james = [[BCNContact alloc] init];
    [james setFirstName:@"James"];
    [james setLastName:@"Moore"];
    [james setPin:@"1234"];
    [james setVolunteer:YES];
    james.membershipExpiration = [NSDate dateWithTimeIntervalSinceNow:-10000];
    [[self privateContacts] addObject:james];
    BCNContact *jamesF = [[BCNContact alloc] init];
    [jamesF setFirstName:@"James"];
    [jamesF setLastName:@"Folsom"];
    [jamesF setPin:@"8732"];
    [jamesF setVolunteer:YES];
    jamesF.membershipExpiration = [NSDate dateWithTimeIntervalSinceNow:1000000];
    [[self privateContacts] addObject:jamesF];
    BCNContact *momoko = [[BCNContact alloc] init];
    [momoko setFirstName:@"momoko"];
    [momoko setLastName:@"Saunders"];
    [momoko setPin:@"5678"];
    [momoko setVolunteer:YES];
    momoko.membershipExpiration = [NSDate dateWithTimeIntervalSinceNow:1000000];
    [[self privateContacts] addObject:momoko];

    return self;
}

- (NSArray *)contactLog
{
    return [self privateContacts];
}

-(NSArray *)filteredVolunteerLog
{
    BCNShopUse *currentUser = [[[BCNShopUseLog sharedStore] shopUseLog] lastObject];
    NSString *userIdentity = [currentUser userIdentity];
    NSPredicate *filterForShopUse= [NSPredicate predicateWithFormat:@"firstName ==[c] %@ OR lastName ==[c] %@ OR pin ==[c] %@ OR emailAddress ==[c] %@", userIdentity, userIdentity, userIdentity, userIdentity];
    NSArray *filteredVolunteerLog =
    [[NSArray alloc] initWithArray:[[self privateContacts] filteredArrayUsingPredicate:filterForShopUse]];
    return filteredVolunteerLog;
}

- (BCNContact *)createContact
{
    BCNContact *contact = [[BCNContact alloc] init];
    
    [[self privateContacts] addObject:contact];
    return contact;
}

- (void)removeItem:(BCNContact *)contact
{
    [[self privateContacts] removeObjectIdenticalTo:contact];
}

// this is here to populate the data of volunteers and members, it will be deleted when we use core data
- (NSArray *)createExistingContacts
{
    NSArray *contacts = [BCNContact existingContacts];
    [[self privateContacts] addObject:contacts];
    return contacts;
}


- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    //Get pointer to object being moved so you can re-insert it
    BCNContact *contact = [[self privateContacts] objectAtIndex:fromIndex];
    
    // Remove item from arrray
    BCNContact *removedItem = [[self privateContacts] objectAtIndex:fromIndex];
    [[self privateContacts] removeObject:removedItem];
    
    //insert item in array at new location
    [[self privateContacts] insertObject:contact atIndex:toIndex];
}

-(NSArray *)findContactsWhichContainsString:(NSString *)substring
{
    NSString *userIdentity = substring;
    NSPredicate *filterForShopUse= [NSPredicate predicateWithFormat:@"firstName ==[c] %@ OR lastName ==[c] %@ OR pin ==[c] %@ OR emailAddress ==[c] %@", userIdentity, userIdentity, userIdentity, userIdentity];
    NSArray *filteredVolunteerLog =
    [[NSArray alloc] initWithArray:[[self privateContacts] filteredArrayUsingPredicate:filterForShopUse]];
    return filteredVolunteerLog;
}

- (NSString *)contactsArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory =[documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"contacts.archive"];
}


-(void)saveContact:(BCNContactLog *)contact
{
//    if (self.shouldActuallySave) {
    [[self privateContacts] addObject:contact];
    [self saveToFile];
//    }
}

-(BOOL)saveToFile
{
    NSString *path = self.contactsArchivePath;
    return [NSKeyedArchiver archiveRootObject:self.privateContacts toFile:path];
}

- (NSString *)commaSeporatedStyle;
{
    NSString *contactString = @"";
    NSString *commaSeporatedString = @"First name, Last name, Email,\n";
    for (BCNContact *contact in self.contactLog) {
        contactString = [NSString stringWithFormat:@"%@, %@, %@,\n", contact.firstName, contact.lastName, contact.emailAddress];
        commaSeporatedString = [commaSeporatedString stringByAppendingString:contactString];
    }
    
    return commaSeporatedString;
}

@end
