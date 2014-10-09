//
//  TBC_ManageProject.m
//  MindMap
//
//  Created by Pedro Borges on 06/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TBC_ManageProject.h"

#import "TVC_ListTasks.h"

#import "Settings.h"

@implementation TBC_ManageProject

#pragma mark - Properties

#pragma mark - UIKit
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    for (UINavigationController *navigationController in self.viewControllers) {
//        TVC_ListTasks *controller = (TVC_ListTasks *)navigationController.topViewController;
//
//		Project *project = Project forName:[Settings defaultSettings].defaultProjectName;
//		
//        controller.model = self.project;
//        controller.navigationItem.title = self.project.name;
//    }
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.selectedIndex = 1;
}

@end
