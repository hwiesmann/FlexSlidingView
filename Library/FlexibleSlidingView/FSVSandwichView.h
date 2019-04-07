//
//  FSVSandwichView.h
//  FlexibleSlidingViewController
//
//  Created by Hartwig Wiesmann on 07.08.15.
//  Copyright (c) 2015 skywind. All rights reserved.
//

#import <UIKit/UIKit.h>

///
/// @class FSVSandwichView
/// @brief The sandwich view is placed between the main view controller's and the sliding view controller's views.
///
/// The sandwich view has the same size as the container controller's view. It is used to for
///  - darkening the main's view by changing its transparency;
///  - detecting tap gestures for minimizing the sliding view.
///
/// @remark The default setting is a completely transparent view and does not have any darkening nor tap gesture functionality.
///
@interface FSVSandwichView : UIView

@end
