//
//  FSVSlidingViewState.h
//  FlexibleSlidingViewController
//
//  Created by Hartwig Wiesmann on 11.08.15.
//  Copyright (c) 2015 skywind. All rights reserved.
//

#ifndef FlexibleSlidingViewController_SWSlidingViewState_h
#define FlexibleSlidingViewController_SWSlidingViewState_h

 /// Defines a type describing the state of the sliding view
	typedef enum
	{
		FSVSlidingViewStateMinimized,  ///< Sliding view is minimized
		FSVSLidingViewStateMinimizing, ///< Sliding view is being animated to move to its minimum state
		FSVSlidingViewStateDragging,   ///< User is dragging sliding view
		FSVSlidingViewStateMaximizing, ///< Sliding view is being animated to move to its maximum state
		FSVSlidingViewStateMaximized   ///< Sliding view is maximized
	} FSVSlidingViewState;

#endif
