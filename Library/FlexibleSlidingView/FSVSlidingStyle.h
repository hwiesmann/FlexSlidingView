//
//  FSVSlidingStyle.h
//  FlexibleSlidingViewController
//
//  Created by Hartwig Wiesmann on 09.08.15.
//  Copyright (c) 2015 skywind. All rights reserved.
//

#ifndef FlexibleSlidingViewController_SWSlidingStyle_h
#define FlexibleSlidingViewController_SWSlidingStyle_h

 /// Defines a type indicating the style when sliding
	typedef enum
	{
		FSVSlidingStyleMove,   ///< Default style; moves view without changig its size
		FSVSlidingStyleOverlay ///< Places sliding view above other view (only relevant for main view)
	} FSVSlidingStyle;

#endif
