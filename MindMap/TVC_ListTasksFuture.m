//
//  TVC_ListTasksFuture.m
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_ListTasksFuture.h"

#import "TVC_ViewTask.h"

#define STRING_DEPENDENCY_OF		NSLocalizedString(@"Dependency of %@", nil)
#define STRING_CANCEL				NSLocalizedString(@"Cancel", nil)
#define STRING_OK					NSLocalizedString(@"Ok", nil)
#define STRING_WILLSHOWINPRESENT	NSLocalizedString(@"The new dependency will appear in the <present> tab", nil)
#define STRING_CREATEDEPENDENCY		NSLocalizedString(@"Create Dependency", nil)

@interface TVC_ListTasksFuture() <UIAlertViewDelegate>

@property (nonatomic, strong) UIAlertView *alertView;

@end

@implementation TVC_ListTasksFuture

#pragma mark - UIKit

- (void)viewDidLoad {
    [super viewDidLoad];

    self.predicate = [NSPredicate predicateWithFormat:@"(project = %@) AND (SUBQUERY(dependencies, $t, $t.completion == nil).@count > 0)", self.project];
}

#pragma mark - Private

- (void)addNewDependencyToSelectedTask {
	Task *task = [self selectedTask];
	
	Task *dependency = [Task createFromContext:self.context withTitle:[NSString stringWithFormat:STRING_DEPENDENCY_OF, task.title]];
	
	[task addDependenciesObject:dependency];
	
	[self dismissViewControllerAnimated:NO completion:^(void){ }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0: // Back
			break;
		case 1: // Close Selected Task
			[self addNewDependencyToSelectedTask];
			break;
	}
	
	[self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
	
	//	[(RootTabBarController *)self.tabBarController refreshPresentTab];
	//	[(RootTabBarController *)self.tabBarController refreshFutureTab];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	self.alertView = [[UIAlertView alloc] initWithTitle:STRING_CREATEDEPENDENCY
												message:STRING_WILLSHOWINPRESENT
											   delegate:self
									  cancelButtonTitle:STRING_CANCEL
									  otherButtonTitles:STRING_OK, nil];
	
	self.alertView.alertViewStyle = UIAlertViewStyleDefault;
	
	[self.alertView show];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[super prepareForSegue:segue sender:sender];
}

@end
