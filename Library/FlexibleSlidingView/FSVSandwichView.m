//
//  FSVSandwichView.m
//  FlexibleSlidingViewController
//
//  Created by Hartwig Wiesmann on 07.08.15.
//  Copyright (c) 2015 skywind. All rights reserved.
//

#import "FlexibleSlidingView/FSVSandwichView.h"

#pragma mark - Implementation
@implementation FSVSandwichView

#pragma mark - Initialization, object allocation and deallocation
-(instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self != nil)
	{
		[self setBackgroundColor:[UIColor clearColor]];
	} /* if */
	return self;
}

@end
