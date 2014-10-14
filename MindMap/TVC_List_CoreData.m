//
//  TVC_CoreData.m
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_List_CoreData.h"

#import "TVC_View.h"
#import "TVC_Edit.h"

#import "LocalizableStrings.h"

#import "DatabaseManager.h"

#import <objc/runtime.h>

#define SEGUE_VIEW @"View"
#define SEGUE_EDIT @"Edit"

#define KEY_MANAGEDOBJECT &_key_managedObject

@implementation TVC_List_CoreData

#pragma mark - Properties

@synthesize entityName = _entityName;
@synthesize context = _context;
@synthesize predicate = _predicate;
@synthesize sectionNameKeyPath = _sectionNameKeyPath;
@synthesize sortDescriptors = _sortDescriptors;

const char _key_managedObject = 'm';

- (NSManagedObjectContext *)context {
	if (_context == nil) {
		_context = [DatabaseManager defaultManagerForController:self].document.managedObjectContext;
	}
	return _context;
}

- (NSManagedObject *)selectedManagedObject {
	return [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
}

#pragma mark - UIKit

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	[self bindToView];
}

#pragma mark - Bindings

- (void)bindToView {
	[self setupFetchedResultsController];
}

#pragma mark - Private methods

- (void)setupFetchedResultsController {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    
    request.sortDescriptors = self.sortDescriptors;
    request.predicate = self.predicate;
	
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:self.sectionNameKeyPath
                                                                                   cacheName:nil];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
		NSString *message = [self confirmDeletionMessage:managedObject];

		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please confirm" message:message delegate:self cancelButtonTitle:STRING_CANCEL otherButtonTitles:STRING_OK, nil];
	
		alertView.alertViewStyle = UIAlertViewStyleDefault;
		alertView.tag = ALERT_CONFIRM;
		
		objc_setAssociatedObject(alertView, KEY_MANAGEDOBJECT, managedObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

		[alertView show];
	}

	[self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender {
	if ([SEGUE_VIEW isEqualToString:segue.identifier]) {
		TVC_View *controller = segue.destinationViewController;

		NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
		
		controller.managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
	}

	if ([SEGUE_EDIT isEqualToString:segue.identifier]) {
		TVC_Edit *controller = segue.destinationViewController;
		
		NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
		
		controller.managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
	}
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == ALERT_CONFIRM) {
		if (buttonIndex == 1) {
			NSManagedObject *managedObject = objc_getAssociatedObject(alertView, KEY_MANAGEDOBJECT);

			[self deleteManagedObject:managedObject];
		}
	}
}

#pragma mark - Abstract

- (void)deleteManagedObject:(NSManagedObject *)managedObject {
	@throw [NSException exceptionWithName:@"Abstraction Violation" reason:@"Direct call to [TVC_List_CoreData deleteManagedObject:]" userInfo:nil];
}

- (NSString *)confirmDeletionMessage:(NSManagedObject *)managedObject {
	@throw [NSException exceptionWithName:@"Abstraction Violation" reason:@"Direct call to [TVC_List_CoreData confirmDeletionMessage:]" userInfo:nil];
}

@end
