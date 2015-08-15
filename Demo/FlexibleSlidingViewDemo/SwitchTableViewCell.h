//
//  SwitchTableViewCell.h
//  FlexibleSlidingViewControllerDemo
//
//  Created by Hartwig Wiesmann on 11.08.15.
//  Copyright (c) 2015 skywind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchTableViewCell : UITableViewCell

/** @name Properties
  * @{ */

  @property (nonatomic, readonly, retain) UISwitch* switchControl;

/** @} */
/** @name Class methods
  * @{ */

 /// Creates an autoreleased title-switch cell
 /** @remark This class method also reuses cells if possible. */
  +(SwitchTableViewCell*) cellForTable:(UITableView*)tableView style:(UITableViewCellStyle)initStyle withIdentifier:(NSString*)identifier;

/** @} */
@end
