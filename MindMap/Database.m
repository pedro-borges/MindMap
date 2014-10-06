//
//  Database.m
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "Database.h"

@implementation Database

+ (void)saveManagedObject:(NSManagedObject *)managedObject {
	NSError *error;
	
	[managedObject.managedObjectContext save:&error];

	if (error) {
		NSLog(@"Error saving object - %@", error);
	}
}

@end