//
//  ParameterTableViewController.h
//  FlexibleSlidingViewControllerDemo
//
//  Created by Hartwig Wiesmann on 09.08.15.
//  Copyright (c) 2015 skywind. All rights reserved.
//

#import <UIKit/UIKit.h>

/** @name Key definitions for user defaults
  * @{ */

 /// Key for storing the flag indicating an absolute or relative maximum x-dimension
	extern NSString* const kUserDefaultsKeyAbsoluteMaxXDimension;
 /// Key for storing the flag indicating an absolute or relative maximum y-dimension
	extern NSString* const kUserDefaultsKeyAbsoluteMaxYDimension;
 /// Key for storing the flag indicating an absolute or relative minimum x-dimension
	extern NSString* const kUserDefaultsKeyAbsoluteMinXDimension;
 /// Key for storing the flag indicating an absolute or relative minimum y-dimension
	extern NSString* const kUserDefaultsKeyAbsoluteMinYDimension;
 /// Key for storing the darkening value
	extern NSString* const kUserDefaultsKeyDarkening;
 /// Key for storing the minimum x-position's value
	extern NSString* const kUserDefaultsKeyMaxXDimension;
 /// Key for storing the minimum y-position's value
	extern NSString* const kUserDefaultsKeyMaxYDimension;
 /// Key for storing the minimum x-position's value
	extern NSString* const kUserDefaultsKeyMinXDimension;
 /// Key for storing the minimum y-position's value
	extern NSString* const kUserDefaultsKeyMinYDimension;
 /// Key for storing the sliding view's relative dimension
	extern NSString* const kUserDefaultsKeyRelativePosition;
 /// Key for storing the flag indicating if view are sized or keep their sizes
	extern NSString* const kUserDefaultsKeyResize;
 /// Key for storing the sliding style
	extern NSString* const kUserDefaultsKeySlidingStyle;
 /// Key for storing the snap flag
	extern NSString* const kUserDefaultsKeySnapToLimits;
 /// Key for storing the snap border for the x-direction
	extern NSString* const kUserDefaultsKeySnapXBorder;
 /// Key for storing the snap border for the y-direction
	extern NSString* const kUserDefaultsKeySnapYBorder;
 /// Key for storing the flag indicating if tapping minimizes the sliding view
	extern NSString* const kUserDefaultsKeyTapMinimization;

/** @} */

@interface ParameterTableViewController : UITableViewController <UITextFieldDelegate>

@end
