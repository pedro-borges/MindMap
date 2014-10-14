//
//  TVC_ListTasks.h
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_List_CoreData.h"
#import "Task+Business.h"
#import "Project+Business.h"

@interface TVC_ListTasks : TVC_List_CoreData

@property (nonatomic, readonly) Project *project;

- (NSString *)cellTextFor:(Task *)task;
- (NSString *)cellDetailTextFor:(Task *)task;

@end
