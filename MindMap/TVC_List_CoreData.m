//
//  TVC_CoreData.m
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_List_CoreData.h"

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
		if (self.model != nil) {
			_context = self.model.managedObjectContext;
			NSLog(@"ManagedObjectContext = nil. Autoheal: using context from model.");
		} else {
			NSLog(@"ManagedObjectContext = nil. Autoheal: unable to autoheal.");
		}
	}
	return _context;
}

- (NSManagedObject *)selectedManagedObject {
	return [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
}

#pragma mark - UIKit

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

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

@end
