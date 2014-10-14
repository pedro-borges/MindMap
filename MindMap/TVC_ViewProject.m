//
//  TVC_ViewProject.m
//  MindMap
//
//  Created by Pedro Borges on 05/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_ViewProject.h"

#import "LocalizableStrings.h"

#import "Task+Business.h"

@interface TVC_ViewProject()

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *progressLabel;
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;
@property (nonatomic, weak) IBOutlet UILabel *pastTaskStatistic;
@property (nonatomic, weak) IBOutlet UILabel *presentTaskStatistic;
@property (nonatomic, weak) IBOutlet UILabel *futureTaskStatistic;
@property (nonatomic, weak) IBOutlet UILabel *totalTaskStatistic;
@property (nonatomic, weak) IBOutlet UILabel *pastPercentStatistic;
@property (nonatomic, weak) IBOutlet UILabel *presentPercentStatistic;
@property (nonatomic, weak) IBOutlet UILabel *futurePercentStatistic;
@property (nonatomic, weak) IBOutlet UILabel *totalPercentStatistic;

@end

@implementation TVC_ViewProject

#pragma mark - Properties

- (Project *)project {
    return (Project *)self.managedObject;
}

#pragma mark - Overrides

- (void)setModel:(Project *)model {
    if (self.managedObject != model) {
        self.managedObject = model;
    }
}

- (void)bindToView {
	NSInteger pastCount		= [[Task allInContext:self.project.managedObjectContext matchingPredicate:self.project.pastTasksPredicate] count];
	NSInteger presentCount	= [[Task allInContext:self.project.managedObjectContext matchingPredicate:self.project.presentTasksPredicate] count];
	NSInteger futureCount	= [[Task allInContext:self.project.managedObjectContext matchingPredicate:self.project.futureTasksPredicate] count];
	NSInteger totalCount	= [self.project.tasks count];

	NSInteger pastPercent		= totalCount > 0 ? 100 * pastCount / totalCount : 0;
	NSInteger presentPercent	= totalCount > 0 ? 100 * presentCount / totalCount : 0;
	NSInteger futurePercent		= totalCount > 0 ? 100 * futureCount / totalCount : 0;

	NSInteger progressPercent = 100 * pastCount / totalCount;

	NSString *name = self.project.name;
	NSString *progress = [NSString stringWithFormat:@"%li%%", progressPercent];

	NSString *pastTaskStatistic			= [NSString stringWithFormat:STRING_TASKSCOUNT, pastCount];
	NSString *presentTaskStatistic		= [NSString stringWithFormat:STRING_TASKSCOUNT, presentCount];
	NSString *futureTaskStatistic		= [NSString stringWithFormat:STRING_TASKSCOUNT, futureCount];
	NSString *totalTaskStatistic		= [NSString stringWithFormat:STRING_TASKSCOUNT, totalCount];

	NSString *pastPercentStatistic		= [NSString stringWithFormat:@"%li%%", pastPercent];
	NSString *presentPercentStatistic	= [NSString stringWithFormat:@"%li%%", presentPercent];
	NSString *futurePercentStatistic	= [NSString stringWithFormat:@"%li%%", futurePercent];
	NSString *totalPercentStatistic		= [NSString stringWithFormat:@"%li%%", (NSInteger)100];

	self.nameLabel.text = name;
	self.progressLabel.text = progress;
	self.progressView.progress = totalCount > 0 ? (float)1 * pastCount / totalCount : 0;

	self.pastTaskStatistic.text			= pastTaskStatistic;
	self.presentTaskStatistic.text		= presentTaskStatistic;
	self.futureTaskStatistic.text		= futureTaskStatistic;
	self.totalTaskStatistic.text		= totalTaskStatistic;
	self.pastPercentStatistic.text		= pastPercentStatistic;
	self.presentPercentStatistic.text	= presentPercentStatistic;
	self.futurePercentStatistic.text	= futurePercentStatistic;
	self.totalPercentStatistic.text		= totalPercentStatistic;
}

@end
