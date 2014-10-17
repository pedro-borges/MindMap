//
//  TVC_ListTasksFuture.m
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_ListTasksFuture.h"

#import "LocalizableStrings.h"

#import "TVC_ViewTask.h"

@interface TVC_ListTasksFuture() <UIAlertViewDelegate>

@end

@implementation TVC_ListTasksFuture

Task *_selectedTask;

#pragma mark - UIKit

- (void)viewWillAppear:(BOOL)animated {
    self.predicate = self.project.futureTasksPredicate;

	[super viewWillAppear:animated];
}

#pragma mark - Private

- (void)createDependencyToSelectedTask:(NSString *)title {
	Task *task = _selectedTask;
	
	Task *dependency = [Task createFromContext:self.context forProject:self.project withTitle:title];
	
	[task addDependenciesObject:dependency];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[super alertView:alertView clickedButtonAtIndex:buttonIndex];

	UIAlertView *alertView2;

	switch (alertView.tag) {
		case ALERT_TASK: {
			switch (buttonIndex) {
				case 0: // Cancel
					[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
					break;
				case 1: // Popup Create Dependency for Selected Task
					alertView2 = [[UIAlertView alloc] initWithTitle:STRING_CREATEDEPENDENCY
															message:nil
														   delegate:self
												  cancelButtonTitle:STRING_CANCEL
												  otherButtonTitles:STRING_CREATE, nil];
					
					alertView2.alertViewStyle = UIAlertViewStylePlainTextInput;
					[alertView2 textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeSentences;
					alertView2.tag = ALERT_CREATEDEPENDENCY;
					
					[alertView2 show];
					
					break;
				case 2: // Popup Create Dependant for Selected Task
					alertView2 = [[UIAlertView alloc] initWithTitle:STRING_CREATEDEPENDANT
															message:nil
														   delegate:self
												  cancelButtonTitle:STRING_CANCEL
												  otherButtonTitles:STRING_CREATE, nil];
					
					alertView2.alertViewStyle = UIAlertViewStylePlainTextInput;
					[alertView2 textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeSentences;
					alertView2.tag = ALERT_CREATEDEPENDANT;
					
					[alertView2 show];
					
					break;
			}
			break;
		}

		case ALERT_CREATEDEPENDENCY:
			switch (buttonIndex) {
				case 0: // Cancel
					[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
					break;
				case 1: // Popup Notification
					[self createDependencyToSelectedTask:[alertView textFieldAtIndex:0].text];
					
					alertView2 = [[UIAlertView alloc] initWithTitle:STRING_CREATEDEPENDENCY
																message:STRING_WILLSHOWINPRESENT
															   delegate:self
													  cancelButtonTitle:STRING_OK
													  otherButtonTitles:nil];
					
					alertView2.alertViewStyle = UIAlertViewStyleDefault;
					alertView2.tag = ALERT_NOTIFICATION;
					
					[alertView2 show];
					
					break;
			}
			break;
		case ALERT_CREATEDEPENDANT:
			switch (buttonIndex) {
				case 0: // Cancel create dependency
					[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
					break;
				case 1:
					[self createDependantToSelectedTask:[alertView textFieldAtIndex:0].text];
					break;
			}
		case ALERT_NOTIFICATION:
			[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
			break;
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
											  otherButtonTitles:STRING_CREATEDEPENDENCY, STRING_CREATEDEPENDANT, nil];
	
	alertView.alertViewStyle = UIAlertViewStyleDefault;
	alertView.tag = ALERT_TASK;
	
	[alertView show];
}

#pragma mark - Implementations

- (NSString *)cellTextFor:(Task *)task {
	return task.title;
}

- (NSString *)cellDetailTextFor:(Task *)task {
	return [NSString stringWithFormat:STRING_DEPENDENCIESANDDEPENDANTS, task.dependantsDescription, task.dependenciesDescription];
}

@end
