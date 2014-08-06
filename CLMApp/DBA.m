//
//  DBA.m
//  NFLStats
//
//  Created by Yessica Alejandra Cardenas Aviña on 22/02/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import "DBA.h"

@implementation DBA

@synthesize databasePath, playersDB;

-(void) prepareDBPath
{
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent: @"players.db"]];
    NSLog(@"%@", databasePath);
}

-(void) checkForDB
{
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &playersDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS PLAYERS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, AGE INTEGER, TEAM TEXT, HEIGHT TEXT, WEIGHT TEXT, BIRTHDATE TEXT, COLLEGE TEXT, TDS INTEGER, INTS INTEGER, YDS INT, NUMBER INTEGER, POSITION TEXT)";
            if (sqlite3_exec(playersDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table");
            }
            
            sqlite3_close(playersDB);
        }
        else
        {
            NSLog(@"Failed to open/create database");
        }
    }
    else
    {
        NSLog(@"Database open!");
    }
}

@end
