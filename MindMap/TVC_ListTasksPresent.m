//
//  TVC_ListTasksPresent.m
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_ListTasksPresent.h"

#import "LocalizableStrings.h"

#import "Task+Business.h"
#import "Completion+Business.h"

#define ALERT_TASK 101
#define ALERT_CREATE_DEPENDENCY 102
#define ALERT_CREATE_TASK 103

@interface TVC_ListTasksPresent() <UIAlertViewDelegate>

@property (nonatomic, strong) UIAlertView *alertView;

@end

@implementation TVC_ListTasksPresent

#pragma mark - Properties

Task *_selectedTask;

@synthesize alertView = _alertView;

#pragma mark - UIKit

- (void)viewWillAppear:(BOOL)animated {
	self.predicate = [NSPredicate predicateWithFormat:@"(project = %@) AND (completion == nil) AND (SUBQUERY(dependencies, $t, $t.completion == nil).@count == 0)", self.project];

	[super viewWillAppear:animated];
}

#pragma mark - Private

- (void)closeSelectedTask {
	Task *task = (Task *)[self selectedManagedObject];
	
	task.completion = [Completion createFromContext:self.context
											forTask:task
										  timestamp:[NSDate date]];
}

- (void)createDependencyToSelectedTask:(NSString *)title {
	Task *task = _selectedTask;

	Task *dependency = [Task createFromContext:self.context forProject:self.project withTitle:title];

	[task addDependenciesObject:dependency];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString *title = [alertView textFieldAtIndex:0].text;

	switch (alertView.tag) {
		case ALERT_CREATE_TASK: {
			[Task createFromContext:self.context forProject:self.project withTitle:title];
			
			[self bindToView]; //TODO try and comment this out

			break;
		}
		
		case ALERT_TASK: {
			switch (buttonIndex) {
				case 0: // Cancel
					break;
				case 1: // Close Selected Task
					[self closeSelectedTask];
					break;
				case 2: // Popup Create Dependency for Selected Task
					self.alertView = [[UIAlertView alloc] initWithTitle:STRING_CREATEDEPENDENCY
																message:nil
															   delegate:self
													  cancelButtonTitle:STRING_CANCEL
													  otherButtonTitles:STRING_CREATE, nil];
					
					self.alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
					self.alertView.tag = ALERT_CREATE_DEPENDENCY;
					
					[self.alertView show];
					
					break;
			}
			break;
		}
		
		case ALERT_CREATE_DEPENDENCY: {
			switch (buttonIndex) {
				case 0: // Create Dependency Cancel
					break;
				case 1: // Creare Dependency OK
					[self createDependencyToSelectedTask:[alertView textFieldAtIndex:0].text];
					break;
			}
			break;
		}
	}
	
	[self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Task *task = (Task *)[self selectedManagedObject];

	_selectedTask = task;
	
	self.alertView = [[UIAlertView alloc] initWithTitle:task.title
												message:nil
											   delegate:self
									  cancelButtonTitle:STRING_CANCEL
									  otherButtonTitles:STRING_CLOSETASK, STRING_CREATEDEPENDENCY, nil];
	
	self.alertView.alertViewStyle = UIAlertViewStyleDefault;
	self.alertView.tag = ALERT_TASK;
	
	[self.alertView show];
}

#pragma mark - Navigation

- (IBAction)createAction:(UIBarButtonItem *)sender {
	self.alertView = [[UIAlertView alloc] initWithTitle:STRING_CREATETASK
												message:nil
											   delegate:self
									  cancelButtonTitle:STRING_CANCEL
									  otherButtonTitles:STRING_CREATE, nil];
	
	self.alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
	self.alertView.tag = ALERT_CREATE_TASK;

	[self.alertView show];
}

@end
