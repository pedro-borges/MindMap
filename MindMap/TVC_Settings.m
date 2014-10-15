//
//  TVC_Settings.m
//  MindMap
//
//  Created by Pedro Borges on 08/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_Settings.h"

#import "LocalizedStrings.h"

#import "Settings.h"

@interface TVC_Settings()

@property (nonatomic, weak) IBOutlet UILabel *selectedProjectLabel;

@end

@implementation TVC_Settings

#pragma mark - UIKit

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	[self bindToView];
}

#pragma mark - Bindings

- (void)bindToView {
	NSString *selectedProjectName = [Settings defaultSettings].selectedProjectName;

	if (selectedProjectName) {
		self.selectedProjectLabel.text = selectedProjectName;
		self.selectedProjectLabel.alpha = 1.0;
	} else {
		self.selectedProjectLabel.text = STRING_NOPROJECTSELECTED;
		self.selectedProjectLabel.alpha = 0.5;
	}
}

#pragma mark - Navigation

- (IBAction)closeAction:(UIBarButtonItem *)sender {
	[self dismissViewControllerAnimated:YES completion:^void {
		// NOP Completion
	}];
}

@end
