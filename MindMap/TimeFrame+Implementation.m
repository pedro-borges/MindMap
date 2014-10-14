//
//  TimeFrame+Implementation.m
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TimeFrame+Implementation.h"
#import "Database.h"

@implementation TimeFrame (Implementation)

+ (TimeFrame *)createFromContext:(NSManagedObjectContext *)context
                       startDate:(NSDate *)startDate
                         endDate:(NSDate *)endDate {
    TimeFrame *result;

    result = [NSEntityDescription insertNewObjectForEntityForName:@"TimeFrame" inManagedObjectContext:context];

	result.startDate = startDate ? startDate : [NSDate distantPast];
	result.endDate = endDate ? endDate : [NSDate distantFuture];

    [Database saveManagedObjectByForce:result];

    return result;
}

@end
