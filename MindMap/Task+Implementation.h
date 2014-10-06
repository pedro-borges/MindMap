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
                  withTitle:(NSString *)title;
+ (NSSet *)allInContext:(NSManagedObjectContext *)context
		 matchingPredicate:(NSPredicate *)predicate;

- (NSInteger)dependantsCount;
- (NSInteger)dependenciesCount;

@end
