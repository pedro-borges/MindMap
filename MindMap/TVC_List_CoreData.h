//
//  TVC_CoreData.h
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataTableViewController.h"

#define ALERT_CONFIRM 10

@interface TVC_List_CoreData : CoreDataTableViewController <UIAlertViewDelegate>

@property (nonatomic, readonly) NSManagedObject *selectedManagedObject;
@property (nonatomic, strong) NSString *entityName;

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSPredicate *predicate;
@property (nonatomic, strong) NSString *sectionNameKeyPath;
@property (nonatomic, strong) NSArray *sortDescriptors;

- (void)deleteManagedObject:(NSManagedObject *)managedObject;
- (NSString *)confirmDeletionMessage:(NSManagedObject *)managedObject;

- (void)bindToView;

@end
