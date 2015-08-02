#import "TVC_Edit.h"

#import "LocalizableStrings.h"

@interface TVC_Edit()

@end

@implementation TVC_Edit

#pragma mark - UIKit

- (BOOL)bindToModel:(NSError **)error {
	return [self.managedObject.managedObjectContext save:error];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	
	return NO;
}

#pragma mark - Navigation

- (IBAction)saveAction:(UIBarButtonItem *)sender {
	NSError *error;

	if ([self bindToModel:&error]) {
		[self.navigationController popToRootViewControllerAnimated:YES];
	} else {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:STRING_ERROR
															message:error.localizedDescription
														   delegate:nil
												  cancelButtonTitle:STRING_OK
												  otherButtonTitles:nil];
		
		[alertView show];
	}
}

@end
