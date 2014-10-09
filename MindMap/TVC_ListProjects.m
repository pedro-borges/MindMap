//
//  TVC_ListProjects.m
//  MindMap
//
//  Created by Pedro Borges on 05/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_ListProjects.h"

#import "TBC_ManageProject.h"

#import "Project+Business.h"
#import "Settings.h"

#import "DatabaseManager.h"

#define CELL_PROJECT @"pt.pcb.mindmap.project"

#define STRING_EMPTY            NSLocalizedString(@"Empty", nil)
#define STRING_PENDINGTASK      NSLocalizedString(@"1 Pending", nil)
#define STRING_PENDINGTASKS     NSLocalizedString(@"%lu Pending", nil)
#define STRING_COMPLETED        NSLocalizedString(@"Completed", nil)
#define STRING_NEWPROJECTNAME   NSLocalizedString(@"New Project Name", nil)
#define STRING_CANCEL           NSLocalizedString(@"Cancel", nil)
#define STRING_CREATE           NSLocalizedString(@"Create", nil)

@interface TVC_ListProjects ()<UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIAlertView *alertView;

@end

@implementation TVC_ListProjects

#pragma mark - Properties

#pragma mark - UIKit

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.entityName = @"Project";
    self.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *name = [self.alertView textFieldAtIndex:0].text;
    
	if (buttonIndex == 1) {
		Project *project = [Project createFromContext:self.context withName:name];

		[Settings defaultSettings].selectedProject = project;

		[self bindToView];
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Project *project = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_PROJECT forIndexPath:indexPath];
    
    NSInteger taskCount = [project.tasks count];
    NSInteger pendingCount = [project.pendingTasks count];
    NSInteger doneCount = (taskCount - pendingCount);
	NSInteger percent = 100 * (doneCount / taskCount);

    UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *detailTextLabel = (UILabel *)[cell.contentView viewWithTag:102];
	
    textLabel.text = project.name;
    
    if (taskCount == 0) {
        detailTextLabel.text = STRING_EMPTY;
    } else {
        if (pendingCount > 0) {
			detailTextLabel.text = [NSString stringWithFormat:@"%lu%%", percent];
		} else {
            detailTextLabel.text = STRING_COMPLETED;
        }
    }
	
    return cell;
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Project *project = [self.fetchedResultsController objectAtIndexPath:indexPath];

	[Settings defaultSettings].selectedProject = project;

	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

- (IBAction)newProject:(UIBarButtonItem *)sender {
    self.alertView = [[UIAlertView alloc] initWithTitle:STRING_NEWPROJECTNAME
                                           message:nil
                                          delegate:self
                                 cancelButtonTitle:STRING_CANCEL
                                 otherButtonTitles:STRING_CREATE, nil];

    self.alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [self.alertView textFieldAtIndex:0].delegate = self;
    
    [self.alertView show];
}

@end
