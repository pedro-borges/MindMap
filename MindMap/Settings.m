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
	
	NSManagedObjectContext *context = [DatabaseManager defaultManager].document.managedObjectContext;

	if (projectName == nil) {
		projectName = STRING_DEFAULT_PROJECTNAME;
		
		[Project createFromContext:context withName:projectName];
	}
	
	return [[Project forName:projectName inContext:context] firstObject];
}

@end
