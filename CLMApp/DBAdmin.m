//
//  DBAdmin.m
//  NFLStats
//
//  Created by Yessica Alejandra Cardenas Aviña on 22/02/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import "DBAdmin.h"

@implementation DBAdmin
@synthesize databasePath, directoryDB, statement;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Build the path to the database file
-(void) prepareDBPath
{
    databasePath = [[NSString alloc] initWithString: [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent: @"directoryDB.db"]];
}

//Check If DB Exists And Tries To Open It, If It Don't Exists, Attemps To Create It And Open It
-(BOOL) checkForDB
{
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] != YES)
    {
        if ([self openDB])
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS contacts (id INTEGER PRIMARY KEY AUTOINCREMENT, fname TEXT, lname TEXT, tcsmail TEXT, anumber TEXT, phone TEXT, address INTEGER, Account INTEGER, role INTEGER)";
            if (sqlite3_exec(directoryDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create 'Contacts' table");
                return NO;
            }
            else
                NSLog(@"Table created/Ready");
            //////////////////////////////////////////////////////////////////////////////////////////////
            sql_stmt = "CREATE TABLE IF NOT EXISTS accounts (id INTEGER PRIMARY KEY AUTOINCREMENT, aname TEXT, adetails TEXT)";
            if (sqlite3_exec(directoryDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create 'Accounts' table");
                return NO;
            }
            else
                NSLog(@"Table created/Ready");
            
            //////////////////////////////////////////////////////////////////////////////////////////////
            sql_stmt = "CREATE TABLE IF NOT EXISTS roles (id INTEGER PRIMARY KEY AUTOINCREMENT, rname TEXT, rdetails TEXT)";
            if (sqlite3_exec(directoryDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create 'Roles' table");
                return NO;
            }
            else
                NSLog(@"Table created/Ready");
            
            //////////////////////////////////////////////////////////////////////////////////////////////
            sql_stmt = "CREATE TABLE IF NOT EXISTS movements (id INTEGER PRIMARY KEY AUTOINCREMENT, mdetail TEXT, ammount INTEGER, mtype INTEGER)";
            if (sqlite3_exec(directoryDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table");
                return NO;
            }
            else
                NSLog(@"Table created/Ready");
            
            //////////////////////////////////////////////////////////////////////////////////////////////
            sql_stmt = "CREATE TABLE IF NOT EXISTS mtype (id INTEGER PRIMARY KEY AUTOINCREMENT, mname TEXT)";
            if (sqlite3_exec(directoryDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create 'MType' table");
                return NO;
            }
            else
                NSLog(@"Table created/Ready");
            
            //////////////////////////////////////////////////////////////////////////////////////////////
            sql_stmt = "CREATE TABLE IF NOT EXISTS places (id INTEGER PRIMARY KEY AUTOINCREMENT, address TEXT)";
            if (sqlite3_exec(directoryDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table");
                return NO;
            }
            else
                NSLog(@"Table created/Ready");
            
            
            [self closeDB];
            
            if([self initializeDBData])
                NSLog(@"Data Added!");
        }
        else
        {
            NSLog(@"Failed to open/create database");
            return NO;
        }
    }
    else
    {
        NSLog(@"Database ready!");
    }
    [self closeDB];
    return YES;
}

//Open DB, Returns BOOL
-(BOOL) openDB
{
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &directoryDB) == SQLITE_OK)
    {
        NSLog(@"DB Open");
        return YES;
    }
    else
        return NO;
}

//Close DB, Returns BOOL
-(BOOL) closeDB
{
    if (statement)
    {
        sqlite3_finalize(statement);
        statement = NULL;
    }
    
    if (directoryDB)
    {
        NSLog(@"DB Closed");
        sqlite3_close(directoryDB);
        directoryDB = nil;
        return YES;
    }
    else
        return YES;
}

//Prepares The Statement To Process
-(BOOL) prepareStatement:(NSString *)stmt
{
    const char * new_stmt = [stmt UTF8String];
    
    if (sqlite3_prepare_v2(directoryDB, new_stmt, -1, &statement, NULL) != SQLITE_OK)
    {
        NSLog(@"%s Prepare status: '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(directoryDB), sqlite3_errcode(directoryDB));
        NSLog(@"%@", stmt);
        statement = NULL;
        return NO;
    }
    else
        return YES;
}

//Inserts A New Contact Returns BOOL  - contactFName, contactLName, contactEmail, contactANumber, contactPNumber, contactAddress, contactAccount, contactRole
-(BOOL) insertNewContact:(NSString*) fname :(NSString*) lname :(NSString*) email :(NSString*) anumber :(NSString*) pnumber :(NSString*) address :(NSInteger) account :(NSInteger) role
{
    if ([self checkAddress:address] == 0)
    {
        [self insertNewPlace:address];
    }
    NSInteger addid = [self getAddressID:address];
    
    if ([self openDB])
    {        
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO contacts (fname, lname, tcsmail, anumber, phone, address, account, role) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", %li, %li, %li)", fname, lname, email, anumber, pnumber, (long)addid, (long)account, (long)role];
        
        NSLog(@"Statement: %@", insertSQL);
        
        [self prepareStatement:insertSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Contact added");
            return YES;
        }
        else
        {
            NSLog(@"Failed to add contact");
            return NO;
        }
        [self closeDB];
    }
    else
    return YES;
}

-(BOOL) insertNewPlace:(NSString*) address
{
    if ([self openDB])
    {
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO places (address) VALUES (\"%@\")", address];
            
        NSLog(@"Statement: %@", insertSQL);
            
        [self prepareStatement:insertSQL];
            
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Place added");
            return YES;
        }
        else
        {
            NSLog(@"Failed to add place");
            return NO;
        }
        [self closeDB];
    }
        else
        return YES;
}

-(int) checkAddress:(NSString*) address
{
    int articlesCount = 0;
    if ([self openDB])
    {
        NSString * querySQL = [NSString stringWithFormat: @"SELECT COUNT(*) FROM places WHERE address = \"%@\"", address];
        
        if([self prepareStatement:querySQL])
        {
            if( sqlite3_step(statement) == SQLITE_ROW )
                articlesCount  = sqlite3_column_int(statement, 0);
        }
        [self closeDB];
    }
    
    return articlesCount;
}

-(NSInteger) getAddressID:(NSString*) address
{
    NSString * querySQL = [NSString stringWithFormat:@"SELECT id FROM places WHERE address = \"%@\"", address];
    
    if ([self openDB])
    {
        [self prepareStatement:querySQL];
        
        if (sqlite3_step(statement))
        {
            NSString * adID = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 0)];
            [self closeDB];
            return [adID integerValue];
        }
        
        while (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSString * adID = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 0)];
            [self closeDB];
            return [adID integerValue];
        }
        return -1;
    }
    else
        return -1;
}

//Updates Contact, Returns BOOL
-(BOOL) updateContact:(int) contactID :(int) account :(int) role
{
    NSString * updateSQL = [NSString stringWithFormat:@"UPDATE contacts SET account = %i, role = %i WHERE id = %i", account, role, contactID];
    
    if ([self openDB])
    {
        [self prepareStatement:updateSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            [self closeDB];
            return YES;
        }
        else
        {
            [self closeDB];
            return NO;
        }
    }
    else
        return NO;
}

/*//Updates Contact, Returns BOOL
-(BOOL) updateContact:(NSString*) iD :(NSString*) fname :(NSString*) lname :(NSString*) phone :(NSString*) age :(NSString*) date :(NSString*) longitude :(NSString*) latitude
{
    NSString * updateSQL = [NSString stringWithFormat:@"UPDATE players SET fname = \"%@\", lname = \"%@\", phone = \"%@\", age = \"%@\", date = \"%@\", longitude = \"%@\", latitude = \"%@\" WHERE id = \"%@\"", fname, lname, phone, age, date, longitude, latitude, iD];
    
    if ([self openDB])
    {
        [self prepareStatement:updateSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            [self closeDB];
            return YES;
        }
        else
        {
            [self closeDB];
            return NO;
        }
    }
    else
        return NO;
}*/

//Deletes The Contact From DB That Matches The Name
-(BOOL) deleteContactByID:(NSString*) iD
{
    NSString * deleteQuery = [NSString stringWithFormat:@"DELETE FROM contacts WHERE id = \"%@\"", iD];
    
    [self openDB];
    
    [self prepareStatement:deleteQuery];
    
    if (sqlite3_step(statement))
    {
        NSLog(@"Contact Deleted");
        [self closeDB];
        return YES;
    }
    else
    {
        [self closeDB];
        return NO;
    }
}

//Get An Array Containing All The Data Of A Player
-(NSArray*) getContactByID:(NSString*) iD
{
    NSMutableArray * contact = [[NSMutableArray alloc]init];
    
    if ([self openDB])
    {
        NSString * selectQuery = [NSString stringWithFormat:@"SELECT * FROM contacts WHERE id = \"%@\"", iD];
        
        if ([self prepareStatement:selectQuery])
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                [contact addObject: [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 0)]];
                [contact addObject: [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 1)]];
                [contact addObject: [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 2)]];
                [contact addObject: [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 3)]];
                [contact addObject: [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 4)]];
                [contact addObject: [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 5)]];
                [contact addObject: [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 6)]];
                [contact addObject: [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 7)]];
            }
        }
        [self closeDB];
    }
    return contact;
}
//Get An Array Containing All The Data Of A Player
-(NSArray*) getContacts
{
    NSMutableArray * contacts = [[NSMutableArray alloc]init];
    
    if ([self openDB])
    {
        NSString * selectQuery = @"SELECT contacts.id, fname, lname, tcsmail, anumber, phone, places.address, aname, rname FROM contacts INNER JOIN accounts ON contacts.account = accounts.id  INNER JOIN roles ON contacts.role = roles.id INNER JOIN places ON contacts.address = places.id";
        
        if ([self prepareStatement:selectQuery])
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableArray * contact = [[NSMutableArray alloc] init];
                [contact addObject: [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 0)]];
                [contact addObject: [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 1)]];
                [contact addObject: [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 2)]];
                [contact addObject: [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 3)]];
                [contact addObject: [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 4)]];
                [contact addObject: [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 5)]];
                [contact addObject: [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 6)]];
                [contact addObject: [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 7)]];
                [contact addObject: [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 8)]];
                [contacts addObject:contact];
            }
        }
        [self closeDB];
    }
    return contacts;
}

//Get An Array Containing The Players Names For A Team Given
-(NSArray*) getAccountByName:(NSString*) account
{
    NSMutableArray * players = [[NSMutableArray alloc]init];
    //id, fname, lname, tcsmail, anumber, phone, address, Account, role
    if ([self openDB])
    {
        NSString * selectQuery = [NSString stringWithFormat:@"SELECT contacts.id, fname, lname, tcsmail, anumber, phone, places.address, aname, rname FROM contacts INNER JOIN accounts ON contacts.account = accounts.id  INNER JOIN roles ON contacts.role = roles.id INNER JOIN places ON contacts.address = places.id WHERE aname = \"%@\"", account];
        
        if ([self prepareStatement:selectQuery])
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableArray * contact = [[NSMutableArray alloc] init];
                [contact addObject:[[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 0)]];
                [contact addObject:[[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 1)]];
                [contact addObject:[[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 2)]];
                [contact addObject:[[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 3)]];
                [contact addObject:[[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 4)]];
                [contact addObject:[[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 5)]];
                [contact addObject:[[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 6)]];
                [contact addObject:[[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 7)]];
                [contact addObject:[[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 8)]];
                [players addObject: contact];
            }
        }
        [self closeDB];
    }
    return players;
}

//Get An Array Containing The Names Of The Accounts In Wich The Contacts Are Included
-(NSArray*) getAccounts
{
    NSMutableArray * contacts = [[NSMutableArray alloc] init];
    
    if ([self openDB])
    {
        NSString * selectQuery = @"SELECT DISTINCT aname FROM contacts INNER JOIN accounts ON contacts.account = accounts.id";
        
        if ([self prepareStatement:selectQuery])
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString * data = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 0)];
                [contacts addObject: data];
            }
        }
        [self closeDB];
    }
    return contacts;
}


//Get An Array Containing The Names Of The Diferent Accounts Available
-(NSArray*) getAccountsList
{
    NSMutableArray * accounts = [[NSMutableArray alloc] init];
    
    if ([self openDB])
    {
        NSString * selectQuery = @"SELECT DISTINCT aname FROM accounts";
        
        if ([self prepareStatement:selectQuery])
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString * data = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 0)];
                [accounts addObject: data];
            }
        }
        [self closeDB];
    }
    return accounts;
}

//Get An Array Containing The Names Of The Diferent Roles
-(NSArray*) getRoles
{
    NSMutableArray * roles = [[NSMutableArray alloc] init];
    
    if ([self openDB])
    {
        NSString * selectQuery = @"SELECT DISTINCT rname FROM roles";
        
        if ([self prepareStatement:selectQuery])
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString * data = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 0)];
                [roles addObject: data];
            }
        }
        [self closeDB];
    }
    return roles;
}

-(NSArray*) getMovements:(NSString*) mType
{
    NSMutableArray * movements = [[NSMutableArray alloc] init];
    
    if ([self openDB])
    {
        NSString * selectQuery = [NSString stringWithFormat:@"SELECT * FROM movements WHERE mtype = %@", mType];
        
        if ([self prepareStatement:selectQuery])
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableArray * movement = [[NSMutableArray alloc] init];
                [movement addObject:[[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 0)]];
                [movement addObject:[[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 1)]];
                [movement addObject:[[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 2)]];
                [movement addObject:[[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text( statement, 3)]];
                [movements addObject: movement];
            }
        }
        [self closeDB];
    }
    return movements;
}

-(NSArray*) getMovementsAmmounts
{
    NSMutableArray * movements = [[NSMutableArray alloc] init];
    
    [movements addObject:[self getMovements:@"1"]];
    [movements addObject:[self getMovements:@"2"]];
    [movements addObject:[self getMovements:@"3"]];
    [movements addObject:[self getMovements:@"4"]];
    
    return movements;
}

//Inserts A New Contact Returns BOOL
-(BOOL) insertNewMovement:(NSString*) detail :(NSString*) amount :(NSString*) type
{
    if ([self openDB])
    {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO movements (mdetail, ammount, mtype) VALUES (\"%@\", %@, %@)", detail, amount, type];
        
        NSLog(@"Statement: %@", insertSQL);
        
        [self prepareStatement:insertSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Movement added");
            [self closeDB];
            return YES;
        }
        NSLog(@"Failed to add movement");
        [self closeDB];
        return NO;
    }
    else
        return NO;
}

//Deletes The Contact From DB That Matches The Name
-(BOOL) deleteMovementByID:(NSString*) iD
{
    NSString * deleteQuery = [NSString stringWithFormat:@"DELETE FROM movements WHERE id = \"%@\"", iD];
    
    [self openDB];
    
    [self prepareStatement:deleteQuery];
    
    if (sqlite3_step(statement))
    {
        NSLog(@"Movement Deleted");
        [self closeDB];
        return YES;
    }
    else
    {
        [self closeDB];
        return NO;
    }
}

//Inserts A New Contact Returns BOOL
-(BOOL) initializeDBData
{
    if ([self openDB])
    {
        //Contacts - id, fname, lname, tcsmail, anumber, phone, address, Account, role
        
        NSString *insertSQL = @"INSERT INTO contacts (fname, lname, tcsmail, anumber, phone, address, Account, role) values (\"Javier\", \"Hernandez\", \"hernandez.javier@tcs.com\", \"858485\", \"3121357029\", 1, 1, 1)";
        
        NSLog(@"Statement: %@", insertSQL);
        
        [self prepareStatement:insertSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Contact added");
            //return YES;
        }
        else
        {
            NSLog(@"Failed to add contact");
            //return NO;
        }
        
        insertSQL = @"INSERT INTO contacts (fname, lname, tcsmail, anumber, phone, address, Account, role) values (\"Emilio\", \"Ojeda\", \"ojeda.emilio@tcs.com\", \"858496\", \"1234567890\", 2, 1, 1)";
        
        NSLog(@"Statement: %@", insertSQL);
        
        [self prepareStatement:insertSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Contact added");
            //return YES;
        }
        else
        {
            NSLog(@"Failed to add contact");
            //return NO;
        }
        
        insertSQL = @"INSERT INTO contacts (fname, lname, tcsmail, anumber, phone, address, Account, role) values (\"Irvin\", \"Jimenez\", \"jimenez.irvin@tcs.com\", \"987653\", \"3121357029\", 3, 1, 1)";
        
        NSLog(@"Statement: %@", insertSQL);
        
        [self prepareStatement:insertSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Contact added");
            //return YES;
        }
        else
        {
            NSLog(@"Failed to add contact");
            //return NO;
        }
        
        insertSQL = @"INSERT INTO contacts (fname, lname, tcsmail, anumber, phone, address, Account, role) values (\"Felipe\", \"Perez\", \"perez.felipe@tcs.com\", \"918273\", \"986543210\", 2, 1, 1)";
        
        NSLog(@"Statement: %@", insertSQL);
        
        [self prepareStatement:insertSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Contact added");
            //return YES;
        }
        else
        {
            NSLog(@"Failed to add contact");
            //return NO;
        }
        ///////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        insertSQL = @"INSERT INTO accounts (aname, adetails) VALUES (\"USAA\", \"US Army Bank\")";
        
        NSLog(@"Statement: %@", insertSQL);
        
        [self prepareStatement:insertSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Account added");
            //return YES;
        }
        else
        {
            NSLog(@"Failed to add account");
            //return NO;
        }
        
        insertSQL = @"INSERT INTO accounts (aname, adetails) VALUES (\"GE\", \"Stuffs For Home\")";
        
        NSLog(@"Statement: %@", insertSQL);
        
        [self prepareStatement:insertSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Account added");
            //return YES;
        }
        else
        {
            NSLog(@"Failed to add account");
            //return NO;
        }
        
        
        insertSQL = @"INSERT INTO accounts (aname, adetails) VALUES (\"Morgan Stanley\", \"Assurance\")";
        
        NSLog(@"Statement: %@", insertSQL);
        
        [self prepareStatement:insertSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Account added");
            //return YES;
        }
        else
        {
            NSLog(@"Failed to add account");
            //return NO;
        }
        
        insertSQL = @"INSERT INTO accounts (aname, adetails) VALUES (\"BOA\", \"Some Bank\")";
        
        NSLog(@"Statement: %@", insertSQL);
        
        [self prepareStatement:insertSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Account added");
            //return YES;
        }
        else
        {
            NSLog(@"Failed to add account");
            //return NO;
        }
        ///////////////////////////////////////////////////////////////////////////////////////////
        
        insertSQL = @"INSERT INTO roles (rname, rdetails) VALUES (\"Trainee\", \"Freshmen\")";
        
        NSLog(@"Statement: %@", insertSQL);
        
        [self prepareStatement:insertSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Role added");
            //return YES;
        }
        else
        {
            NSLog(@"Failed to add role");
            //return NO;
        }
        
        insertSQL = @"INSERT INTO roles (rname, rdetails) VALUES (\"Junior\", \"Experienced Employee\")";
        
        NSLog(@"Statement: %@", insertSQL);
        
        [self prepareStatement:insertSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Role added");
            //return YES;
        }
        else
        {
            NSLog(@"Failed to add role");
            //return NO;
        }
        
        insertSQL = @"INSERT INTO roles (rname, rdetails) VALUES (\"Project Leader\", \"Manager\")";
        
        NSLog(@"Statement: %@", insertSQL);
        
        [self prepareStatement:insertSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Role added");
            //return YES;
        }
        else
        {
            NSLog(@"Failed to add role");
            //return NO;
        }
        
        insertSQL = @"INSERT INTO roles (rname, rdetails) VALUES (\"HR\", \"Human Resources Employee\")";
        
        NSLog(@"Statement: %@", insertSQL);
        
        [self prepareStatement:insertSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Role added");
            //return YES;
        }
        else
        {
            NSLog(@"Failed to add role");
            //return NO;
        }
        ///////////////////////////////////////////////////////////////////////////////////////////
        
        insertSQL = @"INSERT INTO movements (mdetail, ammount, mtype) VALUES (\"USB Stick 16GB\", 150, 2)";
        
        NSLog(@"Statement: %@", insertSQL);
        
        [self prepareStatement:insertSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Movement added");
            //return YES;
        }
        else
        {
            NSLog(@"Failed to add movement");
            //return NO;
        }
        
        insertSQL = @"INSERT INTO movements (mdetail, ammount, mtype) VALUES (\"Payment\", 4300, 1)";
        
        NSLog(@"Statement: %@", insertSQL);
        
        [self prepareStatement:insertSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Movement added");
            //return YES;
        }
        else
        {
            NSLog(@"Failed to add movement");
            //return NO;
        }
        
        insertSQL = @"INSERT INTO movements (mdetail, ammount, mtype) VALUES (\"Rent\", 1800, 2)";
        
        NSLog(@"Statement: %@", insertSQL);
        
        [self prepareStatement:insertSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Movement added");
            //return YES;
        }
        else
        {
            NSLog(@"Failed to add movement");
            //return NO;
        }
        
        insertSQL = @"INSERT INTO movements (mdetail, ammount, mtype) VALUES (\"Iphone Repair Refound\", 600, 1)";
        
        NSLog(@"Statement: %@", insertSQL);
        
        [self prepareStatement:insertSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Movement added");
            //return YES;
        }
        else
        {
            NSLog(@"Failed to add movement");
            //return NO;
        }
        
        insertSQL = @"INSERT INTO movements (mdetail, ammount, mtype) VALUES (\"Certification Course\", 3500, 3)";
        
        NSLog(@"Statement: %@", insertSQL);
        
        [self prepareStatement:insertSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Movement added");
            //return YES;
        }
        else
        {
            NSLog(@"Failed to add movement");
            //return NO;
        }
        
        insertSQL = @"INSERT INTO movements (mdetail, ammount, mtype) VALUES (\"Transportation\", 800, 3)";
        
        NSLog(@"Statement: %@", insertSQL);
        
        [self prepareStatement:insertSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Movement added");
            //return YES;
        }
        else
        {
            NSLog(@"Failed to add movement");
            //return NO;
        }
        
        insertSQL = @"INSERT INTO movements (mdetail, ammount, mtype) VALUES (\"Loan To Friend\", 1200, 4)";
        
        NSLog(@"Statement: %@", insertSQL);
        
        [self prepareStatement:insertSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Movement added");
            //return YES;
        }
        else
        {
            NSLog(@"Failed to add movement");
            //return NO;
        }
        
        insertSQL = @"INSERT INTO movements (mdetail, ammount, mtype) VALUES (\"Test Refound\", 600, 4)";
        
        NSLog(@"Statement: %@", insertSQL);
        
        [self prepareStatement:insertSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Movement added");
            //return YES;
        }
        else
        {
            NSLog(@"Failed to add movement");
            //return NO;
        }
        ///////////////////////////////////////////////////////////////////////////////////////////
        
        insertSQL = @"INSERT INTO mtype (mname) VALUES (\"Earnings\")";
        
        NSLog(@"Statement: %@", insertSQL);
        
        [self prepareStatement:insertSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Movement type added");
            //return YES;
        }
        else
        {
            NSLog(@"Failed to add movement type");
            //return NO;
        }
        
        insertSQL = @"INSERT INTO mtype (mname) VALUES (\"Expenses\")";
        
        NSLog(@"Statement: %@", insertSQL);
        
        [self prepareStatement:insertSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Movement type added");
            //return YES;
        }
        else
        {
            NSLog(@"Failed to add movement type");
            //return NO;
        }
        
        insertSQL = @"INSERT INTO mtype (mname) VALUES (\"Debts\")";
        
        NSLog(@"Statement: %@", insertSQL);
        
        [self prepareStatement:insertSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Movement type added");
            //return YES;
        }
        else
        {
            NSLog(@"Failed to add movement type");
            //return NO;
        }
        
        insertSQL = @"INSERT INTO mtype (mname) VALUES (\"Loans\")";
        
        NSLog(@"Statement: %@", insertSQL);
        
        [self prepareStatement:insertSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Movement type added");
            //return YES;
        }
        else
        {
            NSLog(@"Failed to add movement type");
            //return NO;
        }
        ///////////////////////////////////////////////////////////////////////////////////////////
        
        insertSQL = @"INSERT INTO places (address) VALUES (\"Sonora 1497, Colima, Colima\")";
        
        NSLog(@"Statement: %@", insertSQL);
        
        [self prepareStatement:insertSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Place added");
            //return YES;
        }
        else
        {
            NSLog(@"Failed to add place");
            //return NO;
        }
        
        insertSQL = @"INSERT INTO places (address) VALUES (\"Avenida Tecnologico 1000, Colima, Colima\")";
        
        NSLog(@"Statement: %@", insertSQL);
        
        [self prepareStatement:insertSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Place added");
            //return YES;
        }
        else
        {
            NSLog(@"Failed to add place");
            //return NO;
        }
        
        insertSQL = @"INSERT INTO places (address) VALUES (\"Cerro Del Tesoro 924, Tlaquepaque, Jalisco\")";
        
        NSLog(@"Statement: %@", insertSQL);
        
        [self prepareStatement:insertSQL];
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Place added");
            return YES;
        }
        else
        {
            NSLog(@"Failed to add place");
            return NO;
        }
        
        [self closeDB];
    }
    else
        return YES;
}

@end
