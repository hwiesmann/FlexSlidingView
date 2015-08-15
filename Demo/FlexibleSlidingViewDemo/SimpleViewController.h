//
//  SimpleViewController.h
//  FlexibleSlidingViewControllerDemo
//
//  Created by Hartwig Wiesmann on 07.08.15.
//  Copyright (c) 2015 skywind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleViewController : UIViewController

/** @name Properties
  * @{ */

	@property (nonatomic, strong) NSString* text;  ///< Text being centered in the view
	@property (nonatomic, strong) UIColor*  color; ///< Color for view's background

/** @} */
/** @name Initialization and object allocation
  * @{ */

 /// Initializer
	-(instancetype) initWithColor:(UIColor*)color text:(NSString*)text;

 /// Object alllocator
	+(SimpleViewController*) simpleViewControllerWithColor:(UIColor*)color text:(NSString*)text;

/** @} */
@end
