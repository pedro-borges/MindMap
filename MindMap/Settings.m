//
//  Settings.m
//  MindMap
//
//  Created by Pedro Borges on 08/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "Settings.h"

#import "DatabaseManager.h"

@interface Settings()

@property (nonatomic, readonly) NSUserDefaults *standardUserDefaults;

@end

@implementation Settings

static Settings *_defaultSettings;

@synthesize standardUserDefaults = _standardUserDefaults;

- (NSString *)selectedProjectName {
	NSString *projectName = [self.standardUserDefaults objectForKey:SETTING_SELECTEDPROJECTNAME];

	return projectName;
}

+ (Settings *)defaultSettings {
	if (_defaultSettings == nil) _defaultSettings = [[Settings alloc] init];

	return _defaultSettings;
}

- (void)synchronize {
	[self.standardUserDefaults synchronize];
}

#pragma mark - Private

- (NSUserDefaults *)standardUserDefaults {
	if (_standardUserDefaults == nil) _standardUserDefaults = [NSUserDefaults standardUserDefaults];
	
	return _standardUserDefaults;
}

#pragma mark - Settings

- (void)setSelectedProject:(Project *)project {
	[self.standardUserDefaults setObject:project.name forKey:SETTING_SELECTEDPROJECTNAME];
}

- (Project *)selectedProject {
	NSString *projectName = self.selectedProjectName;

	if (projectName == nil) return nil;
	
	NSManagedObjectContext *context = [DatabaseManager defaultManager].document.managedObjectContext;
	
	return [[Project forName:projectName inContext:context] firstObject];
}

@end
