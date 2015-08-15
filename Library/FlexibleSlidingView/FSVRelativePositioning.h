//
//  FSVRelativePositioning.h
//  FlexibleSlidingViewController
//
//  Created by Hartwig Wiesmann on 09.08.15.
//  Copyright (c) 2015 skywind. All rights reserved.
//

#ifndef FlexibleSlidingViewController_SWRelativePositioning_h
#define FlexibleSlidingViewController_SWRelativePositioning_h

#include <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif
	
/** @name Types
  * @{ */

 /// Defines a type for relative positioning
	typedef enum
	{
		FSVRelativePositioningBottom = 1 << 0,
		FSVRelativePositioningLeft   = 1 << 1,
		FSVRelativePositioningRight  = 1 << 2,
		FSVRelativePositioningTop    = 1 << 3
	} FSVRelativePositioning;

/** @} */
/** @name Functions
  * @{ */

 /// Checks if a specific relative positioning is part of a set of positionings
	static inline BOOL HasSetRelativePositioning(NSInteger positioningSet, FSVRelativePositioning positioning)
	{
		return ((positioningSet&positioning) != 0);
	}

/** @} */
#ifdef __cplusplus
}
#endif
#endif
