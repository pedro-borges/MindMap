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
- (NSArray *)possibleDependencies;
- (NSSet *)fullDependants;
- (NSArray *)possibleDependants;

@end
