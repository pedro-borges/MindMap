//
//  Completion+Implementation.m
//  MindMap
//
//  Created by Pedro Borges on 04/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "Completion+Implementation.h"

#import "Database.h"

@implementation Completion (Implementation)


+ (Completion *)createFromContext:(NSManagedObjectContext *)context
                          forTask:(Task *)task {
    Completion *result;
    
    result = [NSEntityDescription insertNewObjectForEntityForName:@"Completion" inManagedObjectContext:context];
    
    result.task = task;
	result.timestamp = [NSDate date];
    
    [Database saveManagedObjectByForce:result];
    
    return result;
}

@end
