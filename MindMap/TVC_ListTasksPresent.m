//
//  TVC_ListTasksPresent.m
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_ListTasksPresent.h"

#import "LocalizedStrings.h"

#import "Task+Business.h"
#import "Completion+Business.h"

@interface TVC_ListTasksPresent() <UIAlertViewDelegate>

@end

@implementation TVC_ListTasksPresent

#pragma mark - Properties

Task *_selectedTask;

#pragma mark - UIKit

#pragma mark - Private

- (void)closeSelectedTask {
	Task *task = (Task *)[self selectedManagedObject];
	
	[task close];
}

- (void)createDependencyToSelectedTask:(NSString *)title {
	Task *task = _selectedTask;

	Task *dependency = [Task createFromContext:self.context forProject:self.project withTitle:title];

	[task addDependenciesObject:dependency];
}

#pragma mark - Bindings

- (void)bindToView {
	self.predicate = self.project.presentTasksPredicate;
	[super bindToView];
	
	NSInteger count = [self tableView:self.tableView numberOfRowsInSection:0];
	
	self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%li", count];
	[UIApplication sharedApplication].applicationIconBadgeNumber = count;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[super alertView:alertView clickedButtonAtIndex:buttonIndex];

	NSString *title = [alertView textFieldAtIndex:0].text;

	UIAlertView *alertView2;

	switch (alertView.tag) {
		case ALERT_CREATE_TASK: {
			if (buttonIndex == 1) {
				[Task createFromContext:self.context forProject:self.project withTitle:title];
			}
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
					alertView2 = [[UIAlertView alloc] initWithTitle:STRING_CREATEDEPENDENCY
																message:nil
															   delegate:self
													  cancelButtonTitle:STRING_CANCEL
													  otherButtonTitles:STRING_CREATE, nil];
					
					alertView2.alertViewStyle = UIAlertViewStylePlainTextInput;
					[alertView2 textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeSentences;
					alertView2.tag = ALERT_CREATE_DEPENDENCY;
					
					[alertView2 show];
					
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
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Task *task = (Task *)[self selectedManagedObject];

	_selectedTask = task;
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:task.title
												message:nil
											   delegate:self
									  cancelButtonTitle:STRING_CANCEL
									  otherButtonTitles:STRING_CLOSETASK, STRING_CREATEDEPENDENCY, nil];
	
	alertView.alertViewStyle = UIAlertViewStyleDefault;
	alertView.tag = ALERT_TASK;

	[alertView show];
}

#pragma mark - Navigation

- (IBAction)createAction:(UIBarButtonItem *)sender {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:STRING_CREATETASK
												message:nil
											   delegate:self
									  cancelButtonTitle:STRING_CANCEL
									  otherButtonTitles:STRING_CREATE, nil];
	
	alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
	[alertView textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeSentences;
	alertView.tag = ALERT_CREATE_TASK;

	[alertView show];
}

#pragma mark - Abstract Implementations

- (NSString *)cellTextFor:(Task *)task {
	return task.title;
}

- (NSString *)cellDetailTextFor:(Task *)task {
	return task.dependantsDescription;
}

@end
