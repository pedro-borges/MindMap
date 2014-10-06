//
//  TVC_ListProjects.m
//  MindMap
//
//  Created by Pedro Borges on 05/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_ListProjects.h"

#import "VC_ManageProject.h"

#define CELL_PROJECT @"pt.pcb.mindmap.project"

#define STRING_PENDINGTASK      NSLocalizedString(@"1 Pending Task", nil)
#define STRING_PENDINGTASKS     NSLocalizedString(@"%lu Pending Tasks", nil)
#define STRING_COMPLETED        NSLocalizedString(@"Completed", nil)
#define STRING_NEWPROJECTNAME   NSLocalizedString(@"New Project Name", nil)
#define STRING_CANCEL           NSLocalizedString(@"Cancel", nil)
#define STRING_CREATE           NSLocalizedString(@"Create", nil)

@interface TVC_ListProjects ()<UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIAlertView *alertView;

@end

@implementation TVC_ListProjects

#pragma mark - Properties

- (Project *)selectedProject {
    return (Project *)self.selectedManagedObject;
}

#pragma mark - UIKit

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.entityName = @"Project";
    self.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
}

#pragma mark - Private

- (void)createProjectWithName:(NSString *)name {
    [Project createFromContext:self.context withName:name];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *name = [self.alertView textFieldAtIndex:0].text;
    
    switch (buttonIndex) {
        case 0: // Cancel
            break;
        case 1: // Create
            [self createProjectWithName:name];
            break;
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Project *project = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_PROJECT forIndexPath:indexPath];
    
    unsigned long taskCount = [project.tasks count];
    unsigned long pendingCount = [project.pendingTasks count];
    float progress = (taskCount - pendingCount) / taskCount;
    NSLog(@"progress = %f", progress);

    UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *detailTextLabel = (UILabel *)[cell.contentView viewWithTag:102];
    UIProgressView *progressView = (UIProgressView *)[cell.contentView viewWithTag:103];
    
    textLabel.text = project.name;
    progressView.progress = progress;

    if (taskCount > 0) {
        if (taskCount == 1) {
            detailTextLabel.text = STRING_PENDINGTASK;
        } else {
            detailTextLabel.text = [NSString stringWithFormat:STRING_PENDINGTASKS, (unsigned long)taskCount];
        }
    } else {
        detailTextLabel.text = STRING_COMPLETED;
    }

    return cell;
}

#pragma mark - TableViewDelegate

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([@"Manage Project" isEqualToString:segue.identifier]) {
        VC_ManageProject *controller = segue.destinationViewController;

        Project *selectedProject = self.selectedProject;

        controller.project = selectedProject;
    }
}

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
