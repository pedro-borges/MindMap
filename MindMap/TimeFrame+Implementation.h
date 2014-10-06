//
//  TimeFrame+Implementation.h
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TimeFrame.h"

@interface TimeFrame (Implementation)

+ (TimeFrame *)createFromContext:(NSManagedObjectContext *)context
                       startDate:(NSDate *)startDate
                         endDate:(NSDate *)endDate;
@end
