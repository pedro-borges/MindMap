//
//  Task+Business.h
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "Task+Implementation.h"

@interface Task (Business)

- (NSSet *)fullDependencies;
- (NSArray *)possibleDependenciesInSameProject;
- (NSSet *)fullDependants;
- (NSArray *)possibleDependantsIsSameProject;

@property (nonatomic, readonly) NSDate *enforcedStartDate;
@property (nonatomic, readonly) NSDate *enforcedEndDate;

@property (nonatomic, readonly) BOOL inPresent;

@property (nonatomic, readonly) NSString *dependenciesDescription;
@property (nonatomic, readonly) NSString *dependantsDescription;

- (void)close;

- (void)delete;

@end
