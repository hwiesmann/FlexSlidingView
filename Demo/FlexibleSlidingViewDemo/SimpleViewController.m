//
//  SimpleViewController.m
//  FlexibleSlidingViewControllerDemo
//
//  Created by Hartwig Wiesmann on 07.08.15.
//  Copyright (c) 2015 skywind. All rights reserved.
//

#import "SimpleViewController.h"

@interface SimpleViewController ()

@end

#pragma mark Implementation
@implementation SimpleViewController
@synthesize color=_color, text=_text;

#pragma mark - Initialization, object allocation and deallocation
-(instancetype) initWithColor:(UIColor*)color text:(NSString*)text
{
	self = [super init];
	if (self != nil)
	{
		_color = color;
		_text  = text;
	} /* if */
	return self ;
}

+(SimpleViewController*) simpleViewControllerWithColor:(UIColor*)color text:(NSString*)text
{
	return [[SimpleViewController alloc] initWithColor:color text:text];
}

#pragma mark - Methods inherited from UIViewController
-(void) loadView
{
	[super loadView];
	
 // simple view controller sets the background's colour...
	[[self view] setBackgroundColor:[self color]];
 // ...and places a text in the middle of the view
	UILabel* label = [UILabel new];
	
	[label setTranslatesAutoresizingMaskIntoConstraints:NO];
	[label setText:[self text]];
	[[self view] addSubview:label];
	[[self view] addConstraint:[NSLayoutConstraint constraintWithItem:[self view]
																													attribute:NSLayoutAttributeCenterX
																													relatedBy:NSLayoutRelationEqual
																														 toItem:label
																													attribute:NSLayoutAttributeCenterX
																												 multiplier:1.0
																													 constant:0.0]];
	[[self view] addConstraint:[NSLayoutConstraint constraintWithItem:[self view]
																													attribute:NSLayoutAttributeCenterY
																													relatedBy:NSLayoutRelationEqual
																														 toItem:label
																													attribute:NSLayoutAttributeCenterY
																												 multiplier:1.0
																													 constant:0.0]];
	
}

#pragma mark - Properties
-(void) setColor:(UIColor*)color
{
	_color = color;
	if ([self isViewLoaded])
		[[self view] setBackgroundColor:_color];
}

-(void) setText:(NSString*)text
{
	_text = text;
	if ([self isViewLoaded])
		[(UILabel*)[[[self view] subviews] firstObject] setText:_text];
}

@end
