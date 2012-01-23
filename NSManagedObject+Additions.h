//
//  NSManagedObject+Additions.h
//
//  Created by Wess Cope on 9/23/11.
//  Copyright 2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObject(Additions)

#pragma mark - Class methods
+ (void)setContext:(NSManagedObjectContext *)context;
+ (NSManagedObjectContext *)context;
+ (NSString *)name;
+ (NSEntityDescription *)description;
+ (id)new;
+ (id)new:(NSDictionary *)details;
+ (NSNumber *)count;
+ (NSNumber *)countwithPredicate:(NSPredicate *)predicate;
+ (NSArray *)all;
+ (id)filterWithPredicate:(NSPredicate *)predicate;
+ (id)filterWithSortDescriptors:(NSArray *)sortDescriptors;
+ (id)filterWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors;
+ (id)getWithPredicate:(NSPredicate *)predicate;
+ (void)deleteAll;

#pragma mark - Instance methods
- (BOOL)save;

@end
