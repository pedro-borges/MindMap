//
//  TVC_Edit.m
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_Edit.h"

#import "LinkedTextField.h"

@interface TVC_Edit()

@end

@implementation TVC_Edit

@synthesize firstResponder = _firstResponder;

#pragma mark - UIKit

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if (self.firstResponder) {
		[self.firstResponder becomeFirstResponder];
		
		self.firstResponder = nil;
	}

	[self bindToView];
}

- (BOOL)bindToModel:(NSError **)error {
	@throw [NSException exceptionWithName:@"Abstraction violation"
								   reason:@"Direct call to [TVC_Edit bindToModel]"
								 userInfo:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];

	if ([textField isKindOfClass:[LinkedTextField class]]) {
		UIResponder *next = ((LinkedTextField *)textField).nextResponder;

		if (next) {
			[next becomeFirstResponder];
		}
	}
	
	return NO;
}

#pragma mark - Navigation

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)saveAction:(UIBarButtonItem *)sender {
	NSError *error;

	if ([self bindToModel:&error]) {
		[self.navigationController popToRootViewControllerAnimated:YES];
	} else {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
															message:error.localizedDescription
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
		
		[alertView show];
	}
}

@end
