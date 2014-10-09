//
//  Settings.h
//  MindMap
//
//  Created by Pedro Borges on 08/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Project+Business.h"

#import "TVC_List_CoreData.h"

#define DEFAULT_PROJECT_NAME NSLocalizedString(@"My Idea", nil)

#define SETTING_SELECTEDPROJECTNAME @"pt.pcb.mindmap.selectedProjectName"

@interface Settings : NSObject

+ (Settings *)defaultSettings;

- (void)synchronize;

@property (nonatomic, readonly) NSString *selectedProjectName;
@property (nonatomic) Project *selectedProject;

@end
