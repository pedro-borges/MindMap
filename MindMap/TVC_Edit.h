//
//  TVC_Edit.h
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVC_View.h"

@interface TVC_Edit : TVC_View

@property (nonatomic, strong) UIResponder *firstResponder;

- (void)bindToModel;

@end
