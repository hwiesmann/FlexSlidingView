//
//  FSVContainerViewController.h
//  FlexibleSlidingViewController
//
//  Created by Hartwig Wiesmann on 07.08.15.
//  Copyright (c) 2015 skywind. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FlexibleSlidingView/FSVSlidingStyle.h"

@class FSVDimension;

@interface FSVContainerViewController : UIViewController <UIGestureRecognizerDelegate>

/** @name Properties
  * @{ */

	@property (nonatomic, assign) BOOL            allowDragging;          ///< Flag indicating if dragging by the user of the sliding view is allowed; default setting is YES
	@property (nonatomic, assign) BOOL            allowTapMinimization;   ///< Flag indicating if a tap outside the sliding view leads to a minimization of the sliding view; default value is NO
	@property (nonatomic, assign) BOOL            slidingResizes;         ///< This flag indicates if sliding the view resizes or keeps the views' sizes; default setting is NO
	@property (nonatomic, assign) BOOL            snapToLimits;           ///< Flag indicating if the sliding view should move to its limits (min. or max. dimensions) when dragging stops; default setting is NO
	@property (nonatomic, assign) CGFloat         darkening;              ///< Value within [0; 1] that dims the main window when being in overlay mode and the sliding view has not its minimum dimension; default value is zero (no darkening)
	@property (nonatomic, assign) CGFloat         xSnapBorder;            ///< If the current sliding view's x-dimension is larger than xSnapBorder*maxAbsoluteXDimension+(1-xSnapBorder)*minAbsoluteXDimension the sliding view will snap to the maximum otherwise to the minimum x-limit; the default setting is 0.5
	@property (nonatomic, assign) CGFloat         ySnapBorder;            ///< If the current sliding view's y-dimension is larger than ySnapBorder*maxAbsoluteYDimension+(1-ySnapBorder)*minAbsoluteYDimension the sliding view will snap to the maximum otherwise to the minimum y-limit; the default setting is 0.5
	@property (nonatomic, assign) NSInteger       slidingViewPositioning; ///< Position of the sliding view relative to the container's view; default value is FSVRelativePositioningBottom
	@property (nonatomic, assign) NSTimeInterval  animationDuration;      ///< Duration of the maximization, minimization or snapping operation in seconds; default value is 0.25
	@property (nonatomic, assign) FSVSlidingStyle slidingStyle;           ///< Sliding style; default value is FSVSlidingStyleMove

	@property (nonatomic, strong) FSVDimension*     maxXDimension;         ///< Maximum x-dimension of the sliding view relative to the container's view; default value is a relative dimension of 1.0
	@property (nonatomic, strong) FSVDimension*     maxYDimension;         ///< Maximum y-dimension of the sliding view relative to the container's view; default value is a relative dimension of 1.0
	@property (nonatomic, strong) FSVDimension*     minXDimension;         ///< Maximum x-dimension of the sliding view relative to the container's view; default value is a relative dimension of 0.0
	@property (nonatomic, strong) FSVDimension*     minYDimension;         ///< Maximum y-dimension of the sliding view relative to the container's view; default value is a relative dimension of 0.0
	@property (nonatomic, strong) UIViewController* mainViewController;    ///< Main view controller
	@property (nonatomic, strong) UIViewController* slidingViewController; ///< View controller that can slide onto or that can push the main view controller

/** @} */
/** @name View handling
  * @{ */

 /// Returns the x-dimension of the sliding view
 /** @param absoluteDimension Flag indicating if an absolute or relative dimension should be returned.
	 * @return                  The dimension of the sliding view is returned.
   * @note If the container view's width is zero a relative dimension should be returned a relative
   *       dimension of zero is returned. */
	-(FSVDimension*) xDimensionOfSlidingViewWithAbsoluteValue:(BOOL)absoluteDimension;
 /// Returns the y-dimension of the sliding view
 /** @param absoluteDimension Flag indicating if an absolute or relative dimension should be returned.
	 * @return                  The dimension of the sliding view is returned.
   * @note If the container view's height is zero a relative dimension should be returned a relative
   *       dimension of zero is returned. */
	-(FSVDimension*) yDimensionOfSlidingViewWithAbsoluteValue:(BOOL)absoluteDimension;

 /// Maximizes the sliding view
 /** @param animated Flag indicating if the maximization is animated. The time for the animation is determined by animationDuration. */
	-(void) maximizeSlidingViewAnimated:(BOOL)animated;

 /// Minimizes sliding view
 /** @param animated Flag indicating if the minimization is animated. The time for the animation is determined by animationDuration. */
	-(void) minimizeSlidingViewAnimated:(BOOL)animated;

 /// Sets the dimensions of the sliding view
 /** @param x        Dimension for x-coordinate.
	 * @param y        Dimension for y-coordinate.
	 * @param animated Flag indicating if the setting has to be animated. The duration of the animation is determined by animationDuration.
	 * @note The dimensions can only be freely set if snapToLimits contains the value NO. Otherwise, the sliding view will snap to its limits. */
	-(void) setDimensionForX:(FSVDimension*)x y:(FSVDimension*)y animated:(BOOL)animated;

/** @} */
@end
