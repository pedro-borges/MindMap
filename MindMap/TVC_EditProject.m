//
//  TVC_EditProject.m
//  MindMap
//
//  Created by Pedro Borges on 09/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_EditProject.h"

#import "Task+Business.h"

#import "LocalizableStrings.h"

#define STRING_ERROR_DUPLICATEPROJECTNAME @"There's already a project by that name"

@interface TVC_EditProject()

@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UILabel *progressLabel;
@property (nonatomic, weak) IBOutlet UIProgressView *completionProgressView;
@property (nonatomic, weak) IBOutlet UIProgressView *pastProgressView;
@property (nonatomic, weak) IBOutlet UIProgressView *presentProgressView;
@property (nonatomic, weak) IBOutlet UIProgressView *futureProgressView;
@property (nonatomic, weak) IBOutlet UIProgressView *totalPastProgressView;
@property (nonatomic, weak) IBOutlet UIProgressView *totalPresentProgressView;
@property (nonatomic, weak) IBOutlet UIProgressView *totalFutureProgressView;
@property (nonatomic, weak) IBOutlet UILabel *pastTaskStatistic;
@property (nonatomic, weak) IBOutlet UILabel *presentTaskStatistic;
@property (nonatomic, weak) IBOutlet UILabel *futureTaskStatistic;
@property (nonatomic, weak) IBOutlet UILabel *totalTaskStatistic;
@property (nonatomic, weak) IBOutlet UILabel *pastPercentStatistic;
@property (nonatomic, weak) IBOutlet UILabel *presentPercentStatistic;
@property (nonatomic, weak) IBOutlet UILabel *futurePercentStatistic;
@property (nonatomic, weak) IBOutlet UILabel *totalPercentStatistic;

@end

@implementation TVC_EditProject

#pragma mark - Properties

- (Project *)project {
	return (Project *)self.managedObject;
}

- (void)setProject:(Project *)project {
	if (self.managedObject != project) {
		self.managedObject = project;
	}
}

#pragma mark - UIKit

#pragma mark - Bindings

- (void)bindToView {
	NSInteger pastCount		= [[Task allInContext:self.project.managedObjectContext matchingPredicate:self.project.pastTasksPredicate] count];
	NSInteger presentCount	= [[Task allInContext:self.project.managedObjectContext matchingPredicate:self.project.presentTasksPredicate] count];
	NSInteger futureCount	= [[Task allInContext:self.project.managedObjectContext matchingPredicate:self.project.futureTasksPredicate] count];
	NSInteger totalCount	= [self.project.tasks count];

	float pastPercent		= totalCount > 0 ? (float)1 * pastCount / totalCount : 0;
	float presentPercent	= totalCount > 0 ? (float)1 * presentCount / totalCount : 0;
	float futurePercent		= totalCount > 0 ? (float)1 * futureCount / totalCount : 0;
	
	NSInteger progressPercent = 100 * pastCount / totalCount;

	NSString *name = self.project.name;
	NSString *progress = [NSString stringWithFormat:@"%li%%", (long)progressPercent];

	NSString *pastTaskStatistic		= [NSString stringWithFormat:STRING_TASKSCOUNT, pastCount];
	NSString *presentTaskStatistic	= [NSString stringWithFormat:STRING_TASKSCOUNT, presentCount];
	NSString *futureTaskStatistic	= [NSString stringWithFormat:STRING_TASKSCOUNT, futureCount];
	NSString *totalTaskStatistic	= [NSString stringWithFormat:STRING_TASKSCOUNT, totalCount];
	
	NSString *pastPercentStatistic		= [NSString stringWithFormat:@"%li%%", (long)(100 * pastPercent)];
	NSString *presentPercentStatistic	= [NSString stringWithFormat:@"%li%%", (long)(100 * presentPercent)];
	NSString *futurePercentStatistic	= [NSString stringWithFormat:@"%li%%", (long)(100 * futurePercent)];
	NSString *totalPercentStatistic		= [NSString stringWithFormat:@"%li%%", (long)(100)];

	self.nameTextField.text = name;
	
	self.progressLabel.text = progress;
	self.completionProgressView.progress = totalCount > 0 ? (float)1 * pastCount / totalCount : 0;
	
	self.pastProgressView.progress = pastPercent;
	self.presentProgressView.progress = presentPercent;
	self.futureProgressView.progress = futurePercent;

	self.totalPastProgressView.progress = pastPercent;
	self.totalPresentProgressView.progress = pastPercent + presentPercent;
	self.totalFutureProgressView.progress = 1;

	self.pastTaskStatistic.text		= pastTaskStatistic;
	self.presentTaskStatistic.text	= presentTaskStatistic;
	self.futureTaskStatistic.text	= futureTaskStatistic;
	self.totalTaskStatistic.text	= totalTaskStatistic;
	self.pastPercentStatistic.text		= pastPercentStatistic;
	self.presentPercentStatistic.text	= presentPercentStatistic;
	self.futurePercentStatistic.text	= futurePercentStatistic;
	self.totalPercentStatistic.text		= totalPercentStatistic;
}

- (BOOL)bindToModel:(NSError **)error {
	NSString *name = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if (![name isEqualToString:self.project.name]) {
		Project *validation = [[Project forName:name inContext:self.project.managedObjectContext] firstObject];
		
		if (validation) {
			NSDictionary *dictionary = [NSDictionary dictionaryWithObject:STRING_ERROR_DUPLICATEPROJECTNAME
																   forKey:KEY_MESSAGE];

			*error = [[NSError alloc] initWithDomain:DOMAIN_BINDTOMODEL code:1 userInfo:dictionary];
			
			return NO;
		}
		
		// Valid name
		self.project.name = name;
	}

	return [super bindToModel:error];
}

@end
