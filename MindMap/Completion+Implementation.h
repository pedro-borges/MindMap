//
//  Completion+Implementation.h
//  MindMap
//
//  Created by Pedro Borges on 04/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "Completion.h"

#import "Task+Implementation.h"

@interface Completion (Implementation)

+ (Completion *)createFromContext:(NSManagedObjectContext *)context
						  forTask:(Task *)task;

@end
