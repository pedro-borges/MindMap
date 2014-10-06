//
//  TVC_Edit.m
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_Edit.h"

#import "LinkedTextField.h"

@interface TVC_Edit() <UITextFieldDelegate>

@end

@implementation TVC_Edit

@synthesize firstResponder = _firstResponder;

- (void)bindToModel {
	NSError *error;

	[self.managedObject.managedObjectContext save:&error];

	if (error) {
		NSLog(@"Error saving context - %@", error);
	}
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if ([textField isKindOfClass:[LinkedTextField class]]) {
		UIResponder *next = ((LinkedTextField *)textField).nextWidget;
	
		if (next) {
			[next becomeFirstResponder];
		} else {
			[textField resignFirstResponder];
		}
	} else {
		[textField resignFirstResponder];
	}
	
	return NO;
}

@end
