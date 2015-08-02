#import "TVC_ListTasksPresent.h"

#import "LocalizableStrings.h"

#import "Task+Business.h"
#import "Completion+Business.h"

#import "Settings.h"

@interface TVC_ListTasksPresent() <UIAlertViewDelegate>

@end

@implementation TVC_ListTasksPresent

#pragma mark - Properties

Task *_selectedTask;

#pragma mark - UIKit

- (void)viewDidLoad {
	[super viewDidLoad];
}

#pragma mark - Bindings

- (void)bindToView {
	self.predicate = self.project.presentTasksPredicate;
	
	[super bindToView];
	
	NSInteger count = [self tableView:self.tableView numberOfRowsInSection:0];
	
	self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%li", (long)count];
	
	[UIApplication sharedApplication].applicationIconBadgeNumber = count;
}

#pragma mark - Private

- (void)closeSelectedTask {
	Task *task = (Task *)[self selectedManagedObject];

	[task close];
	
	[self bindToView];
}

- (void)createDependencyToSelectedTask:(NSString *)title {
	Task *task = _selectedTask;

	Task *dependency = [Task createFromContext:self.context forProject:self.project withTitle:title];

	[task addDependenciesObject:dependency];
	
	[self bindToView];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[super alertView:alertView clickedButtonAtIndex:buttonIndex];

	UIAlertView *alertView2;

	switch (alertView.tag) {
		case ALERT_CREATETASK: {
			if (buttonIndex == 1) {
				[Task createFromContext:self.context forProject:self.project withTitle:[alertView textFieldAtIndex:0].text];
			}
			break;
		}

		case ALERT_TASK: {
			switch (buttonIndex) {
				case 0: // Cancel
					[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
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
					[alertView2 textFieldAtIndex:0].autocorrectionType = UITextAutocorrectionTypeYes;
					alertView2.tag = ALERT_CREATEDEPENDENCY;
					
					[alertView2 show];
					
					break;
				case 3: // Popup Create Dependant for Selected Task
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

		case ALERT_CREATEDEPENDENCY: {
			switch (buttonIndex) {
				case 0: // Create Dependency Cancel
					[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
					break;
				case 1: // Creare Dependency OK
					[self createDependencyToSelectedTask:[alertView textFieldAtIndex:0].text];
					break;
			}
			break;
		}
		case ALERT_CREATEDEPENDANT: {
			switch (buttonIndex) {
				case 0: // Create Dependant Cancel
					[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
					break;
				case 1: // Creare Dependant OK
					[self createDependantToSelectedTask:[alertView textFieldAtIndex:0].text];

					alertView2 = [[UIAlertView alloc] initWithTitle:STRING_CREATEDEPENDANT
															message:STRING_WILLSHOWINFUTURE
														   delegate:self
												  cancelButtonTitle:STRING_OK
												  otherButtonTitles:nil];
					
					alertView2.alertViewStyle = UIAlertViewStyleDefault;
					alertView2.tag = ALERT_NOTIFICATION;
					
					[alertView2 show];
					
					break;
			}

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
									  otherButtonTitles:STRING_CLOSETASK, STRING_CREATEDEPENDENCY, STRING_CREATEDEPENDANT, nil];
	
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
	alertView.tag = ALERT_CREATETASK;

	[alertView show];
}

#pragma mark - Abstract Implementations

- (NSString *)cellDetailTextFor:(Task *)task {
	return task.dependantsDescription;
}

@end
