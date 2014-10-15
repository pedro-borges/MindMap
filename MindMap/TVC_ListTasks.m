//
//  TVC_ListTasks.m
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_ListTasks.h"

#import "LocalizedStrings.h"

#import "TVC_ViewTask.h"

#import "TimeFrame+Business.h" // legacy
#import "Project+Business.h"
#import "Settings.h"

#import <CoreData/CoreData.h>

#define CELL_TASK @"pt.pcb.mindmap.task"

@interface TVC_ListTasks()

@property (nonatomic, readonly) Task *selectedTask;

@end

@implementation TVC_ListTasks

#pragma mark - Properties

- (Task *)selectedTask {
	return (Task *)self.selectedManagedObject;
}

- (Project *)project {
	Project *result = [Settings defaultSettings].selectedProject;
	
	return result;
}

#pragma mark - UIKit

- (void)viewDidLoad {
	// Autoheal tasks with no project
	for (Task *defunct in [Task allInContext:self.context
						   matchingPredicate:[NSPredicate predicateWithFormat:@"project = nil"]]) {
		NSLog(@"##### Autoheal: deleted defunct task '%@'", defunct.title);
		[defunct delete];
	}
	
	// Autoheal tasks with no timestamp, no timeFrame and no title
	for (Task *task in [Task allInContext:self.context matchingPredicate:nil]) {
		if (task.timestamp == nil) {
			NSLog(@"##### Autoheal: add missing timestamp to task '%@'", task.title);
			task.timestamp = [NSDate date];
		}
		if (task.title == nil) {
			NSLog(@"##### Autoheal: add missing title to task '%@'", task.title);
			task.title = @"Autoheal";
		}
		if (task.timeFrame == nil) {
			NSLog(@"##### Autoheal: add missing timeFrame to task '%@'", task.title);
			task.timeFrame = [TimeFrame createFromContext:task.managedObjectContext startDate:nil endDate:nil];
		}
	}
	
	// Autoheal projects with no timestamp and no name
	for (Project *project in [Project allInContext:self.context matchingPredicate:nil]) {
		if (project.timestamp == nil) {
			NSLog(@"##### Autoheal: add missing timestamp to project '%@'", project.name);
			project.timestamp = [NSDate date];
		}
		if (project.name == nil) {
			NSLog(@"##### Autoheal: add missing name to project '%@'", project.name);
			project.name = @"Autoheal";
		}
	}
	
	[super viewDidLoad];

	self.entityName = @"Task";
    self.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	self.navigationItem.title = [Settings defaultSettings].selectedProjectName;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_TASK forIndexPath:indexPath];

    cell.textLabel.text = [self cellTextFor:task];
	cell.detailTextLabel.text = [self cellDetailTextFor:task];

	return cell;
}

#pragma mark - TableViewDelegate

#pragma mark - Abstract

- (NSString *)cellTextFor:(Task *)task {
	@throw [NSException exceptionWithName:@"Abstraction Violation" reason:@"Direct call to [TVC_ListTasks cellTextFor:]" userInfo:nil];
}

- (NSString *)cellDetailTextFor:(Task *)task {
	@throw [NSException exceptionWithName:@"Abstraction Violation" reason:@"Direct call to [TVC_ListTasks cellDetailTextFor:]" userInfo:nil];
}

#pragma mark - Abastract Implementation

- (void)deleteManagedObject:(NSManagedObject *)managedObject {
	Task *task = (Task *)managedObject;

	[task delete];
}

- (NSString *)confirmDeletionMessage:(NSManagedObject *)managedObject {
	Task *task = (Task *)managedObject;

	return [NSString stringWithFormat:@"Are you sure you want to delete task '%@'", task.title];
}

@end
