//
//  VC_ManageProject.m
//  MindMap
//
//  Created by Pedro Borges on 06/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "VC_ManageProject.h"

#import "TVC_ListTasks.h"
#import "TVC_ListTasksPresent.h"

#define STRING_PAST     NSLocalizedString(@"Past", nil)
#define STRING_PRESENT  NSLocalizedString(@"Present", nil)
#define STRING_FUTURE   NSLocalizedString(@"Future", nil)

@interface VC_ManageProject()

@end

@implementation VC_ManageProject

#pragma mark - Properties

@synthesize project = _project;

#pragma mark - UIKit

- (void)viewDidLoad {
    [super viewDidLoad];

    // Create page view controller
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    self.pageViewController.doubleSided = NO;

    [self.pageViewController setViewControllers:[NSArray arrayWithObject:[self viewControllerAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
// Change the size of page view controller
//    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    self.pageViewController.view.opaque = NO;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = ((TVC_ListTasks *)viewController).pageIndex;

    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }

    index--;

    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = ((TVC_ListTasks *)viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    
    if (index == 3) {
        return nil;
    }

    return [self viewControllerAtIndex:index];
}

- (TVC_ListTasks *)viewControllerAtIndex:(NSUInteger)index {
    TVC_ListTasks *result;
    
    switch (index) {
        case 0:
            result = [self.storyboard instantiateViewControllerWithIdentifier:@"TVC_ListTasksPast"];
            break;
        case 1:
            result = [self.storyboard instantiateViewControllerWithIdentifier:@"TVC_ListTasksPresent"];
            break;
        case 2:
            result = [self.storyboard instantiateViewControllerWithIdentifier:@"TVC_ListTasksFuture"];
            break;
        default:
            return nil;
    }

    result.model = self.project;
    result.pageIndex = index;

    return result;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 3;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    NSLog(@"pendingViewControllers.count = %lu", (unsigned long)[pendingViewControllers count]);
    TVC_ListTasks *controller = [pendingViewControllers lastObject];
    
    self.navigationItem.title = controller.navigationItem.title;

    if (controller.navigationItem.rightBarButtonItem) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:(TVC_ListTasksPresent *)controller action:@selector(addAction:)];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

@end
