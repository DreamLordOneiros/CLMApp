//
//  AddressBook.m
//  CLMApp
//
//  Created by Yessica Alejandra Cardenas Aviña on 10/03/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import "AddressBook.h"

@interface AddressBook ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@end

@implementation AddressBook

@synthesize dbAdmin, myTableView, contactsArray, addressBook, index, counter, letters, viewContainer, contactTextField, searchFlag, searchName, sectionCounter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    searchFlag = YES;
    searchName = @"";
    sectionCounter = 0;
    
    contactsArray = [[NSMutableArray alloc] init];
    addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    letters = @"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z";
     self.index = [letters componentsSeparatedByString:@" "];
    
    viewContainer.layer.cornerRadius = 20.0;
    viewContainer.layer.borderWidth = 2.5;
    viewContainer.layer.borderColor = [[UIColor grayColor] CGColor];
    viewContainer.layer.masksToBounds = YES;
    
    myTableView.layer.cornerRadius = 20.0;
    myTableView.layer.borderWidth = 2.5;
    myTableView.layer.borderColor = [[UIColor whiteColor] CGColor];
    myTableView.layer.masksToBounds = YES;
    
    //self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_gray.jpg"]];
    self.view.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:156.0/255.0 blue:120.0/255.0 alpha:1.0];
    self.viewContainer.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:156.0/255.0 blue:120.0/255.0 alpha:1.0];

    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    
    [self getPersonOutOfAddressBookWithFullName:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.index count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.index;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self numberOfRowsInSection:section] != 0)
    {
        if ([contactTextField.text length] != 0 && ([contactTextField.text hasPrefix:[index objectAtIndex:section]]))
            return [index objectAtIndex:section];
        return [index objectAtIndex:section];
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self numberOfRowsInSection:section] != 0)
    {
        if ([contactTextField.text length] != 0 && ([contactTextField.text hasPrefix:[index objectAtIndex:section]]))
            return 10;
        return 10;
    }
    return 0;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    NSInteger value = 0;
    for (Person * contact in contactsArray)
    {
        if ([contact.fullName hasPrefix:[index objectAtIndex:section]])
            value +=1;
    }
    return value;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [contactTextField resignFirstResponder];
}

- (BOOL) askPermission
{
    NSString * const kDenied = @"Access to address book is denied";
    NSString * const kRestricted = @"Access to address book is restricted";
    
    CFErrorRef error = NULL;
    
    switch (ABAddressBookGetAuthorizationStatus())
    {
        case kABAuthorizationStatusAuthorized:
        {
            addressBook = ABAddressBookCreateWithOptions(NULL, &error);
            if (addressBook != NULL)
                CFRelease(addressBook);
            break;
        }
        case kABAuthorizationStatusDenied:
        {
            NSLog(@"%@", kDenied);
            break;
        }
        case kABAuthorizationStatusNotDetermined:
        {
            addressBook = ABAddressBookCreateWithOptions(NULL, &error);
            
            ABAddressBookRequestAccessWithCompletion (addressBook, ^(bool granted, CFErrorRef error)
            {
                if (granted)
                    NSLog(@"Access was granted");
                else
                    NSLog(@"Access was not granted");
                
                if (addressBook != NULL)
                    CFRelease(addressBook);
            });
            break;
        }
        case kABAuthorizationStatusRestricted:
        {
            NSLog(@"%@", kRestricted);
            break;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    return YES;
}

-(void)textFieldDidChange:(UITextField*) textField
{
    if (textField.text.length == 0)
        [self getPersonOutOfAddressBookWithFullName:@""];
    else
        [self getPersonOutOfAddressBookWithFullName:textField.text];//searchFlag = YES;
    
    searchName = textField.text;
    [myTableView reloadData];
    NSLog(@"Cosa: %@", searchName);
}

- (void)getPersonOutOfAddressBookWithFullName:(NSString*) fullNameSearch
{
    addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    contactsArray = [[NSMutableArray alloc] init];
    
    if (addressBook != nil && (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized))
    {
        ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
        NSArray *allContacts = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonFirstNameProperty);
        
        NSUInteger i = 0;
        
        for (i = 0; i < [allContacts count]; i++)
        {
            Person * person = [[Person alloc] init];
            
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
            
            NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
            NSString *lastName =  (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
            
            person.firstName = firstName;
            person.lastName = lastName;
            person.fullName = fullName;
            
            //email
            ABMultiValueRef emails = ABRecordCopyValue(contactPerson, kABPersonEmailProperty);
            
            NSUInteger j = 0;
            for (j = 0; j < ABMultiValueGetCount(emails); j++)
            {
                NSString *email = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, j);
                if (j == 0)
                {
                    person.homeEmail = email;
                    NSLog(@"person.homeEmail = %@ ", person.homeEmail);
                }
                
                else if (j==1)
                    person.workEmail = email;
            }
            
            if ([fullNameSearch isEqualToString:@""])
            {
                [contactsArray addObject:person];
            }
            else if([person.fullName hasPrefix:fullNameSearch])
            {
                [contactsArray addObject:person];
            }
        }
    }
    else
        [self askPermission];
    
    CFRelease(addressBook);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    counter = 0;
    
    for (Person * contact in contactsArray)
    {
        
        if ([contact.firstName hasPrefix:[index objectAtIndex:section]])
            counter ++;
    }
    return counter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"addressCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    NSMutableArray * contacts = [[NSMutableArray alloc]init];
    
    for (Person * contact in contactsArray)
    {
        if ([contact.firstName hasPrefix:[index objectAtIndex:indexPath.section]])
        {
            [contacts addObject:contact];
        }
    }
    
    Person *person = [contacts objectAtIndex:indexPath.row];
    
    cell.textLabel.text = person.fullName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Person * person = [contactsArray objectAtIndex:indexPath.row];
    
    //ContactViewController *contactViewController = [[ContactViewController alloc] initWithPerson:person];
    //[self.navigationController pushViewController:contactViewController animated:YES];
}

- (BOOL) doesPersonExistWithFirstName:(NSString *)paramFirstName lastName:(NSString *)paramLastName inAddressBook:(ABRecordRef)paramAddressBook
{
    BOOL result = NO;
    
    if (paramAddressBook == NULL)
    {
        NSLog(@"The address book is null.");
        return NO;
    }
    
    NSArray *allPeople = (__bridge_transfer NSArray *) ABAddressBookCopyArrayOfAllPeople(paramAddressBook);
    
    NSUInteger peopleCounter = 0;
    for (peopleCounter = 0; peopleCounter < [allPeople count]; peopleCounter++)
    {
        ABRecordRef person = (__bridge ABRecordRef)
        [allPeople objectAtIndex:peopleCounter];
        
        NSString *firstName = (__bridge_transfer NSString *)
        ABRecordCopyValue(person, kABPersonFirstNameProperty);
        
        NSString *lastName = (__bridge_transfer NSString *)
        ABRecordCopyValue(person, kABPersonLastNameProperty);
        
        BOOL firstNameIsEqual = NO;
        BOOL lastNameIsEqual = NO;
        
        if ([firstName length] == 0 && [paramFirstName length] == 0)
            firstNameIsEqual = YES;
        else if ([firstName isEqualToString:paramFirstName])
            firstNameIsEqual = YES;
        if ([lastName length] == 0 && [paramLastName length] == 0)
            lastNameIsEqual = YES;
        else if ([lastName isEqualToString:paramLastName])
            lastNameIsEqual = YES;
        if (firstNameIsEqual && lastNameIsEqual)
            return YES;
    }
    return result;
}

- (BOOL) doesGroupExistWithGroupName:(NSString *)paramGroupName inAddressBook:(ABAddressBookRef)paramAddressBook
{
    BOOL result = NO;
    
    if (paramAddressBook == NULL)
    {
        NSLog(@"The address book is null.");
        return NO;
    }
    
    NSArray *allGroups = (__bridge_transfer NSArray *)
    ABAddressBookCopyArrayOfAllGroups(paramAddressBook);
    
    NSUInteger groupCounter = 0;
    for (groupCounter = 0; groupCounter < [allGroups count]; groupCounter++)
    {
        ABRecordRef group = (__bridge ABRecordRef)
        [allGroups objectAtIndex:groupCounter];
        
        NSString *groupName = (__bridge_transfer NSString *)
        ABRecordCopyValue(group, kABGroupNameProperty);
        
        if ([groupName length] == 0 && [paramGroupName length] == 0)
            return YES;
        else if ([groupName isEqualToString:paramGroupName])
            return YES;
    }
    return result;
}

- (ABRecordRef) newGroupWithName:(NSString *)paramGroupName inAddressBook:(ABAddressBookRef)paramAddressBook
{
    
    ABRecordRef result = NULL;
    
    if (paramAddressBook == NULL)
    {
        NSLog(@"The address book is nil.");
        return NULL;
    }
    
    result = ABGroupCreate();
    
    if (result == NULL)
    {
        NSLog(@"Failed to create a new group.");
        return NULL;
    }
    
    BOOL couldSetGroupName = NO;
    CFErrorRef error = NULL;
    
    couldSetGroupName = ABRecordSetValue(result, kABGroupNameProperty, (__bridge CFTypeRef)paramGroupName, &error);
    
    if (couldSetGroupName)
    {
        BOOL couldAddRecord = NO;
        CFErrorRef couldAddRecordError = NULL;
        
        couldAddRecord = ABAddressBookAddRecord(paramAddressBook, result, &couldAddRecordError);
        
        if (couldAddRecord)
        {
            NSLog(@"Successfully added the new group.");
            
            if (ABAddressBookHasUnsavedChanges(paramAddressBook))
            {
                BOOL couldSaveAddressBook = NO;
                CFErrorRef couldSaveAddressBookError = NULL;
                couldSaveAddressBook = ABAddressBookSave(paramAddressBook, &couldSaveAddressBookError);
                
                if (couldSaveAddressBook)
                    NSLog(@"Successfully saved the address book.");
                else
                {
                    CFRelease(result);
                    result = NULL;
                    NSLog(@"Failed to save the address book.");
                }
            }
            else
            {
                CFRelease(result);
                result = NULL;
                NSLog(@"No unsaved changes.");
            }
        }
        else
        {
            CFRelease(result);
            result = NULL;
            NSLog(@"Could not add a new group.");
        }
    }
    else
    {
        CFRelease(result);
        result = NULL;
        NSLog(@"Failed to set the name of the group.");
    }
    return result;
}

- (void) createGroupInAddressBook:(ABAddressBookRef)paramAddressBook
{
    if ([self doesGroupExistWithGroupName:@"O'Reilly" inAddressBook:self.addressBook])
        NSLog(@"The O'Reilly group already exists in the address book.");
    else
    {
        ABRecordRef oreillyGroup = [self newGroupWithName:@"O'Reilly" inAddressBook:self.addressBook];
        
        if (oreillyGroup != NULL)
        {
            NSLog(@"Successfully created a group for O'Reilly.");
            CFRelease(oreillyGroup);
        }
        else
            NSLog(@"Failed to create a group for O'Reilly.");
    }
}

- (ABRecordRef) newPersonWithFirstName:(NSString *)paramFirstName lastName:(NSString *)paramLastName inAddressBook:(ABAddressBookRef)paramAddressBook
{
    ABRecordRef result = NULL;
    
    if (paramAddressBook == NULL)
    {
        NSLog(@"The address book is NULL.");
        return NULL;
    }
    
    if ([paramFirstName length] == 0 && [paramLastName length] == 0)
    {
        NSLog(@"First name and last name are both empty.");
        return NULL;
    }
    
    result = ABPersonCreate();
    
    if (result == NULL)
    {
        NSLog(@"Failed to create a new person.");
        return NULL;
    }
    
    BOOL couldSetFirstName = NO;
    BOOL couldSetLastName = NO;
    CFErrorRef setFirstNameError = NULL;
    CFErrorRef setLastNameError = NULL;
    
    couldSetFirstName = ABRecordSetValue(result, kABPersonFirstNameProperty, (__bridge CFTypeRef)paramFirstName, &setFirstNameError);
    
    couldSetLastName = ABRecordSetValue(result, kABPersonLastNameProperty, (__bridge CFTypeRef)paramLastName, &setLastNameError);
    
    CFErrorRef couldAddPersonError = NULL;
    BOOL couldAddPerson = ABAddressBookAddRecord(paramAddressBook, result, &couldAddPersonError);
    
    if (couldAddPerson)
        NSLog(@"Successfully added the person.");
    else
    {
        NSLog(@"Failed to add the person.");
        CFRelease(result);
        result = NULL;
        return result;
    }
    
    if (ABAddressBookHasUnsavedChanges(paramAddressBook))
    {
        
        CFErrorRef couldSaveAddressBookError = NULL;
        BOOL couldSaveAddressBook = ABAddressBookSave(paramAddressBook, &couldSaveAddressBookError);
        
        if (couldSaveAddressBook)
            NSLog(@"Successfully saved the address book.");
        else
            NSLog(@"Failed to save the address book.");
    }
    
    if (couldSetFirstName && couldSetLastName)
        NSLog(@"Successfully set the first name and the last name of the person.");
    else
        NSLog(@"Failed to set the first name and/or last name of the person.");
    return result;
}

- (BOOL) doesPersonExistWithFullName:(NSString *)paramFullName inAddressBook:(ABAddressBookRef)paramAddressBook
{
    BOOL result = NO;
    
    if (paramAddressBook == NULL)
    {
        NSLog(@"Address book is null.");
        return NO;
    }
    
    NSArray *allPeopleWithThisName = (__bridge_transfer NSArray *) ABAddressBookCopyPeopleWithName(paramAddressBook, (__bridge CFStringRef)paramFullName);
    
    if ([allPeopleWithThisName count] > 0)
        result = YES;
    
    return result;
}

- (void) createPersonInAddressBook:(ABAddressBookRef)paramAddressBook
{
    if ([self doesPersonExistWithFullName:@"Anthony Robbins" inAddressBook:self.addressBook])
        NSLog(@"Anthony Robbins exists in the address book.");
    else
    {
        NSLog(@"Anthony Robbins does not exist in the address book.");
        
        ABRecordRef anthonyRobbins = [self newPersonWithFirstName:@"Anthony" lastName:@"Robbins" inAddressBook:self.addressBook];
        
        if (anthonyRobbins != NULL)
        {
            NSLog(@"Successfully created a record for Anthony Robbins");
            CFRelease(anthonyRobbins);
        }
        else
            NSLog(@"Failed to create a record for Anthony Robbins");
    }
}

/*-(NSInteger) getSectionCount
{
    sectionCounter = 0;
    
    NSString * letter = [[NSString alloc] init];
    
    for (NSString * initial in index)
    {
        if (![letter isEqualToString:initial])
        {
            letter = initial;
            
            for (Person * contact in contactsArray)
            {
                if ([contact.firstName hasPrefix:letter])
                    sectionCounter += 1;
            }
        }
    }
    
    return sectionCounter;
}*/

@end
