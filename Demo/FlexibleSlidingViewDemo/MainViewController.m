//
//  MainViewController.m
//  FlexibleSlidingViewControllerDemo
//
//  Created by Hartwig Wiesmann on 09.08.15.
//  Copyright (c) 2015 skywind. All rights reserved.
//

#import "MainViewController.h"
#import "ParameterTableViewController.h"

#import "FlexibleSlidingView/FSVDimension.h"
#import "FlexibleSlidingView/FSVRelativePositioning.h"

#pragma mark Class extensions
@interface MainViewController ()

/** @name Private methods
  * @{ */

 /// Action handler
	-(void) actionAction:(UIBarButtonItem*)sender;

 /// Notification handler
	-(void) notificationUserDefaultsChanged:(NSNotification*)notification;

/** @} */
@end

#pragma mark - Implementation
@implementation MainViewController

#pragma mark - Initialization, object allocation and deallocation
-(void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Methods inherited from UIViewController
-(void) viewDidLoad
{
	[super viewDidLoad];

	[[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionAction:)]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationUserDefaultsChanged:) name:NSUserDefaultsDidChangeNotification object:nil];
}

#pragma mark - UIPopoverPresentationControllerDelegate protocol
-(UIModalPresentationStyle) adaptivePresentationStyleForPresentationController:(UIPresentationController*)controller
{
	return UIModalPresentationNone;
}

#pragma mark - Private methods
-(void) actionAction:(UIBarButtonItem*)sender
{
	ParameterTableViewController* parameterTableViewController = [[ParameterTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	
	UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:parameterTableViewController];
	
	
	[parameterTableViewController setTitle:@"Parameters"];
	[navigationController setModalPresentationStyle:UIModalPresentationPopover];
	[self presentViewController:navigationController animated:YES completion:nil];
	
	UIPopoverPresentationController* popoverPresentationController = [navigationController popoverPresentationController];

	[popoverPresentationController setBarButtonItem:sender];
	[popoverPresentationController setDelegate:self];
	[popoverPresentationController setPassthroughViews:nil];
}

-(void) notificationUserDefaultsChanged:(NSNotification*)notification
{
	NSUserDefaults* const userDefaults = (NSUserDefaults*)[notification object];


	if ([userDefaults doubleForKey:kUserDefaultsKeyDarkening] != [self darkening])
		[self setDarkening:[userDefaults doubleForKey:kUserDefaultsKeyDarkening]];
	if ((FSVRelativePositioning)[userDefaults integerForKey:kUserDefaultsKeyRelativePosition] != [self slidingViewPositioning])
		[self setSlidingViewPositioning:(FSVRelativePositioning)[userDefaults integerForKey:kUserDefaultsKeyRelativePosition]];
	if (([userDefaults boolForKey:kUserDefaultsKeyAbsoluteMaxXDimension] != [[self maxXDimension] absoluteDimension]) ||
			([userDefaults doubleForKey:kUserDefaultsKeyMaxXDimension] != [[self maxXDimension] dimension]))
		[self setMaxXDimension:[FSVDimension dimensionWithDimension:[userDefaults doubleForKey:kUserDefaultsKeyMaxXDimension] absoluteDimension:[userDefaults boolForKey:kUserDefaultsKeyAbsoluteMaxXDimension]]];
	if (([userDefaults boolForKey:kUserDefaultsKeyAbsoluteMaxYDimension] != [[self maxYDimension] absoluteDimension]) ||
			([userDefaults doubleForKey:kUserDefaultsKeyMaxYDimension] != [[self maxYDimension] dimension]))
		[self setMaxYDimension:[FSVDimension dimensionWithDimension:[userDefaults doubleForKey:kUserDefaultsKeyMaxYDimension] absoluteDimension:[userDefaults boolForKey:kUserDefaultsKeyAbsoluteMaxYDimension]]];
	if (([userDefaults boolForKey:kUserDefaultsKeyAbsoluteMinXDimension] != [[self minXDimension] absoluteDimension]) ||
			([userDefaults doubleForKey:kUserDefaultsKeyMinXDimension] != [[self minXDimension] dimension]))
		[self setMinXDimension:[FSVDimension dimensionWithDimension:[userDefaults doubleForKey:kUserDefaultsKeyMinXDimension] absoluteDimension:[userDefaults boolForKey:kUserDefaultsKeyAbsoluteMinXDimension]]];
	if (([userDefaults boolForKey:kUserDefaultsKeyAbsoluteMinYDimension] != [[self minYDimension] absoluteDimension]) ||
			([userDefaults doubleForKey:kUserDefaultsKeyMinYDimension] != [[self minYDimension] dimension]))
		[self setMinYDimension:[FSVDimension dimensionWithDimension:[userDefaults doubleForKey:kUserDefaultsKeyMinYDimension] absoluteDimension:[userDefaults boolForKey:kUserDefaultsKeyAbsoluteMinYDimension]]];
	if ([userDefaults boolForKey:kUserDefaultsKeyResize] != [self slidingResizes])
		[self setSlidingResizes:[userDefaults boolForKey:kUserDefaultsKeyResize]];
	if ((FSVSlidingStyle)[userDefaults integerForKey:kUserDefaultsKeySlidingStyle] != [self slidingStyle])
		[self setSlidingStyle:(FSVSlidingStyle)[userDefaults integerForKey:kUserDefaultsKeySlidingStyle]];
	if ([userDefaults boolForKey:kUserDefaultsKeySnapToLimits] != [self snapToLimits])
		[self setSnapToLimits:[userDefaults boolForKey:kUserDefaultsKeySnapToLimits]];
	if ([userDefaults doubleForKey:kUserDefaultsKeySnapXBorder] != [self xSnapBorder])
		[self setXSnapBorder:[userDefaults doubleForKey:kUserDefaultsKeySnapXBorder]];
	if ([userDefaults doubleForKey:kUserDefaultsKeySnapYBorder] != [self ySnapBorder])
		[self setYSnapBorder:[userDefaults doubleForKey:kUserDefaultsKeySnapYBorder]];
	if ([userDefaults boolForKey:kUserDefaultsKeyTapMinimization] != [self allowTapMinimization])
		[self setAllowTapMinimization:[userDefaults boolForKey:kUserDefaultsKeyTapMinimization]];
}

@end
