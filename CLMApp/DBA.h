//
//  DBA.h
//  NFLStats
//
//  Created by Yessica Alejandra Cardenas Aviña on 22/02/14.
//  Copyright (c) 2014 Francisco Javier Hernandez Mendoza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBA : NSObject

@property (nonatomic, strong) NSString * databasePath;
@property (nonatomic) sqlite3 * playersDB;

-(void) prepareDBPath;
-(void) checkForDB;

@end
