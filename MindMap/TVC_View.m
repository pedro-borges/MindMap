//
//  TVC.m
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_View.h"

#import "TVC_Edit.h"

#define SEGUE_EDIT @"Edit"

@implementation TVC_View

#pragma mark - Properties

@synthesize managedObject;

#pragma mark - UIKit

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self bindToView];
}

#pragma mark - Bindings

- (void)bindToView {
    @throw [NSException exceptionWithName:@"Abstraction violation"
                                   reason:@"bindToView not implemented in superclass"
                                 userInfo:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([SEGUE_EDIT isEqualToString:segue.identifier]) {
		TVC_Edit *controller = segue.destinationViewController;

		controller.managedObject = self.managedObject;
	}
}

@end
