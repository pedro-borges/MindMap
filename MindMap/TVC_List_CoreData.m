//
//  TVC_CoreData.m
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_List_CoreData.h"

#import "TVC_View.h"

#import "DatabaseManager.h"

#define SEGUE_VIEW @"View"

@implementation TVC_List_CoreData

#pragma mark - Properties

@synthesize model = _model;
@synthesize entityName = _entityName;
@synthesize context = _context;
@synthesize predicate = _predicate;
@synthesize sectionNameKeyPath = _sectionNameKeyPath;
@synthesize sortDescriptors = _sortDescriptors;

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
        
        [self.fetchedResultsController.managedObjectContext deleteObject:managedObject];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([SEGUE_VIEW isEqualToString:segue.identifier]) {
		TVC_View *controller = segue.destinationViewController;
		
		NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
		
		controller.managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
	}
}

@end
