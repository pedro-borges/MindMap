//
//  Completion.h
//  MindMap
//
//  Created by Pedro Borges on 04/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;

@interface Completion : NSManagedObject

@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) Task *task;

@end
