//
//  DissolveSegue.m
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "Segue_Push_NoAnimation.h"

@implementation Segue_Push_NoAnimation

- (void)perform {
    UIViewController *sourceViewController = self.sourceViewController;
    UIViewController *destinationViewController = self.destinationViewController;
    
    [sourceViewController.navigationController pushViewController:destinationViewController animated:NO];
}

@end
