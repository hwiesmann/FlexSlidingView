//
//  FSVContainerViewController.m
//  FlexibleSlidingViewController
//
//  Created by Hartwig Wiesmann on 07.08.15.
//  Copyright (c) 2015 skywind. All rights reserved.
//

#import "FlexibleSlidingView/FSVDimension.h"
#import "FlexibleSlidingView/FSVRelativePositioning.h"
#import "FlexibleSlidingView/FSVSandwichView.h"
#import "FlexibleSlidingView/FSVContainerViewController.h"

#pragma mark Class extensions
@interface FSVContainerViewController ()

/** @name Private properties
  * @{ */

	@property (nonatomic, strong) NSMutableArray*         mainViewConstraints;         ///< Contains the four constraints for the main view; the first are related to the x-, the last to the y-direction
	@property (nonatomic, strong) NSMutableArray*         slidingViewConstraints;      ///< Contains the four constraints for the sliding view; the first are related to the x-, the last to the y-direction
	@property (nonatomic, strong) NSMutableArray*         stretchViewConstraints;      ///< Contains the four constraints for the stretch view; the first are related to the x-, the last to the y-direction
	@property (nonatomic, strong) FSVSandwichView*        sandwichView;                ///< Sandwich view
	@property (nonatomic, strong) UIPanGestureRecognizer* draggingGestureRecognizer;   ///< Gesture recognizer for dragging the sliding view
	@property (nonatomic, strong) UITapGestureRecognizer* minimizingGestureRecognizer; ///< Gesture recognizer for minimizing the sliding view when tapping outside the sliding view
	@property (nonatomic, strong) UIView*                 stretchView;                 ///< View only needed when relative positioning of the sliding view is specified; it is needed to simulate constraints of the view [slidingView] <relation> [view dimension]+multiplier*[view dimension]+constant

/** @} */
/** @name Private methods
  * @{ */

 /// Action handler
	-(void) actionDragging:(UIPanGestureRecognizer*)sender;
 /// Action handler
	-(void) actionTapping:(UITapGestureRecognizer*)sender;

 /// Cuts the links of the passed controller to another controller
 /** @param controller Controller whose links are to be cut. */
	-(void) cutLinksForController:(UIViewController*)controller;

 /// Determines the maximum x-dimension of the stretch view as an absolute value
	-(CGFloat) determineAbsoluteMaxXDimension;
 /// Determines the maximum y-dimension of the stretch view as an absolute value
	-(CGFloat) determineAbsoluteMaxYDimension;
 /// Determines the minimum x-dimension of the stretch view as an absolute value
	-(CGFloat) determineAbsoluteMinXDimension;
 /// Determines the minimum y-dimension of the stretch view as an absolute value
	-(CGFloat) determineAbsoluteMinYDimension;
 /// Determines the x-dimension of the stretch view as an absolute value
	-(CGFloat) determineAbsoluteXDimension;
 /// Determines the y-dimension of the stretch view as an absolute value
	-(CGFloat) determineAbsoluteYDimension;

 /// Creates links for the controller itself and its view to the specified controller
 /** @param controller The controller (and its view) that is linked to the container controller. */
	-(void) establishLinksForMainViewController:(UIViewController*)controller;
 /// Creates links for the controller itself and its view to the specified controller
 /** @param controller The controller (and its view) that is linked to the container controller. */
	-(void) establishLinksForSlidingViewController:(UIViewController*)controller;

 /// Initializes the constraints for the main view
	-(void) initializeConstraintsForMainView;
 /// Initializes the constraints for the sliding view
	-(void) initializeConstraintsForSlidingView;
 /// Initializes the constraints for the stretch view
	-(void) initializeConstraintsForStretchView;

 /// Sets up constraints for stretch slider when minimum x-dimension settings changed
 /** @param dimension      New x-position's value.
	 * @param absoluteValue Flag indicating if the passed x-position's value is an absolute or relative value. */
	-(void) modifyStretchViewConstraintsForXDimension:(double)dimension absoluteValue:(BOOL)absoluteValue;
 /// Sets up constraints for stretch slider when minimum x-dimension settings changed
 /** @param dimension      New y-position's value.
	 * @param absoluteValue Flag indicating if the passed y-position's value is an absolute or relative value. */
	-(void) modifyStretchViewConstraintsForYDimension:(double)dimension absoluteValue:(BOOL)absoluteValue;

 /// Sets up the darkening of the sandwich view
 /** This method darkens the sandwich view if
	 *  - a sliding view exists and
	 *  - one of the parameters is larger than its minimum absolute dimension.
   * @param absoluteXDimension Absolute x-dimension of the sliding view.
	 * @param absoluteYDimension Absolute y-dimension of the sliding view. */
	-(void) setUpDarkeningForAbsoluteXDimension:(CGFloat)absoluteXDimension absoluteYDimension:(CGFloat)absoluteYDimension;
 /// Sets up user interaction possibility for the sandwich view
 /** This method enables user interaction with the sandwich view if
	 *  - a sliding view exists and
	 *  - one of the parameters is larger than its minimum absolute dimension.
   * @param absoluteXDimension Absolute x-dimension of the sliding view.
	 * @param absoluteYDimension Absolute y-dimension of the sliding view. */
	-(void) setUpUserInteractionFeasibilityForAbsoluteXDimension:(CGFloat)absoluteXDimension absoluteYDimension:(CGFloat)absoluteYDimension;

/** @} */
@end

#pragma mark - Implementation
@implementation FSVContainerViewController
@synthesize allowDragging=_allowDragging, allowTapMinimization=_allowTapMinimization, darkening=_darkening, draggingGestureRecognizer=_draggingGestureRecognizer,
						mainViewConstraints=_mainViewConstraints, mainViewController=_mainViewController,
						maxXDimension=_maxXDimension, maxYDimension=_maxYDimension, minimizingGestureRecognizer=_minimizingGestureRecognizer, minXDimension=_minXDimension, minYDimension=_minYDimension,
						sandwichView=_sandwichView, slidingStyle=_slidingStyle, slidingViewConstraints=_slidingViewConstraints, slidingViewController=_slidingViewController,
						slidingViewPositioning=_slidingViewPositioning, slidingResizes=_slidingResizes,
						animationDuration=_animationDuration, snapToLimits=_snapToLimits, stretchView=_stretchView, stretchViewConstraints=_stretchViewConstraints,
						xSnapBorder=_xSnapBorder, ySnapBorder=_ySnapBorder;

#pragma mark - Initialization, object allocation and deallocation
-(instancetype) init
{
	self = [super init];
	if (self != nil)
	{
		_allowDragging          = YES;
		_darkening              = 0.0;
		_maxXDimension          = [FSVDimension dimensionWithDimension:1.0 absoluteDimension:NO];
		_maxYDimension          = [FSVDimension dimensionWithDimension:1.0 absoluteDimension:NO];
		_minXDimension          = [FSVDimension dimensionWithDimension:0.0 absoluteDimension:NO];
		_minYDimension          = [FSVDimension dimensionWithDimension:0.0 absoluteDimension:NO];
		_slidingViewPositioning = FSVRelativePositioningBottom;
		_animationDuration      = 0.25;
		_xSnapBorder            = 0.5;
		_ySnapBorder            = 0.5;
	} /* if */
	return self;
}

#pragma mark - Methods inhertied from UIViewController
-(void) loadView
{
	[super loadView];
	
	[self setSandwichView:[FSVSandwichView new]];
	[[self sandwichView] setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:[self darkening]]];
	[[self sandwichView] setTranslatesAutoresizingMaskIntoConstraints:NO];
	[[self sandwichView] setUserInteractionEnabled:NO];
	if ([self allowTapMinimization])
	{
		[self setMinimizingGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapping:)]];
		[[self minimizingGestureRecognizer] setDelegate:self];
		[[self sandwichView] addGestureRecognizer:[self minimizingGestureRecognizer]];
	} /* if */
	[[self view] addSubview:[self sandwichView]];

	[[self view] addConstraint:[NSLayoutConstraint constraintWithItem:[self view]
																													attribute:NSLayoutAttributeCenterX
																													relatedBy:NSLayoutRelationEqual
																														 toItem:[self sandwichView]
																													attribute:NSLayoutAttributeCenterX
																												 multiplier:1.0
																													 constant:0.0]];
	[[self view] addConstraint:[NSLayoutConstraint constraintWithItem:[self view]
																													attribute:NSLayoutAttributeCenterY
																													relatedBy:NSLayoutRelationEqual
																														 toItem:[self sandwichView]
																													attribute:NSLayoutAttributeCenterY
																												 multiplier:1.0
																													 constant:0.0]];
	[[self view] addConstraint:[NSLayoutConstraint constraintWithItem:[self view]
																													attribute:NSLayoutAttributeHeight
																													relatedBy:NSLayoutRelationEqual
																														 toItem:[self sandwichView]
																													attribute:NSLayoutAttributeHeight
																												 multiplier:1.0
																													 constant:0.0]];
	[[self view] addConstraint:[NSLayoutConstraint constraintWithItem:[self view]
																													attribute:NSLayoutAttributeWidth
																													relatedBy:NSLayoutRelationEqual
																														 toItem:[self sandwichView]
																													attribute:NSLayoutAttributeWidth
																												 multiplier:1.0
																													 constant:0.0]];

	[self setStretchView:[UIView new]];
	[[self stretchView] setBackgroundColor:[UIColor clearColor]];
	[[self view] insertSubview:[self stretchView] atIndex:0];
	[self initializeConstraintsForStretchView];
}

#pragma mark - UIGestureRecognizerDelegate protocol
-(BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer
{
	if (gestureRecognizer == [self minimizingGestureRecognizer])
		return (([self slidingViewController] != nil) && (([self determineAbsoluteXDimension] > [self determineAbsoluteMinXDimension]+0.5) || ([self determineAbsoluteYDimension] > [self determineAbsoluteMinYDimension]+0.5))); // +0.5: a rounding error and for high-res screens a max. pixel alignment difference (equal to 1/(2*<min. content scale factor>)) have to be taken into account
	else
		return YES;
}

#pragma mark - Properties
-(void) setAllowDragging:(BOOL)allowDragging
{
	if (_allowDragging != allowDragging)
	{
		_allowDragging = allowDragging;
		if ([self slidingViewController] != nil)
			if (_allowDragging)
			{
				[self setDraggingGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionDragging:)]];
				[[self draggingGestureRecognizer] setMaximumNumberOfTouches:1];
				[[[self slidingViewController] view] addGestureRecognizer:[self draggingGestureRecognizer]];
			} /* if */
			else
			{
				[[[self slidingViewController] view] removeGestureRecognizer:[self draggingGestureRecognizer]];
				[self setDraggingGestureRecognizer:nil];
			} /* if */
	} /* if */
}

-(void) setAllowTapMinimization:(BOOL)allowTapMinimization
{
	if (_allowTapMinimization != allowTapMinimization)
	{
		_allowTapMinimization = allowTapMinimization;
		if (_allowTapMinimization)
		{
			[self setMinimizingGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapping:)]];
			[[self minimizingGestureRecognizer] setDelegate:self];
			[[self sandwichView] addGestureRecognizer:[self minimizingGestureRecognizer]];
		} /* if */
		else
		{
			[[self sandwichView] removeGestureRecognizer:[self minimizingGestureRecognizer]];
			[self setMinimizingGestureRecognizer:nil];
		} /* if */
	} /* if */
}

-(void) setMainViewController:(UIViewController*)mainViewController
{
	[self cutLinksForController:_mainViewController];
	_mainViewController = mainViewController;
	[[_mainViewController view] setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self establishLinksForMainViewController:_mainViewController];
	[self initializeConstraintsForMainView];
}

-(void) setMaxXDimension:(FSVDimension*)maxXDimension
{
	_maxXDimension = maxXDimension;
	if ([self determineAbsoluteXDimension] > [self determineAbsoluteMaxXDimension])
		[self modifyStretchViewConstraintsForXDimension:[_maxXDimension dimension] absoluteValue:[_maxXDimension absoluteDimension]];
}

-(void) setMaxYDimension:(FSVDimension*)maxYDimension
{
	_maxYDimension = maxYDimension;
	if ([self determineAbsoluteYDimension] > [self determineAbsoluteMaxYDimension])
		[self modifyStretchViewConstraintsForYDimension:[_maxYDimension dimension] absoluteValue:[_maxYDimension absoluteDimension]];
}

-(void) setMinXDimension:(FSVDimension*)minXDimension
{
	_minXDimension = minXDimension;
	if ([self determineAbsoluteXDimension] < [self determineAbsoluteMinXDimension])
		[self modifyStretchViewConstraintsForXDimension:[_minXDimension dimension] absoluteValue:[_minXDimension absoluteDimension]];
	[self setUpDarkeningForAbsoluteXDimension:[self determineAbsoluteXDimension] absoluteYDimension:[self determineAbsoluteYDimension]];
	[self setUpUserInteractionFeasibilityForAbsoluteXDimension:[self determineAbsoluteXDimension] absoluteYDimension:[self determineAbsoluteYDimension]];
}

-(void) setMinYDimension:(FSVDimension*)minYDimension
{
	_minYDimension = minYDimension;
	if ([self determineAbsoluteYDimension] < [self determineAbsoluteMinYDimension])
		[self modifyStretchViewConstraintsForYDimension:[_minYDimension dimension] absoluteValue:[_minYDimension absoluteDimension]];
	[self setUpDarkeningForAbsoluteXDimension:[self determineAbsoluteXDimension] absoluteYDimension:[self determineAbsoluteYDimension]];
	[self setUpUserInteractionFeasibilityForAbsoluteXDimension:[self determineAbsoluteXDimension] absoluteYDimension:[self determineAbsoluteYDimension]];
}

-(void) setSlidingResizes:(BOOL)slidingResizes
{
	if (_slidingResizes != slidingResizes)
	{
		_slidingResizes = slidingResizes;
		[self initializeConstraintsForMainView];
		[self initializeConstraintsForSlidingView];
		[self initializeConstraintsForStretchView];
		[[self sandwichView] setBackgroundColor:[UIColor clearColor]];
	} /* if */
}

-(void) setSlidingStyle:(FSVSlidingStyle)slidingStyle
{
	if (_slidingStyle != slidingStyle)
	{
		_slidingStyle = slidingStyle;
		[self initializeConstraintsForMainView];
		[self initializeConstraintsForSlidingView];
		[self initializeConstraintsForStretchView];
		[[self sandwichView] setBackgroundColor:[UIColor clearColor]];
	} /* if */
}

-(void) setSlidingViewController:(UIViewController*)slidingViewController
{
	[self cutLinksForController:_slidingViewController];
	[[_slidingViewController view] removeGestureRecognizer:[self draggingGestureRecognizer]];
	_slidingViewController = slidingViewController;
	[[_slidingViewController view] setTranslatesAutoresizingMaskIntoConstraints:NO];
	if ([self allowDragging])
	{
		[self setDraggingGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionDragging:)]];
		[[self draggingGestureRecognizer] setMaximumNumberOfTouches:1];
		[[_slidingViewController view] addGestureRecognizer:[self draggingGestureRecognizer]];
	} /* if */
	else
		[self setDraggingGestureRecognizer:nil];
	[self establishLinksForSlidingViewController:_slidingViewController];
	[self initializeConstraintsForSlidingView];
	[[self sandwichView] setBackgroundColor:[UIColor clearColor]];
}

-(void) setSlidingViewPositioning:(NSInteger)slidingViewPositioning
{
	if (_slidingViewPositioning != slidingViewPositioning)
	{
		_slidingViewPositioning = slidingViewPositioning;
		[self initializeConstraintsForMainView];
		[self initializeConstraintsForSlidingView];
		[self initializeConstraintsForStretchView];
		[[self sandwichView] setBackgroundColor:[UIColor clearColor]];
	} /* if */
}

#pragma mark - View handling
-(FSVDimension*) xDimensionOfSlidingViewWithAbsoluteValue:(BOOL)absoluteDimension
{
 // finalize all remaining layouting before setting dimensions (this is necessary to get the up-to-date absolute dimensions)
	[[self view] layoutIfNeeded];
 /// returns the x-dimension of the sliding view
	if (absoluteDimension)
		return [FSVDimension dimensionWithDimension:[self determineAbsoluteXDimension] absoluteDimension:YES];
	else if ([[self view] bounds].size.width == 0.0)
		return [FSVDimension dimensionWithDimension:0.0 absoluteDimension:NO];
	else
		return [FSVDimension dimensionWithDimension:[self determineAbsoluteXDimension]/[[self view] bounds].size.width absoluteDimension:NO];
}

-(FSVDimension*) yDimensionOfSlidingViewWithAbsoluteValue:(BOOL)absoluteDimension
{
 // finalize all remaining layouting before setting dimensions (this is necessary to get the up-to-date absolute dimensions)
	[[self view] layoutIfNeeded];
 /// returns the y-dimension of the sliding view
	if (absoluteDimension)
		return [FSVDimension dimensionWithDimension:[self determineAbsoluteYDimension] absoluteDimension:YES];
	else if ([[self view] bounds].size.height == 0.0)
		return [FSVDimension dimensionWithDimension:0.0 absoluteDimension:NO];
	else
		return [FSVDimension dimensionWithDimension:[self determineAbsoluteYDimension]/[[self view] bounds].size.height absoluteDimension:NO];
}

-(void) maximizeSlidingViewAnimated:(BOOL)animated
{
 // finalize all remaining layouting before setting dimensions (this is necessary to get the up-to-date absolute dimensions)
	[[self view] layoutIfNeeded];
 // start setting the dimensions
	CGFloat const newAbsoluteXDimension = [self determineAbsoluteMaxXDimension];
	CGFloat const newAbsoluteYDimension = [self determineAbsoluteMaxYDimension];

	[self modifyStretchViewConstraintsForXDimension:newAbsoluteXDimension absoluteValue:YES];
	[self modifyStretchViewConstraintsForYDimension:newAbsoluteYDimension absoluteValue:YES];
	[UIView animateWithDuration:animated ? [self animationDuration] : 0.0
									 animations:
	 ^{
		 [[self view] layoutIfNeeded];
		 [self setUpDarkeningForAbsoluteXDimension:newAbsoluteXDimension absoluteYDimension:newAbsoluteYDimension];
		 [self setUpUserInteractionFeasibilityForAbsoluteXDimension:[self determineAbsoluteXDimension] absoluteYDimension:[self determineAbsoluteYDimension]];
	 }];
}

-(void) minimizeSlidingViewAnimated:(BOOL)animated
{
 // finalize all remaining layouting before setting dimensions (this is necessary to get the up-to-date absolute dimensions)
	[[self view] layoutIfNeeded];
 // start setting the dimensions
	CGFloat const newAbsoluteXDimension = [self determineAbsoluteMinXDimension];
	CGFloat const newAbsoluteYDimension = [self determineAbsoluteMinYDimension];
	
	[self modifyStretchViewConstraintsForXDimension:newAbsoluteXDimension absoluteValue:YES];
	[self modifyStretchViewConstraintsForYDimension:newAbsoluteYDimension absoluteValue:YES];
	[UIView animateWithDuration:animated ? [self animationDuration] : 0.0
									 animations:
	 ^{
		 [[self view] layoutIfNeeded];
		 [self setUpDarkeningForAbsoluteXDimension:newAbsoluteXDimension absoluteYDimension:newAbsoluteYDimension];
		 [self setUpUserInteractionFeasibilityForAbsoluteXDimension:[self determineAbsoluteXDimension] absoluteYDimension:[self determineAbsoluteYDimension]];
	 }];
}

-(void) setDimensionForX:(FSVDimension*)x y:(FSVDimension*)y animated:(BOOL)animated
{
 // finalize all remaining layouting before setting dimensions (this is necessary to get the up-to-date absolute dimensions)
	[[self view] layoutIfNeeded];
 // start setting the dimensions
	CGFloat const requestedAbsoluteXDimension = [x absoluteDimension] ? [x dimension] : [x dimension]*[[self view] bounds].size.width;
	CGFloat const requestedAbsoluteYDimension = [y absoluteDimension] ? [y dimension] : [y dimension]*[[self view] bounds].size.height;
	
	CGFloat newAbsoluteXDimension, newAbsoluteYDimension;
	
	if ([self snapToLimits])
	{
		if (requestedAbsoluteXDimension > [self xSnapBorder]*[self determineAbsoluteMaxXDimension]+(1.0-[self xSnapBorder])*[self determineAbsoluteMinXDimension])
			newAbsoluteXDimension = [self determineAbsoluteMaxXDimension];
		else
			newAbsoluteXDimension = [self determineAbsoluteMinXDimension];
		if (requestedAbsoluteYDimension > [self ySnapBorder]*[self determineAbsoluteMaxYDimension]+(1.0-[self ySnapBorder])*[self determineAbsoluteMinYDimension])
			newAbsoluteYDimension = [self determineAbsoluteMaxYDimension];
		else
			newAbsoluteYDimension = [self determineAbsoluteMinYDimension];
	} /* if */
	else
	{
		newAbsoluteXDimension = MAX([self determineAbsoluteMinXDimension],MIN([self determineAbsoluteMaxXDimension],requestedAbsoluteXDimension));
		newAbsoluteYDimension = MAX([self determineAbsoluteMinYDimension],MIN([self determineAbsoluteMaxYDimension],requestedAbsoluteYDimension));
	} /* if */
	if (animated)
		[UIView animateWithDuration:[self animationDuration]
										 animations:
		 ^{
			 [[self view] layoutIfNeeded];
			 [self setUpDarkeningForAbsoluteXDimension:newAbsoluteXDimension absoluteYDimension:newAbsoluteYDimension];
			 [self setUpUserInteractionFeasibilityForAbsoluteXDimension:[self determineAbsoluteXDimension] absoluteYDimension:[self determineAbsoluteYDimension]];
		 }];
}

#pragma mark - Private methods
-(void) actionDragging:(UIPanGestureRecognizer*)sender
{
	static CGPoint beginDimension; // dimension of sliding view at the beginning of the dragging operation
	static CGPoint beginLocation;  // location in container view's coordinates of the gesture at the beginning of the dragging operation


	if (sender == [self draggingGestureRecognizer])
	{
		switch ([sender state])
		{
			case UIGestureRecognizerStateBegan:
				beginDimension = CGPointMake([self determineAbsoluteXDimension],[self determineAbsoluteYDimension]);
				beginLocation  = [sender locationInView:[self view]];
				break;
			case UIGestureRecognizerStateCancelled:
			case UIGestureRecognizerStateEnded:
				if ([self snapToLimits])
				{
				 // make sure that all layouting has finished before animated new layouting starts
					[[self view] layoutIfNeeded];
				 // set constraints for new layout; the animated layouting is only done by calling on the topmost view layoutIfNeeded
					CGFloat newAbsoluteXDimension, newAbsoluteYDimension;
					
					if ([self determineAbsoluteXDimension] > [self xSnapBorder]*[self determineAbsoluteMaxXDimension]+(1.0-[self xSnapBorder])*[self determineAbsoluteMinXDimension])
						newAbsoluteXDimension = [self determineAbsoluteMaxXDimension];
					else
						newAbsoluteXDimension = [self determineAbsoluteMinXDimension];
					if ([self determineAbsoluteYDimension] > [self ySnapBorder]*[self determineAbsoluteMaxYDimension]+(1.0-[self ySnapBorder])*[self determineAbsoluteMinYDimension])
						newAbsoluteYDimension = [self determineAbsoluteMaxYDimension];
					else
						newAbsoluteYDimension = [self determineAbsoluteMinYDimension];
					[self modifyStretchViewConstraintsForXDimension:newAbsoluteXDimension absoluteValue:YES];
					[self modifyStretchViewConstraintsForYDimension:newAbsoluteYDimension absoluteValue:YES];
					[UIView animateWithDuration:[self animationDuration]
													 animations:
					 ^{
						 [[self view] layoutIfNeeded];
						 [self setUpDarkeningForAbsoluteXDimension:newAbsoluteXDimension absoluteYDimension:newAbsoluteYDimension];
						 [self setUpUserInteractionFeasibilityForAbsoluteXDimension:[self determineAbsoluteXDimension] absoluteYDimension:[self determineAbsoluteYDimension]];
					 }];
				} /* if */
		    break;
			case UIGestureRecognizerStateChanged:
				{
					CGPoint const location = [sender locationInView:[self view]];

					CGFloat newAbsoluteXDimension, newAbsoluteYDimension;
					CGFloat xDimensionDifference, yDimensionDifference;
					
					if (([self slidingViewPositioning]&FSVRelativePositioningRight) != 0)
						xDimensionDifference = beginLocation.x-location.x;
					else if (([self slidingViewPositioning]&FSVRelativePositioningLeft) != 0)
						xDimensionDifference = location.x-beginLocation.x;
					else
						xDimensionDifference = 0.0;
					if (([self slidingViewPositioning]&FSVRelativePositioningBottom) != 0)
						yDimensionDifference = beginLocation.y-location.y;
					else if (([self slidingViewPositioning]&FSVRelativePositioningTop) != 0)
						yDimensionDifference = location.y-beginLocation.y;
					else
						yDimensionDifference = 0.0;
					newAbsoluteXDimension = MAX([self determineAbsoluteMinXDimension],MIN([self determineAbsoluteMaxXDimension],beginDimension.x+xDimensionDifference));
					newAbsoluteYDimension = MAX([self determineAbsoluteMinYDimension],MIN([self determineAbsoluteMaxYDimension],beginDimension.y+yDimensionDifference));
					[self modifyStretchViewConstraintsForXDimension:newAbsoluteXDimension absoluteValue:YES];
					[self modifyStretchViewConstraintsForYDimension:newAbsoluteYDimension absoluteValue:YES];
					[self setUpDarkeningForAbsoluteXDimension:newAbsoluteXDimension absoluteYDimension:newAbsoluteYDimension];
					[self setUpUserInteractionFeasibilityForAbsoluteXDimension:[self determineAbsoluteXDimension] absoluteYDimension:[self determineAbsoluteYDimension]];
				} /* block */
				break;
			default:
				break;
		} /* switch */
	} /* if */
}

-(void) actionTapping:(UITapGestureRecognizer*)sender
{
	if (sender == [self minimizingGestureRecognizer])
		if ([sender state] == UIGestureRecognizerStateEnded)
			[self minimizeSlidingViewAnimated:YES];
}

-(void) cutLinksForController:(UIViewController*)controller
{
	if (controller != nil)
	{
		if ([self isViewLoaded])
			[[controller view] removeFromSuperview];
		[controller removeFromParentViewController];
	} /* if */
}

-(CGFloat) determineAbsoluteMaxXDimension
{
	if ([[self maxXDimension] absoluteDimension])
		return [[self maxXDimension] dimension];
	else if (([self slidingViewPositioning]&(FSVRelativePositioningRight | FSVRelativePositioningLeft)) != 0)
		return [[self maxXDimension] dimension]*[[self view] bounds].size.width;
	else
		return [[self view] bounds].size.width;
}

-(CGFloat) determineAbsoluteMaxYDimension
{
	if ([[self maxYDimension] absoluteDimension])
		return [[self maxYDimension] dimension];
	else if (([self slidingViewPositioning]&(FSVRelativePositioningBottom | FSVRelativePositioningTop)) != 0)
		return [[self maxYDimension] dimension]*[[self view] bounds].size.height;
	else
		return [[self view] bounds].size.height;
}

-(CGFloat) determineAbsoluteMinXDimension
{
	if ([[self minXDimension] absoluteDimension])
		return [[self minXDimension] dimension];
	else if (([self slidingViewPositioning]&(FSVRelativePositioningRight | FSVRelativePositioningLeft)) != 0)
		return [[self minXDimension] dimension]*[[self view] bounds].size.width;
	else
		return [[self view] bounds].size.width;
}

-(CGFloat) determineAbsoluteMinYDimension
{
	if ([[self minYDimension] absoluteDimension])
		return [[self minYDimension] dimension];
	else if (([self slidingViewPositioning]&(FSVRelativePositioningBottom | FSVRelativePositioningTop)) != 0)
		return [[self minYDimension] dimension]*[[self view] bounds].size.height;
	else
		return [[self view] bounds].size.height;
}

-(CGFloat) determineAbsoluteXDimension
{
	if (([self slidingViewPositioning]&FSVRelativePositioningRight) != 0)
		return [[self view] bounds].size.width-[[self stretchView] bounds].size.width;
	else
		return [[self stretchView] bounds].size.width;
}

-(CGFloat) determineAbsoluteYDimension
{
	if (([self slidingViewPositioning]&FSVRelativePositioningBottom) != 0)
		return [[self view] bounds].size.height-[[self stretchView] bounds].size.height;
	else
		return [[self stretchView] bounds].size.height;
}

-(void) establishLinksForMainViewController:(UIViewController*)controller
{
	if (controller != nil)
	{
		[self addChildViewController:controller];
		if ([controller view] != nil)
			[[self view] insertSubview:[controller view] belowSubview:[self sandwichView]];
	} /* if */
}

-(void) establishLinksForSlidingViewController:(UIViewController*)controller
{
	if (controller != nil)
	{
		[self addChildViewController:controller];
		if ([controller view] != nil)
			[[self view] insertSubview:[controller view] aboveSubview:[self sandwichView]];
	} /* if */
}

-(void) initializeConstraintsForMainView
{
	UIView* const mainView = [[self mainViewController] view];


	if (mainView != nil)
	{
		[mainView setTranslatesAutoresizingMaskIntoConstraints:NO];
		[[self view] removeConstraints:[self mainViewConstraints]];
		[self setMainViewConstraints:[NSMutableArray arrayWithCapacity:4]];
		switch ([self slidingStyle])
		{
			case FSVSlidingStyleMove:
				if ([self slidingResizes])
				{
					if (HasSetRelativePositioning([self slidingViewPositioning],FSVRelativePositioningLeft))
					{
						[[self mainViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeLeft  relatedBy:NSLayoutRelationEqual toItem:[self stretchView] attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
						[[self mainViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:[self view]        attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
					} /* if */
					else
					{
						[[self mainViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeLeft  relatedBy:NSLayoutRelationEqual toItem:[self view]        attribute:NSLayoutAttributeLeft  multiplier:1.0 constant:0.0]];
						[[self mainViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:[self stretchView] attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
					} /* if */
					if (HasSetRelativePositioning([self slidingViewPositioning],FSVRelativePositioningTop))
					{
						[[self mainViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeTop    relatedBy:NSLayoutRelationEqual toItem:[self stretchView] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
						[[self mainViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:[self view]        attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
					} /* if */
					else
					{
						[[self mainViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeTop    relatedBy:NSLayoutRelationEqual toItem:[self view]        attribute:NSLayoutAttributeTop    multiplier:1.0 constant:0.0]];
						[[self mainViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:[self stretchView] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
					} /* if */
				} /* if */
				else
				{
					if (HasSetRelativePositioning([self slidingViewPositioning],FSVRelativePositioningRight))
						[[self mainViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:[self stretchView] attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
					else if (HasSetRelativePositioning([self slidingViewPositioning],FSVRelativePositioningLeft))
						[[self mainViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:[self stretchView] attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
					else
						[[self mainViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:[self stretchView] attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
					[[self mainViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
					if (HasSetRelativePositioning([self slidingViewPositioning],FSVRelativePositioningBottom))
						[[self mainViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:[self stretchView] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
					else if (HasSetRelativePositioning([self slidingViewPositioning],FSVRelativePositioningTop))
						[[self mainViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:[self stretchView] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
					else
						[[self mainViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:[self stretchView] attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
					[[self mainViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
				} /* if */
    		break;
			case FSVSlidingStyleOverlay:
				[[self mainViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:mainView
																																					 attribute:NSLayoutAttributeLeft
																																					 relatedBy:NSLayoutRelationEqual
																																							toItem:[self view]
																																					 attribute:NSLayoutAttributeLeft
																																					multiplier:1.0
																																						constant:0.0]];
				[[self mainViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:mainView
																																					 attribute:NSLayoutAttributeWidth
																																					 relatedBy:NSLayoutRelationEqual
																																							toItem:[self view]
																																					 attribute:NSLayoutAttributeWidth
																																					multiplier:1.0
																																						constant:0.0]];
				[[self mainViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:mainView
																																					 attribute:NSLayoutAttributeTop
																																					 relatedBy:NSLayoutRelationEqual
																																							toItem:[self view]
																																					 attribute:NSLayoutAttributeTop
																																					multiplier:1.0
																																						constant:0.0]];
				[[self mainViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:mainView
																																					 attribute:NSLayoutAttributeHeight
																																					 relatedBy:NSLayoutRelationEqual
																																							toItem:[self view]
																																					 attribute:NSLayoutAttributeHeight
																																					multiplier:1.0
																																						constant:0.0]];
				break;
			default:
				@throw [NSException exceptionWithName:@"UnsupportedSwitchCase" reason:@"Unsupported switch case" userInfo:nil];
		} /* switch */
		[[self view] addConstraints:[self mainViewConstraints]];
		[mainView layoutIfNeeded];
	} /* if */
}

-(void) initializeConstraintsForSlidingView
{
	UIView* const slidingView = [[self slidingViewController] view];


	if (slidingView != nil)
	{
		[slidingView setTranslatesAutoresizingMaskIntoConstraints:NO];
		[[self view] removeConstraints:[self slidingViewConstraints]];
		[self setSlidingViewConstraints:[NSMutableArray arrayWithCapacity:4]];
		if (([self slidingViewPositioning]&FSVRelativePositioningRight) != 0)
		{
			[[self slidingViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:slidingView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:[self stretchView] attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
			if ([self slidingResizes])
				[[self slidingViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:slidingView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
			else
				[[self slidingViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:slidingView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
		} /* if */
		else
		{
			[[self slidingViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:slidingView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:[self stretchView] attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
			if ([self slidingResizes])
				[[self slidingViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:slidingView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:[self stretchView] attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
			else
				[[self slidingViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:slidingView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
		} /* if */
		if (([self slidingViewPositioning]&FSVRelativePositioningBottom) != 0)
		{
			[[self slidingViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:slidingView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:[self stretchView] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
			if ([self slidingResizes])
				[[self slidingViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:slidingView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
			else
				[[self slidingViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:slidingView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
		} /* if */
		else
		{
			[[self slidingViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:slidingView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:[self stretchView] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
			if ([self slidingResizes])
				[[self slidingViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:slidingView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:[self stretchView] attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
			else
				[[self slidingViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:slidingView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
		} /* if */
		[[self view] addConstraints:[self slidingViewConstraints]];
		[slidingView layoutIfNeeded];
	} /* if */
}

-(void) initializeConstraintsForStretchView
{
	UIView* const stretchView = [self stretchView];


	if (stretchView != nil)
	{
		[stretchView setTranslatesAutoresizingMaskIntoConstraints:NO];
		[[self view] removeConstraints:[self stretchViewConstraints]];
		[self setStretchViewConstraints:[NSMutableArray arrayWithCapacity:4]];
		[[self stretchViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:stretchView
																																					attribute:NSLayoutAttributeLeft
																																					relatedBy:NSLayoutRelationEqual
																																						 toItem:[self view]
																																					attribute:NSLayoutAttributeLeft
																																				 multiplier:1.0
																																					 constant:0.0]];
		if (([self slidingViewPositioning]&FSVRelativePositioningRight) != 0)
			if ([[self minXDimension] absoluteDimension])
				[[self stretchViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:stretchView
																																							attribute:NSLayoutAttributeWidth
																																							relatedBy:NSLayoutRelationEqual
																																								 toItem:[self view]
																																							attribute:NSLayoutAttributeWidth
																																						 multiplier:1.0
																																							 constant:-[[self minXDimension] dimension]]];
			else
				[[self stretchViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:stretchView
																																							attribute:NSLayoutAttributeWidth
																																							relatedBy:NSLayoutRelationEqual
																																								 toItem:[self view]
																																							attribute:NSLayoutAttributeWidth
																																						 multiplier:1.0-[[self minXDimension] dimension]
																																							 constant:0.0]];
		else if (([self slidingViewPositioning]&FSVRelativePositioningLeft) != 0)
			if ([[self minXDimension] absoluteDimension])
				[[self stretchViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:stretchView
																																							attribute:NSLayoutAttributeWidth
																																							relatedBy:NSLayoutRelationEqual
																																								 toItem:nil
																																							attribute:NSLayoutAttributeNotAnAttribute
																																						 multiplier:0.0
																																							 constant:[[self minXDimension] dimension]]];
			else
				[[self stretchViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:stretchView
																																							attribute:NSLayoutAttributeWidth
																																							relatedBy:NSLayoutRelationEqual
																																								 toItem:[self view]
																																							attribute:NSLayoutAttributeWidth
																																						 multiplier:[[self minXDimension] dimension]
																																							 constant:0.0]];
		else
			[[self stretchViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:stretchView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
		[[self stretchViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:stretchView
																																					attribute:NSLayoutAttributeTop
																																					relatedBy:NSLayoutRelationEqual
																																						 toItem:[self view]
																																					attribute:NSLayoutAttributeTop
																																				 multiplier:1.0
																																					 constant:0.0]];
		if (([self slidingViewPositioning]&FSVRelativePositioningBottom) != 0)
			if ([[self minYDimension] absoluteDimension])
				[[self stretchViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:stretchView
																																							attribute:NSLayoutAttributeHeight
																																							relatedBy:NSLayoutRelationEqual
																																								 toItem:[self view]
																																							attribute:NSLayoutAttributeHeight
																																						 multiplier:1.0
																																							 constant:-[[self minYDimension] dimension]]];
			else
				[[self stretchViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:stretchView
																																							attribute:NSLayoutAttributeHeight
																																							relatedBy:NSLayoutRelationEqual
																																								 toItem:[self view]
																																							attribute:NSLayoutAttributeHeight
																																						 multiplier:1.0-[[self minYDimension] dimension]
																																							 constant:0.0]];
		else if (([self slidingViewPositioning]&FSVRelativePositioningTop) != 0)
			if ([[self minYDimension] absoluteDimension])
				[[self stretchViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:stretchView
																																							attribute:NSLayoutAttributeHeight
																																							relatedBy:NSLayoutRelationEqual
																																								 toItem:nil
																																							attribute:NSLayoutAttributeNotAnAttribute
																																						 multiplier:0.0
																																							 constant:[[self minYDimension] dimension]]];
			else
				[[self stretchViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:stretchView
																																							attribute:NSLayoutAttributeHeight
																																							relatedBy:NSLayoutRelationEqual
																																								 toItem:[self view]
																																							attribute:NSLayoutAttributeHeight
																																						 multiplier:[[self minYDimension] dimension]
																																							 constant:0.0]];
		else
			[[self stretchViewConstraints] addObject:[NSLayoutConstraint constraintWithItem:stretchView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
		[[self view] addConstraints:[self stretchViewConstraints]];
		[stretchView layoutIfNeeded]; // all layouting depends on stretchView -> determine correct size of stretchView immediately
	} /* if */
}

-(void) modifyStretchViewConstraintsForXDimension:(double)dimension absoluteValue:(BOOL)absoluteValue
{
	UIView* const stretchView = [self stretchView];
	
	
	if (stretchView != nil)
	{
		[[self view] removeConstraint:[[self stretchViewConstraints] objectAtIndex:1]];
		if (([self slidingViewPositioning]&FSVRelativePositioningRight) != 0)
			if (absoluteValue)
				[[self stretchViewConstraints] replaceObjectAtIndex:1
																								 withObject:[NSLayoutConstraint constraintWithItem:stretchView
																																												 attribute:NSLayoutAttributeWidth
																																												 relatedBy:NSLayoutRelationEqual
																																														toItem:[self view]
																																												 attribute:NSLayoutAttributeWidth
																																												multiplier:1.0
																																													constant:-dimension]];
			else
				[[self stretchViewConstraints] replaceObjectAtIndex:1
																								 withObject:[NSLayoutConstraint constraintWithItem:stretchView
																																												 attribute:NSLayoutAttributeWidth
																																												 relatedBy:NSLayoutRelationEqual
																																														toItem:[self view]
																																												 attribute:NSLayoutAttributeWidth
																																												multiplier:1.0-dimension
																																													constant:0.0]];
		else if (([self slidingViewPositioning]&FSVRelativePositioningLeft) != 0)
			if (absoluteValue)
				[[self stretchViewConstraints] replaceObjectAtIndex:1
																								 withObject:[NSLayoutConstraint constraintWithItem:stretchView
																																												 attribute:NSLayoutAttributeWidth
																																												 relatedBy:NSLayoutRelationEqual
																																														toItem:nil
																																												 attribute:NSLayoutAttributeNotAnAttribute
																																												multiplier:0.0
																																													constant:dimension]];
			else
				[[self stretchViewConstraints] replaceObjectAtIndex:1
																								 withObject:[NSLayoutConstraint constraintWithItem:stretchView
																																												 attribute:NSLayoutAttributeWidth
																																												 relatedBy:NSLayoutRelationEqual
																																														toItem:[self view]
																																												 attribute:NSLayoutAttributeWidth
																																												multiplier:dimension
																																													constant:0.0]];
		else
			[[self stretchViewConstraints] replaceObjectAtIndex:1
																							 withObject:[NSLayoutConstraint constraintWithItem:stretchView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
		[[self view] addConstraint:[[self stretchViewConstraints] objectAtIndex:1]];
		[stretchView setNeedsLayout];
	} /* if */
}

-(void) modifyStretchViewConstraintsForYDimension:(double)dimension absoluteValue:(BOOL)absoluteValue
{
	UIView* const stretchView = [self stretchView];
	
	
	if (stretchView != nil)
	{
		[[self view] removeConstraint:[[self stretchViewConstraints] objectAtIndex:3]];
		if (([self slidingViewPositioning]&FSVRelativePositioningBottom) != 0)
			if (absoluteValue)
				[[self stretchViewConstraints] replaceObjectAtIndex:3
																								 withObject:[NSLayoutConstraint constraintWithItem:stretchView
																																												 attribute:NSLayoutAttributeHeight
																																												 relatedBy:NSLayoutRelationEqual
																																														toItem:[self view]
																																												 attribute:NSLayoutAttributeHeight
																																												multiplier:1.0
																																													constant:-dimension]];
			else
				[[self stretchViewConstraints] replaceObjectAtIndex:3
																								 withObject:[NSLayoutConstraint constraintWithItem:stretchView
																																												 attribute:NSLayoutAttributeHeight
																																												 relatedBy:NSLayoutRelationEqual
																																														toItem:[self view]
																																												 attribute:NSLayoutAttributeHeight
																																												multiplier:1.0-dimension
																																													constant:0.0]];
		else if (([self slidingViewPositioning]&FSVRelativePositioningTop) != 0)
			if (absoluteValue)
				[[self stretchViewConstraints] replaceObjectAtIndex:3
																								 withObject:[NSLayoutConstraint constraintWithItem:stretchView
																																												 attribute:NSLayoutAttributeHeight
																																												 relatedBy:NSLayoutRelationEqual
																																														toItem:nil
																																												 attribute:NSLayoutAttributeNotAnAttribute
																																												multiplier:0.0
																																													constant:dimension]];
			else
				[[self stretchViewConstraints] replaceObjectAtIndex:3
																								 withObject:[NSLayoutConstraint constraintWithItem:stretchView
																																												 attribute:NSLayoutAttributeHeight
																																												 relatedBy:NSLayoutRelationEqual
																																														toItem:[self view]
																																												 attribute:NSLayoutAttributeHeight
																																												multiplier:dimension
																																													constant:0.0]];
		else
			[[self stretchViewConstraints] replaceObjectAtIndex:3
																							 withObject:[NSLayoutConstraint constraintWithItem:stretchView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
		[[self view] addConstraint:[[self stretchViewConstraints] objectAtIndex:3]];
		[stretchView setNeedsLayout];
	} /* if */
}

-(void) setUpDarkeningForAbsoluteXDimension:(CGFloat)absoluteXDimension absoluteYDimension:(CGFloat)absoluteYDimension
{
	UIColor* targetColor;


	if (([[self slidingViewController] view] != nil) && ([self slidingStyle] == FSVSlidingStyleOverlay) &&
			((absoluteXDimension- [self determineAbsoluteMinXDimension] > 1.0) || (absoluteYDimension-[self determineAbsoluteMinYDimension] > 1.0))) // comparison against 1 takes rounding errors and rounding to pixels into account
		targetColor = [UIColor colorWithWhite:0.0 alpha:[self darkening]];
	else
		targetColor = [UIColor clearColor];
	if (![[[self sandwichView] backgroundColor] isEqual:targetColor])
		[[self sandwichView] setBackgroundColor:targetColor];
}

-(void) setUpUserInteractionFeasibilityForAbsoluteXDimension:(CGFloat)absoluteXDimension absoluteYDimension:(CGFloat)absoluteYDimension
{
	[[self sandwichView] setUserInteractionEnabled:(([[self slidingViewController] view] != nil) &&
																									((absoluteXDimension-[self determineAbsoluteMinXDimension] > 1.0) || (absoluteYDimension-[self determineAbsoluteMinYDimension] > 1.0)))]; // comparison against 1 takes rounding errors and rounding to pixels into account
}

@end
