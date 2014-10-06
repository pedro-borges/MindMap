//
//  TVC_ViewProject.m
//  MindMap
//
//  Created by Pedro Borges on 05/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_ViewProject.h"

@interface TVC_ViewProject()

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *progressLabel;

@end

@implementation TVC_ViewProject

#pragma mark - Properties

- (Project *)model {
    return (Project *)self.managedObject;
}

#pragma mark - UIKit

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self bindToView];
}

#pragma mark - Overrides

- (void)setModel:(Project *)model {
    if (self.managedObject != model) {
        self.managedObject = model;
    }
}

- (void)bindToView {
}

@end
