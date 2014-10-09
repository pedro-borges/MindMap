//
//  Project+Implementation.h
//  MindMap
//
//  Created by Pedro Borges on 05/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "Project.h"

@interface Project (Implementation)

+ (Project *)createFromContext:(NSManagedObjectContext *)context
                      withName:(NSString *)name;
+ (NSArray *)allInContext:(NSManagedObjectContext *)context
		matchingPredicate:(NSPredicate *)predicate;
+ (NSArray *)forName:(NSString *)name
		   inContext:(NSManagedObjectContext *)context;
- (NSArray *)pendingTasks;

@end
