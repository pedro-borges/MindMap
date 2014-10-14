//
//  LinkedTextField.h
//  PsychoNote
//
//  Created by Pedro Borges on 13/09/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkedTextField : UITextField

@property (nonatomic, weak) IBOutlet UIResponder *nextResponder;

@end