//
//  FSVDimension.h
//  FlexibleSlidingViewController
//
//  Created by Hartwig Wiesmann on 09.08.15.
//  Copyright (c) 2015 skywind. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

@interface FSVDimension : NSObject

/** @name Properties
  * @{ */

	@property (nonatomic, assign, readonly) BOOL    absoluteDimension; ///< Flag indicating if dimension indicates an absolute or relative dimension; default value is NO
	@property (nonatomic, assign, readonly) CGFloat dimension;         ///< Dimension value itself; relative dimension values must be within [0; 1]

/** @} */
/** @name Initialization and object allocation
  * @{ */

 /// Initializer
 /** @param dimension         Dimension value. If a relative dimension is specified the value will be clamped within [0; 1].
	 * @param absoluteDimension Flag indicating if dimension contains an absolute or relative dimension value.
	 * @return                  An initialized object is returned. */
	-(instancetype) initWithDimension:(CGFloat)dimension absoluteDimension:(BOOL)absoluteDimension;

 /// Object allocator
 /** @param dimension         Dimension value. If a relative dimension is specified the value will be clamped within [0; 1].
	 * @param absoluteDimension Flag indicating if dimension contains an absolute or relative dimension value.
	 * @return                  An allocated and initialized object is returned. */
	+(FSVDimension*) dimensionWithDimension:(CGFloat)dimension absoluteDimension:(BOOL)absoluteDimension;

/** @} */
@end
