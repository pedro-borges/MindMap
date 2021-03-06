#import "TVC_ListTasks.h"

#import "LocalizableStrings.h"

#import "TVC_ViewTask.h"

#import "TimeFrame+Business.h" // legacy
#import "Project+Business.h"
#import "Settings.h"

#import <CoreData/CoreData.h>

#define CELL_TASK @"pt.pcb.mindmap.task"

@interface TVC_ListTasks()

@property (nonatomic, readonly) Task *selectedTask;

@end

@implementation TVC_ListTasks

Task *_selectedTask;

#pragma mark - Properties

- (Task *)selectedTask {
	return (Task *)self.selectedManagedObject;
}

- (Project *)project {
	Project *result = [Settings defaultSettings].selectedProject;
	
	return result;
}

#pragma mark - UIKit

- (void)viewDidLoad {
	[super viewDidLoad];

	self.entityName = @"Task";
    self.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self performFetch];
	
	self.navigationItem.title = [Settings defaultSettings].selectedProjectName;
}

#pragma mark - Private

- (void)createDependantToSelectedTask:(NSString *)title {
	Task *task = _selectedTask;

	Task *dependant = [Task createFromContext:self.context forProject:self.project withTitle:title];

	[task addDependantsObject:dependant];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_TASK forIndexPath:indexPath];

    cell.textLabel.text = [self cellTextFor:task];
	cell.detailTextLabel.text = [self cellDetailTextFor:task];

	return cell;
}

#pragma mark - TableViewDelegate

#pragma mark - Abstract

- (NSString *)cellTextFor:(Task *)task {
	return [NSString stringWithFormat:@"%@ %i", task.title, task.level];
}

- (NSString *)cellDetailTextFor:(Task *)task {
	@throw [NSException exceptionWithName:@"Abstraction Violation" reason:@"Direct call to [TVC_ListTasks cellDetailTextFor:]" userInfo:nil];
}

#pragma mark - Abastract Implementation

- (void)deleteManagedObject:(NSManagedObject *)managedObject {
	Task *task = (Task *)managedObject;

	[task delete];
}

- (NSString *)confirmDeletionMessage:(NSManagedObject *)managedObject {
	Task *task = (Task *)managedObject;

	return [NSString stringWithFormat:STRING_CONFIRMDELETETASK, task.title];
}

@end
