//
//  TVC_Edit.h
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVC_View.h"

#define KEY_MESSAGE @"Message"

#define DOMAIN_BINDTOMODEL @"pt.pcb.mindmap.BindToModel"

@interface TVC_Edit : TVC_View <UITextFieldDelegate>

- (BOOL)bindToModel:(NSError **)error;

- (IBAction)saveAction:(UIBarButtonItem *)sender;

@end
