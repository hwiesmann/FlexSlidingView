//
//  TextFieldTableViewCell.h
//  FlexibleSlidingViewControllerDemo
//
//  Created by Hartwig Wiesmann on 10.08.15.
//  Copyright (c) 2015 skywind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldTableViewCell : UITableViewCell

/** @name Properties
  * @{ */

  @property (nonatomic, assign) CGFloat textLabelWidth;

	@property (nonatomic, readonly) UITableViewCellStyle style;

	@property (nonatomic, readonly, strong) UITextField* textField;

/** @} */
/** @name Initialization and object allocation
  * @{ */

 /// Object allocator
	+(TextFieldTableViewCell*) textFieldTableViewCellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier;

/** @} */
/** @name Class methods
  * @{ */

 /// Returns either a buffered or newly created cell
	+(TextFieldTableViewCell*) cellForTable:(UITableView*)tableView withStyle:(UITableViewCellStyle)style withIdentifier:(NSString*)identifier;

/** @} */
@end
