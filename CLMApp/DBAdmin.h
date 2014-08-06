//
//  DBAdmin.h
//  NFLStats
//
//  Created by Yessica Alejandra Cardenas Aviña on 22/02/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface DBAdmin : UIView

@property (nonatomic, strong) NSString * databasePath;
@property (nonatomic) sqlite3 * directoryDB;
@property (nonatomic) sqlite3_stmt * statement;

//NAME , TEAM , TDS , INTS , YDS , NUMBER , POSITION 
-(void) prepareDBPath;
-(BOOL) checkForDB;
-(BOOL) openDB;
-(BOOL) closeDB;
-(BOOL) initializeDBData;
-(BOOL) prepareStatement:(NSString*) stmt;
-(BOOL) insertNewContact:(NSString*) fname :(NSString*) lname :(NSString*) email :(NSString*) anumber :(NSString*) pnumber :(NSString*) address :(NSInteger) account :(NSInteger) role;
-(BOOL) updateContact:(int) contactID :(int) account :(int) role;
//-(BOOL) updateContact:(NSString*) iD :(NSString*) name :(NSString*) team :(NSString*) touchDowns :(NSString*) interceptions :(NSString*) yards :(NSString*) number :(NSString*) position;
-(BOOL) deleteContactByID:(NSString*) iD;
-(NSArray*) getContacts;
-(NSArray*) getContactByID:(NSString*) iD;
-(NSArray*) getAccountByName:(NSString*) team;
-(NSArray*) getAccounts;
-(NSArray*) getAccountsList;
-(NSArray*) getRoles;
-(NSInteger) getAddressID:(NSString*) address;
-(BOOL) insertNewPlace:(NSString*) address;
-(int) checkAddress:(NSString*) address;
-(BOOL) insertNewMovement:(NSString*) detail :(NSString*) amount :(NSString*) type;
-(BOOL) deleteMovementByID:(NSString*) iD;
-(NSArray*) getMovements:(NSString*) mType;
-(NSArray*) getMovementsAmmounts;

@end
