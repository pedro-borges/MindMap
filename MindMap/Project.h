//
//  Project.h
//  MindMap
//
//  Created by Pedro Borges on 06/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *tasks;
@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addTasksObject:(Task *)value;
- (void)removeTasksObject:(Task *)value;
- (void)addTasks:(NSSet *)values;
- (void)removeTasks:(NSSet *)values;

@end
