//
//  Task.h
//  MindMap
//
//  Created by Pedro Borges on 15/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Completion, Place, Project, Task, TimeFrame;

@interface Task : NSManagedObject

@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Completion *completion;
@property (nonatomic, retain) NSSet *dependants;
@property (nonatomic, retain) NSSet *dependencies;
@property (nonatomic, retain) NSSet *place;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) TimeFrame *timeFrame;
@end

@interface Task (CoreDataGeneratedAccessors)

- (void)addDependantsObject:(Task *)value;
- (void)removeDependantsObject:(Task *)value;
- (void)addDependants:(NSSet *)values;
- (void)removeDependants:(NSSet *)values;

- (void)addDependenciesObject:(Task *)value;
- (void)removeDependenciesObject:(Task *)value;
- (void)addDependencies:(NSSet *)values;
- (void)removeDependencies:(NSSet *)values;

- (void)addPlaceObject:(Place *)value;
- (void)removePlaceObject:(Place *)value;
- (void)addPlace:(NSSet *)values;
- (void)removePlace:(NSSet *)values;

@end
