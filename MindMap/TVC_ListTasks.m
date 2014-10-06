//
//  TVC_ListTasks.m
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_ListTasks.h"

#import "TVC_ViewTask.h"

#import <CoreData/CoreData.h>

#define CELL_TASK @"pt.pcb.mindmap.task"

#define STRING_DEPENDANT NSLocalizedString(@"1 dependant", nil)
#define STRING_DEPENDANTS NSLocalizedString(@"lu dependants", nil)
#define STRING_GOAL NSLocalizedString(@"Goal", nil)

@implementation TVC_ListTasks

#pragma mark - Properties

- (Task *)selectedTask {
	return (Task *)self.selectedManagedObject;
}

- (Project *)project {
	return (Project *)self.model;
}

#pragma mark - UIKit

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.entityName = @"Task";
    self.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];

	NSLog(@"Frame = %@", NSStringFromCGRect(self.view.frame));
	NSLog(@"blg = %@", self.bottomLayoutGuide);
	NSLog(@"tlg = %@", self.topLayoutGuide);
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_TASK forIndexPath:indexPath];

    cell.textLabel.text = task.title;
    
    unsigned long dependantsCount = [task.dependants count];
    
    if (dependantsCount > 0) {
		if (dependantsCount == 1) {
			cell.detailTextLabel.text = STRING_DEPENDANT;
        } else {
            cell.detailTextLabel.text = [NSString stringWithFormat:STRING_DEPENDANTS, (unsigned long)dependantsCount];
		}
	} else {
		cell.detailTextLabel.text = STRING_GOAL;
	}
		
	return cell;
}

#pragma mark - TableViewDelegate

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([@"View Task" isEqualToString:segue.identifier]) {
		TVC_ViewTask *controller = segue.destinationViewController;
		
		Task *selectedTask = self.selectedTask;
		
		controller.model = selectedTask;
	}
}

- (IBAction)closeAction:(UIBarButtonItem *)sender {
	[self dismissViewControllerAnimated:YES completion:^(void) {
		
	}];
}

@end
