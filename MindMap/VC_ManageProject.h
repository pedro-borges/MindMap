//
//  VC_ManageProject.h
//  MindMap
//
//  Created by Pedro Borges on 06/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project+Business.h"

@interface VC_ManageProject : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) Project *project;
@property (nonatomic, strong) UIPageViewController *pageViewController;

@end
