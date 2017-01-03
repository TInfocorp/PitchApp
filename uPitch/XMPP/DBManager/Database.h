//
//  Database.h
//  Memory
//
//  Created by user on 16.11.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "constant.h"
#import <sqlite3.h>

@interface Database : NSObject 
{
	NSString *dbPath;
}

@property(nonatomic,strong) NSString *dbPath;

+(NSString *) getDBPath:(NSString*)sqliteFilename;
-(void)copyDatabaseIfNeeded:(NSString *)sqliteFilename;
+(Database *)sharedObject;

+(NSString*)getObject:(NSObject *)object;

-(int)insertToTable:(NSString *)tableName withValues:(NSDictionary *)dictionary;
-(NSMutableArray *)executeSelectQuery:(NSString *)query;
-(BOOL)deleteFromTable:(NSString *)tableName condition:(NSString *)condition;
//-(BOOL)deleteFromTable:(NSString *)tableName;
-(NSString*)getObject:(NSObject *)object;
-(BOOL)updateTable:(NSString *)tableName values:(NSMutableDictionary *)dictionary forColumnCondition:(NSString *)column;
-(BOOL)dataWithUniqueIdFound:(NSString *)primaryKey inTable:(NSString *)tableName withPrimaryFieldName:(NSString *)fieldName;

+(BOOL)updateTable:(NSString *)tableName values:(NSMutableDictionary *)dictionary forColumnCondition:(NSString *)column;
-(BOOL)initializeWithSqlite:(NSString *)sqliteFilename;
-(NSString*)getColumnString:(char *)text;
-(BOOL)PerformStatement:(sqlite3_stmt *)statement withQuery:(NSString*)Query;
//-(NSMutableArray *)getAllSuccessfulChatConversation:(NSString *)str;
//-(NSMutableArray *)getAllUniqueChatIds:(NSString *)str;
-(BOOL)deleteData:(NSString *)strDeleteQuery;
-(BOOL)updateData:(NSString *)strUpdateQuery;
-(BOOL)Update:(NSString *)query;
@end
