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

@property (nonatomic, readonly) NSArray *pendingTasks;

@end
