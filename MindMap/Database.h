//
//  Database.h
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Database : NSObject

+ (void)saveManagedObject:(NSManagedObject *)managedObject;

@end
