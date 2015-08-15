//
//  SwitchTableViewCell.m
//  FlexibleSlidingViewControllerDemo
//
//  Created by Hartwig Wiesmann on 11.08.15.
//  Copyright (c) 2015 skywind. All rights reserved.
//

#import "SwitchTableViewCell.h"

#pragma mark Implementation
@implementation SwitchTableViewCell
@synthesize switchControl=_switchControl;

#pragma mark - Initialization and deallocation
-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self != nil)
  {
		_switchControl = [UISwitch new];
		[self setAccessoryView:_switchControl];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
	} /* if */
  return self;
}

#pragma mark Class methods
+(SwitchTableViewCell*) cellForTable:(UITableView*)tableView style:(UITableViewCellStyle)initStyle withIdentifier:(NSString*)identifier
{
  SwitchTableViewCell* cell = (SwitchTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
  
  
  if (cell == nil)
    cell = [[SwitchTableViewCell alloc] initWithStyle:initStyle reuseIdentifier:identifier];
  return cell;
}

@end
