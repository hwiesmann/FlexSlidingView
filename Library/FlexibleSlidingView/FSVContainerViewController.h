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

///
/// @class FSVContainerViewController
/// @brief A flexible sliding controller contains two controllers, a main and a sliding controller, where the view of the sliding controller can slide
///        onto or can push away the main controller's view.
///
/// The main controller's view normally contains the main data. The sliding controller's view is mostly used to show either temporary or auxiliary data.
/// When the sliding controller's data is to be shown its view can either slide onto the main controller's view or can push out or squeeze the size of
/// the main controller's view. The sliding style together with the sliding resizing flag determine which of the methods is used.
///
/// The sliding controller's view can slide in from all possible directions (right, left, top or bottom). The sliding operation can always be done
/// programmatically or can be initiated by the user. As a default user controlled sliding is enabled.
///
/// The minimum and maximum size of the sliding view in the sliding direction can be parameterized, too. Furthermore, in case of a user initiated sliding
/// the sliding operation can either snap to the maximum or minimum value in the sliding direction. If the sliding view snaps to the maximum or minimum
/// value is influenced by the parameter xSnapBorder, respectively ySnapBorder. This snapping operation has to be enabled explicitely as it is deactivated
/// by default.
///
/// If the sliding controller's view and the main controller's view are visible the sliding view may be minimized by the user when tapping outside the
/// sliding view. This behaviour can be enabled by the flag allowTapMinimization.
///
/// In case the sliding view is larger than its minimum size and sliding view moves on top of the main controller's view a flag can be set to darken the
/// main controller's view by a given transparency factor. A factor of zero does not darken the main controller's view while a factor of zero blackens it
/// completely.
///
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
   * @note If the container view's width is zero and a relative dimension should be returned a relative
   *       dimension of zero is returned. */
	-(FSVDimension*) xDimensionOfSlidingViewWithAbsoluteValue:(BOOL)absoluteDimension;
 /// Returns the y-dimension of the sliding view
 /** @param absoluteDimension Flag indicating if an absolute or relative dimension should be returned.
	 * @return                  The dimension of the sliding view is returned.
   * @note If the container view's height is zero and a relative dimension should be returned a relative
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
