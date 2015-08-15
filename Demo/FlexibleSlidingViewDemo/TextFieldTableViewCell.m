//
//  TextFieldTableViewCell.m
//  FlexibleSlidingViewControllerDemo
//
//  Created by Hartwig Wiesmann on 10.08.15.
//  Copyright (c) 2015 skywind. All rights reserved.
//

#import "TextFieldTableViewCell.h"

#pragma mark Implementation
@implementation TextFieldTableViewCell
@synthesize style=_style, textField=_textField, textLabelWidth=_textLabelWidth;

#pragma mark - Initialization and deallocation
-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
	if (style == UITableViewCellStyleSubtitle)
		style = UITableViewCellStyleDefault;
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self != nil)
	{
		_style          = style;
		_textLabelWidth = 70.0f;
		_textField      = [[UITextField alloc] init];
		[_textField setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin];
		[_textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		switch (style)
		{
			case UITableViewCellStyleValue1:
				[_textField setFont:[UIFont systemFontOfSize:17.0f]];
				[_textField setTextAlignment:NSTextAlignmentRight];
				[_textField setTextColor:[UIColor colorWithRed:0.22f green:0.33f blue:0.53f alpha:1.0f]];
				break;
			case UITableViewCellStyleValue2:
				[_textField setFont:[UIFont boldSystemFontOfSize:15.0f]];
				[_textField setTextAlignment:NSTextAlignmentLeft];
				[_textField setTextColor:[UIColor colorWithWhite:0.0f alpha:1.0f]];
				break;
			default:
				[_textField setFont:[UIFont boldSystemFontOfSize:17.0f]];
				[_textField setTextAlignment:NSTextAlignmentLeft];
				[_textField setTextColor:[UIColor colorWithWhite:0.0f alpha:1.0f]];
		} /* switch */
		[[self contentView] addSubview:_textField];
		[[self detailTextLabel] setHidden:YES];
		if (_style == UITableViewCellStyleDefault)
			[[self textLabel] setHidden:YES];
	} /* if */
	return self;
}

+(TextFieldTableViewCell*) textFieldTableViewCellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
	return [[TextFieldTableViewCell alloc] initWithStyle:style reuseIdentifier:reuseIdentifier];
}

#pragma mark - Inherited methods from UIView
-(void) layoutSubviews
{
  [super layoutSubviews];

  if ([self style] == UITableViewCellStyleDefault)
  {
    CGRect contentBounds = [[self contentView] bounds];
    CGRect textFieldFrame;

    textFieldFrame = CGRectInset(contentBounds,10.0f,6.0f);
    [[self textField] setFrame:textFieldFrame];
  } /* if */
  else
  {
    CGRect contentBounds  = [[self contentView] bounds];
    CGRect labelFrame     = [[self textLabel] frame];
    CGRect textFieldFrame;


   // make sure that the label has the specified width
    labelFrame.size.width = _textLabelWidth;
   // the origin and width of the text field depends on the available remaining space (the label's frame remains untouched in this direction)
    textFieldFrame.origin.x   = CGRectGetMaxX(labelFrame)+6.0f; // +6.0f originates from an unmodified cell of style UITableViewCellStyleValue2
    textFieldFrame.size.width = MAX(0.0f,contentBounds.size.width-textFieldFrame.origin.x-10.0f); // -10.0f originates from an unmodified cell
   // the origin of the text field depends on the font's size; in case the font size of the text field is larger or equal to the one of the label
   // the text field is centered and the baseline of the label is put to the same value as the textfield, if the label's font size is larger than the label
   // is centered first and the text field is aligned afterwards;
   // the text field's height is determined by the required space for the text (so, it depends on the font size)
    textFieldFrame.size.height = [[[self textField] font] lineHeight];
    if ([[[self textField] font] pointSize] >= [[[self textLabel] font] pointSize])
    {
      textFieldFrame.origin.y = 0.5f*(contentBounds.size.height-[[[self textField] font] lineHeight]);
     // the origin of the label is the baseline of the text field minus the ascender of the label
      labelFrame.origin.y = textFieldFrame.origin.y+[[[self textField] font] ascender]-[[[self textLabel] font] ascender];
    } /* if */
    else
    {
      labelFrame.origin.y = 0.5f*(contentBounds.size.height-labelFrame.size.height);
     // the origin of the text field is the baseline of the label minus the ascender of the text field (as the ascender and line height are given in points and not pixels
     // a unit conversion has to take place; here line height is assumed to be equal to the frame's height)
      textFieldFrame.origin.y = labelFrame.origin.y+[[[self textLabel] font] ascender]-[[[self textField] font] ascender];
    } /* if */
    [[self textLabel] setFrame:labelFrame];
    [[self textField] setFrame:textFieldFrame];
  } /* if */
}

#pragma mark - Class methods
+(TextFieldTableViewCell*) cellForTable:(UITableView*)tableView withStyle:(UITableViewCellStyle)style withIdentifier:(NSString*)identifier
{
	id cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	
	
	if (cell == nil)
		cell = [TextFieldTableViewCell textFieldTableViewCellWithStyle:style reuseIdentifier:identifier];
	return cell;
}

#pragma mark - Properties
-(void) setTextLabelWidth:(CGFloat)textLabelWidth
{
  _textLabelWidth = textLabelWidth;
  [self setNeedsLayout];
}

@end
