//
//  AppDelegate.m
//  FlexibleSlidingViewControllerDemo
//
//  Created by Hartwig Wiesmann on 07.08.15.
//  Copyright (c) 2015 skywind. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "ParameterTableViewController.h"
#import "SimpleViewController.h"

#import "FlexibleSlidingView/FSVDimension.h"
#import "FlexibleSlidingView/FSVRelativePositioning.h"
#import "FlexibleSlidingView/FSVContainerViewController.h"

#pragma mark Class extensions
@interface AppDelegate ()

@end

#pragma mark - Implementation
@implementation AppDelegate
@synthesize window=_window;

#pragma mark - UIApplicationDelegate protocol
-(BOOL) application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
	MainViewController* mainViewController = [MainViewController new];
	

	[mainViewController setAllowTapMinimization:[[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsKeyTapMinimization]];
	[mainViewController setDarkening:[[NSUserDefaults standardUserDefaults] doubleForKey:kUserDefaultsKeyDarkening]];
	[mainViewController setMaxXDimension:[FSVDimension dimensionWithDimension:[[NSUserDefaults standardUserDefaults] doubleForKey:kUserDefaultsKeyMaxXDimension] absoluteDimension:[[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsKeyAbsoluteMaxXDimension]]];
	[mainViewController setMaxYDimension:[FSVDimension dimensionWithDimension:[[NSUserDefaults standardUserDefaults] doubleForKey:kUserDefaultsKeyMaxYDimension] absoluteDimension:[[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsKeyAbsoluteMaxYDimension]]];
	[mainViewController setMinXDimension:[FSVDimension dimensionWithDimension:[[NSUserDefaults standardUserDefaults] doubleForKey:kUserDefaultsKeyMinXDimension] absoluteDimension:[[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsKeyAbsoluteMinXDimension]]];
	[mainViewController setMinYDimension:[FSVDimension dimensionWithDimension:[[NSUserDefaults standardUserDefaults] doubleForKey:kUserDefaultsKeyMinYDimension] absoluteDimension:[[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsKeyAbsoluteMinYDimension]]];
	[mainViewController setSlidingStyle:(FSVSlidingStyle)[[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsKeySlidingStyle]];
	[mainViewController setSlidingResizes:[[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsKeyResize]];
	[mainViewController setSnapToLimits:[[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsKeySnapToLimits]];
	[mainViewController setXSnapBorder: [[NSUserDefaults standardUserDefaults] doubleForKey:kUserDefaultsKeySnapXBorder]];
	[mainViewController setYSnapBorder: [[NSUserDefaults standardUserDefaults] doubleForKey:kUserDefaultsKeySnapYBorder]];
	[mainViewController setSlidingViewPositioning:(FSVRelativePositioning)[[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsKeyRelativePosition]];
	[mainViewController setMainViewController:[SimpleViewController simpleViewControllerWithColor:[UIColor colorWithRed:115.0/255.0 green:190.0/255.0 blue:255.0/255.0 alpha:1.0]
																																													 text:@"Main view"]];
	[mainViewController setSlidingViewController:[SimpleViewController simpleViewControllerWithColor:[UIColor colorWithRed:245.0/2550.0 green:255.0/255.0 blue:160.0/255.0 alpha:1.0]
																																															text:@"Sliding view"]];
	[mainViewController setTitle:@"Flexible Sliding Views"];
	[self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
	[[self window] makeKeyAndVisible];
	[[self window] setRootViewController:[[UINavigationController alloc] initWithRootViewController:mainViewController]];

 	return YES;
}

-(BOOL) application:(UIApplication*)application willFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
	NSMutableDictionary* defaults = [NSMutableDictionary dictionary];
	
	
	[defaults setObject:[NSNumber numberWithBool:NO] forKey:kUserDefaultsKeyAbsoluteMaxXDimension];
	[defaults setObject:[NSNumber numberWithBool:NO] forKey:kUserDefaultsKeyAbsoluteMaxYDimension];
	[defaults setObject:[NSNumber numberWithBool:NO] forKey:kUserDefaultsKeyAbsoluteMinXDimension];
	[defaults setObject:[NSNumber numberWithBool:NO] forKey:kUserDefaultsKeyAbsoluteMinYDimension];
	[defaults setObject:[NSNumber numberWithDouble:1.0] forKey:kUserDefaultsKeyMaxXDimension];
	[defaults setObject:[NSNumber numberWithDouble:1.0] forKey:kUserDefaultsKeyMaxYDimension];
	[defaults setObject:[NSNumber numberWithDouble:0.1] forKey:kUserDefaultsKeyMinXDimension];
	[defaults setObject:[NSNumber numberWithDouble:0.1] forKey:kUserDefaultsKeyMinYDimension];
	[defaults setObject:[NSNumber numberWithDouble:0.5] forKey:kUserDefaultsKeySnapXBorder];
	[defaults setObject:[NSNumber numberWithDouble:0.5] forKey:kUserDefaultsKeySnapYBorder];
	[defaults setObject:[NSNumber numberWithInteger:FSVRelativePositioningBottom] forKey:kUserDefaultsKeyRelativePosition];
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
	return YES;
}

@end
