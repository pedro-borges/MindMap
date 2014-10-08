//
//  TVC_ListTasksPresent.m
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_ListTasksPresent.h"

#import "Task+Business.h"
#import "Completion+Business.h"

#define STRING_NEWTASK			NSLocalizedString(@"New Task", nil)
#define STRING_CLOSETASK		NSLocalizedString(@"Close Task", nil)
#define STRING_DEPENDENCY_OF	NSLocalizedString(@"Dependency of %@", nil)
#define STRING_BACK				NSLocalizedString(@"Back", nil)
#define STRING_CREATEDEPENDENCY NSLocalizedString(@"Create Dependency", nil)

@interface TVC_ListTasksPresent() <UIAlertViewDelegate>

@property (nonatomic, strong) UIAlertView *alertView;

@end

@implementation TVC_ListTasksPresent

#pragma mark - Properties

@synthesize alertView = _alertView;

#pragma mark - UIKit

- (void)viewDidLoad {
    [super viewDidLoad];

    self.predicate = [NSPredicate predicateWithFormat:@"(project = %@) AND (completion == nil) AND (SUBQUERY(dependencies, $t, $t.completion == nil).@count == 0)", self.project];
}

#pragma mark - Private

- (void)closeSelectedTask {
	Task *task = [self selectedTask];
	
	task.completion = [Completion createFromContext:self.context
											forTask:task
										  timestamp:[NSDate date]];
}

- (void)addNewDependencyToSelectedTask {
	Task *task = [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
	
	Task *dependency = [Task createFromContext:self.context forProject:self.project withTitle:[NSString stringWithFormat:STRING_DEPENDENCY_OF, task.title]];
	
	[task addDependenciesObject:dependency];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0: // Back
			break;
		case 1: // Close Selected Task
			[self closeSelectedTask];
			break;
		case 2: // Add Dependency to Selected Task
			[self addNewDependencyToSelectedTask];
			break;
	}

	[self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
			
//	[(RootTabBarController *)self.tabBarController refreshPresentTab];
//	[(RootTabBarController *)self.tabBarController refreshFutureTab];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Task *task = [self selectedTask];

	self.alertView = [[UIAlertView alloc] initWithTitle:task.title
												message:nil
											   delegate:self
									  cancelButtonTitle:STRING_BACK
									  otherButtonTitles:STRING_CLOSETASK, STRING_CREATEDEPENDENCY, nil];
	
	self.alertView.alertViewStyle = UIAlertViewStyleDefault;
	
	[self.alertView show];
}

#pragma mark - Navigation

- (IBAction)addAction:(UIBarButtonItem *)sender {
	[Task createFromContext:self.context forProject:self.project withTitle:STRING_NEWTASK];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[super prepareForSegue:segue sender:sender];
}

@end
