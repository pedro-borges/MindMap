#import <Foundation/Foundation.h>

#import "Project+Business.h"

#import "TVC_List_CoreData.h"

#import "LocalizableStrings.h"

#define DEFAULT_PROJECT_NAME NSLocalizedString(@"My Idea", nil)

#define SETTING_SELECTEDPROJECTNAME @"pt.pcb.mindmap.selectedProjectName"

@interface Settings : NSObject

+ (Settings *)defaultSettings;

- (void)synchronize;

@property (nonatomic, readonly) NSString *selectedProjectName;
@property (nonatomic) Project *selectedProject;

@end
