//
//  FSVDimension.m
//  FlexibleSlidingViewController
//
//  Created by Hartwig Wiesmann on 09.08.15.
//  Copyright (c) 2015 skywind. All rights reserved.
//

#import "FlexibleSlidingView/FSVDimension.h"

#pragma mark Implementation
@implementation FSVDimension
@synthesize absoluteDimension=_absoluteDimension, dimension=_dimension;

#pragma mark - Initialization, object allocation and deallocation
-(instancetype) initWithDimension:(CGFloat)dimension absoluteDimension:(BOOL)absoluteDimension
{
	self = [super init];
	if (self != nil)
	{
		_absoluteDimension = absoluteDimension;
		if (_absoluteDimension)
			_dimension = dimension;
		else
			_dimension = MAX(0.0,MIN(1.0,dimension));
	} /* if */
	return self;
}

+(FSVDimension*) dimensionWithDimension:(CGFloat)dimension absoluteDimension:(BOOL)absoluteDimension
{
	return [[FSVDimension alloc] initWithDimension:dimension absoluteDimension:absoluteDimension];
}

@end
