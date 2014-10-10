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

#define ALERT_CREATEDEPENDENCY 101
#define ALERT_NOTIFICATION 102

@interface TVC_ListTasksFuture() <UIAlertViewDelegate>

@property (nonatomic, strong) UIAlertView *alertView;

@end

@implementation TVC_ListTasksFuture

Task *_selectedTask;

#pragma mark - UIKit

- (void)viewWillAppear:(BOOL)animated {
    self.predicate = [NSPredicate predicateWithFormat:@"(project = %@) AND (SUBQUERY(dependencies, $t, $t.completion == nil).@count > 0)", self.project];

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
	switch (alertView.tag) {
		case ALERT_CREATEDEPENDENCY:
			switch (buttonIndex) {
				case 0: // Cancel
					break;
				case 1: // Popup Notification
					[self createDependencyToSelectedTask:[alertView textFieldAtIndex:0].text];
					
					self.alertView = [[UIAlertView alloc] initWithTitle:STRING_CREATEDEPENDENCY
																message:STRING_WILLSHOWINPRESENT
															   delegate:self
													  cancelButtonTitle:STRING_OK
													  otherButtonTitles:nil];
					
					self.alertView.alertViewStyle = UIAlertViewStyleDefault;
					self.alertView.tag = ALERT_NOTIFICATION;
					
					[self.alertView show];
					
					break;
			}
			break;
		case ALERT_NOTIFICATION:
			break;
	}
	
	
	[self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	_selectedTask = [self.fetchedResultsController objectAtIndexPath:indexPath];

	self.alertView = [[UIAlertView alloc] initWithTitle:STRING_CREATEDEPENDENCY
												message:[NSString stringWithFormat:STRING_NEWDEPENDENCYFORTASK, _selectedTask.title]
											   delegate:self
									  cancelButtonTitle:STRING_CANCEL
									  otherButtonTitles:STRING_CREATE, nil];
	
	self.alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
	[self.alertView textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeSentences;
	self.alertView.tag = ALERT_CREATEDEPENDENCY;
	
	[self.alertView show];
}

@end
