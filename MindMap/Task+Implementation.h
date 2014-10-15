//
//  Task+Implementation.h
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "Task.h"

@interface Task (Implementation)

+ (Task *)createFromContext:(NSManagedObjectContext *)context
				 forProject:(Project *)project
                  withTitle:(NSString *)title;
+ (NSArray *)allInContext:(NSManagedObjectContext *)context
		 matchingPredicate:(NSPredicate *)predicate;
+ (NSInteger)countInContext:(NSManagedObjectContext *)context
		  matchingPredicate:(NSPredicate *)predicate;

- (NSInteger)dependantsCount;
- (NSArray *)activeDependencies;
- (NSInteger)activeDependenciesCount;

@end
