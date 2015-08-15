//
//  ParameterTableViewController.m
//  FlexibleSlidingViewControllerDemo
//
//  Created by Hartwig Wiesmann on 09.08.15.
//  Copyright (c) 2015 skywind. All rights reserved.
//

#import "ParameterTableViewController.h"
#import "SwitchTableViewCell.h"
#import "TextFieldTableViewCell.h"

#import "FlexibleSlidingView/FSVSlidingStyle.h"

#pragma mark Global constant definitions
NSString* const kUserDefaultsKeyAbsoluteMaxXDimension = @"UserDefaultsKeyAbsoluteMaxXDimension";
NSString* const kUserDefaultsKeyAbsoluteMaxYDimension = @"UserDefaultsKeyAbsoluteMaxYDimension";
NSString* const kUserDefaultsKeyAbsoluteMinXDimension = @"UserDefaultsKeyAbsoluteMinXDimension";
NSString* const kUserDefaultsKeyAbsoluteMinYDimension = @"UserDefaultsKeyAbsoluteMinYDimension";
NSString* const kUserDefaultsKeyDarkening             = @"UserDefaultsKeyDarkening";
NSString* const kUserDefaultsKeyMaxXDimension         = @"UserDefaultsKeyMaxXDimension";
NSString* const kUserDefaultsKeyMaxYDimension         = @"UserDefaultsKeyMaxYDimension";
NSString* const kUserDefaultsKeyMinXDimension         = @"UserDefaultsKeyMinXDimension";
NSString* const kUserDefaultsKeyMinYDimension         = @"UserDefaultsKeyMinYDimension";
NSString* const kUserDefaultsKeyRelativePosition      = @"UserDefaultsKeyRelativePosition";
NSString* const kUserDefaultsKeyResize                = @"UserDefaultsKeyResize";
NSString* const kUserDefaultsKeySlidingStyle          = @"UserDefaultsKeySlidingStyle";
NSString* const kUserDefaultsKeySnapToLimits          = @"UserDefaultsKeySnapToLimits";
NSString* const kUserDefaultsKeySnapXBorder           = @"UserDefaultsKeySnapXBorder";
NSString* const kUserDefaultsKeySnapYBorder           = @"UserDefaultsKeySnapYBorder";
NSString* const kUserDefaultsKeyTapMinimization       = @"UserDefaultsKeyTapMinimization";

#pragma mark - Local constant definitions

#define kSectionEffects 3
#define kSectionGeneral 0
#define kSectionSizes   1
#define kSectionSnap    2

#define kRowEffectsDarkening       0
#define kRowEffectsTapMinimization 1

#define kRowGeneralMove             1
#define kRowGeneralRelativePosition 0
#define kRowGeneralResize           2

#define kRowSizesAbsoluteMaxXDimensionFlag 4
#define kRowSizesAbsoluteMaxYDimensionFlag 6
#define kRowSizesAbsoluteMinXDimensionFlag 0
#define kRowSizesAbsoluteMinYDimensionFlag 2
#define kRowSizesMaxXDimensionValue        5
#define kRowSizesMaxYDimensionValue        7
#define kRowSizesMinXDimensionValue        1
#define kRowSizesMinYDimensionValue        3

#define kRowSnapFlag   0
#define kRowSnapXLimit (kRowSnapFlag+1)
#define kRowSnapYLimit (kRowSnapXLimit+1)

static NSInteger const kTagAbsoluteMaxXDimension = 1;
static NSInteger const kTagAbsoluteMaxYDimension = kTagAbsoluteMaxXDimension+1;
static NSInteger const kTagAbsoluteMinXDimension = kTagAbsoluteMaxYDimension+1;
static NSInteger const kTagAbsoluteMinYDimension = kTagAbsoluteMinXDimension+1;
static NSInteger const kTagDarkening             = kTagAbsoluteMinYDimension+1;
static NSInteger const kTagMaxXDimension         = kTagDarkening+1;
static NSInteger const kTagMaxYDimension         = kTagMaxXDimension+1;
static NSInteger const kTagMinXDimension         = kTagMaxYDimension+1;
static NSInteger const kTagMinYDimension         = kTagMinXDimension+1;
static NSInteger const kTagMove                 = kTagMinYDimension+1;
static NSInteger const kTagRelativePosition     = kTagMove+1;
static NSInteger const kTagResize               = kTagRelativePosition+1;
static NSInteger const kTagSnapFlag             = kTagResize+1;
static NSInteger const kTagSnapXBorder          = kTagSnapFlag+1;
static NSInteger const kTagSnapYBorder          = kTagSnapXBorder+1;
static NSInteger const kTagTapMinimization        = kTagSnapYBorder+1;

static NSString* kCellIDSwitch    = @"CellIDSwitch";
static NSString* kCellIDTextField = @"CellIDTextField";

#pragma mark - Class extensions
@interface ParameterTableViewController ()

/** @name Private methods
  * @{ */

 /// Action handler
	-(void) actionAbsoluteMaxXDimension:(UISwitch*)sender;
 /// Action handler
	-(void) actionAbsoluteMaxYDimension:(UISwitch*)sender;
 /// Action handler
	-(void) actionAbsoluteMinXDimension:(UISwitch*)sender;
 /// Action handler
	-(void) actionAbsoluteMinYDimension:(UISwitch*)sender;
 /// Action handler
	-(void) actionDone:(UIBarButtonItem*)sender;
 /// Action handler
	-(void) actionMove:(UISwitch*)sender;
 /// Action handler
	-(void) actionResize:(UISwitch*)sender;
 /// Action handler
	-(void) actionSnapFlag:(UISwitch*)sender;
 /// Action handler
	-(void) actionTapMinimization:(UISwitch*)sender;

/** @} */
@end

#pragma mark - Implementation
@implementation ParameterTableViewController

#pragma mark - Inherited methods from UIViewController
-(void) viewDidLoad
{
	[super viewDidLoad];
	
	if ([self presentingViewController] != nil)
		[[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone:)]];
}

#pragma mark - UITableViewDataSource protocol
-(NSInteger) numberOfSectionsInTableView:(UITableView*)tableView
{
	return 4;
}

-(UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	UITableViewCell* cell = nil;

	
	switch ([indexPath section])
	{
		case kSectionEffects:
			switch ([indexPath row])
			{
				case kRowEffectsDarkening:
					cell = [TextFieldTableViewCell cellForTable:tableView withStyle:UITableViewCellStyleValue1 withIdentifier:kCellIDTextField];
					if (cell != nil)
					{
						TextFieldTableViewCell* const textFieldCell = (TextFieldTableViewCell*)cell;
						
						UITextField* textFieldView = [textFieldCell textField];
						
						[textFieldCell setTextLabelWidth:180.0];
						[[textFieldCell textLabel] setText:@"Darkening [0.0; 1.0]"];
						[textFieldView setDelegate:self];
						[textFieldView setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
						[textFieldView setTag:kTagDarkening];
						[textFieldView setText:[NSString stringWithFormat:@"%.2f",[[NSUserDefaults standardUserDefaults] doubleForKey:kUserDefaultsKeyDarkening]]];
					} /* if */
					break;
				case kRowEffectsTapMinimization:
					cell = [SwitchTableViewCell cellForTable:tableView style:UITableViewCellStyleValue1 withIdentifier:kCellIDSwitch];
					if (cell != nil)
					{
						SwitchTableViewCell* const switchCell = (SwitchTableViewCell*)cell;
						
						[switchCell setTag:kTagTapMinimization];
						[[switchCell switchControl] removeTarget:self action:NULL forControlEvents:UIControlEventValueChanged];
						[[switchCell switchControl] addTarget:self action:@selector(actionTapMinimization:) forControlEvents:UIControlEventValueChanged];
						[[switchCell switchControl] setOn:[[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsKeyTapMinimization]];
						[[switchCell textLabel] setText:@"Tap minimizes"];
					} /* if */
					break;
			} /* switch */
			break;
		case kSectionGeneral:
			switch ([indexPath row])
			{
				case kRowGeneralMove:
					cell = [SwitchTableViewCell cellForTable:tableView style:UITableViewCellStyleValue1 withIdentifier:kCellIDSwitch];
					if (cell != nil)
					{
						SwitchTableViewCell* const switchCell = (SwitchTableViewCell*)cell;
						
						[switchCell setTag:kTagMove];
						[[switchCell switchControl] removeTarget:self action:NULL forControlEvents:UIControlEventValueChanged];
						[[switchCell switchControl] addTarget:self action:@selector(actionMove:) forControlEvents:UIControlEventValueChanged];
						[[switchCell switchControl] setOn:[[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsKeySlidingStyle] == FSVSlidingStyleMove];
						[[switchCell textLabel] setText:@"Move views"];
					} /* if */
					break;
				case kRowGeneralRelativePosition:
					cell = [TextFieldTableViewCell cellForTable:tableView withStyle:UITableViewCellStyleValue1 withIdentifier:kCellIDTextField];
					if (cell != nil)
					{
						TextFieldTableViewCell* const textFieldCell = (TextFieldTableViewCell*)cell;
						
						UITextField* textFieldView = [textFieldCell textField];
						
						[textFieldCell setTextLabelWidth:180.0];
						[[textFieldCell textLabel] setText:@"Relative dimension (1-15)"];
						[textFieldView setDelegate:self];
						[textFieldView setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
						[textFieldView setTag:kTagRelativePosition];
						[textFieldView setText:[NSString stringWithFormat:@"%d",(int)[[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsKeyRelativePosition]]];
					} /* if */
					break;
				case kRowGeneralResize:
					cell = [SwitchTableViewCell cellForTable:tableView style:UITableViewCellStyleValue1 withIdentifier:kCellIDSwitch];
					if (cell != nil)
					{
						SwitchTableViewCell* const switchCell = (SwitchTableViewCell*)cell;
						
						[switchCell setTag:kTagResize];
						[[switchCell switchControl] removeTarget:self action:NULL forControlEvents:UIControlEventValueChanged];
						[[switchCell switchControl] addTarget:self action:@selector(actionResize:) forControlEvents:UIControlEventValueChanged];
						[[switchCell switchControl] setOn:[[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsKeyResize]];
						[[switchCell textLabel] setText:@"Resize views"];
					} /* if */
					break;
			} /* switch */
			break;
		case kSectionSizes:
			switch ([indexPath row])
			{
				case kRowSizesAbsoluteMaxXDimensionFlag:
					cell = [SwitchTableViewCell cellForTable:tableView style:UITableViewCellStyleValue1 withIdentifier:kCellIDSwitch];
					if (cell != nil)
					{
						SwitchTableViewCell* const switchCell = (SwitchTableViewCell*)cell;
						
						[switchCell setTag:kTagAbsoluteMaxXDimension];
						[[switchCell switchControl] removeTarget:self action:NULL forControlEvents:UIControlEventValueChanged];
						[[switchCell switchControl] addTarget:self action:@selector(actionAbsoluteMaxXDimension:) forControlEvents:UIControlEventValueChanged];
						[[switchCell switchControl] setOn:[[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsKeyAbsoluteMaxXDimension]];
						[[switchCell textLabel] setText:@"Absolute x-dimension (max.)"];
					} /* if */
					break;
				case kRowSizesAbsoluteMaxYDimensionFlag:
					cell = [SwitchTableViewCell cellForTable:tableView style:UITableViewCellStyleValue1 withIdentifier:kCellIDSwitch];
					if (cell != nil)
					{
						SwitchTableViewCell* const switchCell = (SwitchTableViewCell*)cell;
						
						[switchCell setTag:kTagAbsoluteMaxYDimension];
						[[switchCell switchControl] removeTarget:self action:NULL forControlEvents:UIControlEventValueChanged];
						[[switchCell switchControl] addTarget:self action:@selector(actionAbsoluteMaxYDimension:) forControlEvents:UIControlEventValueChanged];
						[[switchCell switchControl] setOn:[[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsKeyAbsoluteMaxYDimension]];
						[[switchCell textLabel] setText:@"Absolute y-dimension (max.)"];
					} /* if */
					break;
				case kRowSizesAbsoluteMinXDimensionFlag:
					cell = [SwitchTableViewCell cellForTable:tableView style:UITableViewCellStyleValue1 withIdentifier:kCellIDSwitch];
					if (cell != nil)
					{
						SwitchTableViewCell* const switchCell = (SwitchTableViewCell*)cell;
						
						[switchCell setTag:kTagAbsoluteMinXDimension];
						[[switchCell switchControl] removeTarget:self action:NULL forControlEvents:UIControlEventValueChanged];
						[[switchCell switchControl] addTarget:self action:@selector(actionAbsoluteMinXDimension:) forControlEvents:UIControlEventValueChanged];
						[[switchCell switchControl] setOn:[[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsKeyAbsoluteMinXDimension]];
						[[switchCell textLabel] setText:@"Absolute x-dimension (min.)"];
					} /* if */
					break;
				case kRowSizesAbsoluteMinYDimensionFlag:
					cell = [SwitchTableViewCell cellForTable:tableView style:UITableViewCellStyleValue1 withIdentifier:kCellIDSwitch];
					if (cell != nil)
					{
						SwitchTableViewCell* const switchCell = (SwitchTableViewCell*)cell;
						
						[switchCell setTag:kTagAbsoluteMinYDimension];
						[[switchCell switchControl] removeTarget:self action:NULL forControlEvents:UIControlEventValueChanged];
						[[switchCell switchControl] addTarget:self action:@selector(actionAbsoluteMinYDimension:) forControlEvents:UIControlEventValueChanged];
						[[switchCell switchControl] setOn:[[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsKeyAbsoluteMinYDimension]];
						[[switchCell textLabel] setText:@"Absolute y-dimension (min.)"];
					} /* if */
					break;
				case kRowSizesMaxXDimensionValue:
					cell = [TextFieldTableViewCell cellForTable:tableView withStyle:UITableViewCellStyleValue1 withIdentifier:kCellIDTextField];
					if (cell != nil)
					{
						TextFieldTableViewCell* const textFieldCell = (TextFieldTableViewCell*)cell;
						
						UITextField* textFieldView = [textFieldCell textField];
						
						[textFieldCell setTextLabelWidth:180.0];
						[[textFieldCell textLabel] setText:@"Max. x-dimension"];
						[textFieldView setDelegate:self];
						[textFieldView setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
						[textFieldView setTag:kTagMaxXDimension];
						[textFieldView setText:[NSString stringWithFormat:@"%.2f",[[NSUserDefaults standardUserDefaults] doubleForKey:kUserDefaultsKeyMaxXDimension]]];
					} /* if */
					break;
				case kRowSizesMaxYDimensionValue:
					cell = [TextFieldTableViewCell cellForTable:tableView withStyle:UITableViewCellStyleValue1 withIdentifier:kCellIDTextField];
					if (cell != nil)
					{
						TextFieldTableViewCell* const textFieldCell = (TextFieldTableViewCell*)cell;
						
						UITextField* textFieldView = [textFieldCell textField];
						
						[textFieldCell setTextLabelWidth:180.0];
						[[textFieldCell textLabel] setText:@"Max. y-dimension"];
						[textFieldView setDelegate:self];
						[textFieldView setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
						[textFieldView setTag:kTagMaxYDimension];
						[textFieldView setText:[NSString stringWithFormat:@"%.2f",[[NSUserDefaults standardUserDefaults] doubleForKey:kUserDefaultsKeyMaxYDimension]]];
					} /* if */
					break;
				case kRowSizesMinXDimensionValue:
					cell = [TextFieldTableViewCell cellForTable:tableView withStyle:UITableViewCellStyleValue1 withIdentifier:kCellIDTextField];
					if (cell != nil)
					{
						TextFieldTableViewCell* const textFieldCell = (TextFieldTableViewCell*)cell;
						
						UITextField* textFieldView = [textFieldCell textField];
						
						[textFieldCell setTextLabelWidth:180.0];
						[[textFieldCell textLabel] setText:@"Min. x-dimension"];
						[textFieldView setDelegate:self];
						[textFieldView setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
						[textFieldView setTag:kTagMinXDimension];
						[textFieldView setText:[NSString stringWithFormat:@"%.2f",[[NSUserDefaults standardUserDefaults] doubleForKey:kUserDefaultsKeyMinXDimension]]];
					} /* if */
					break;
				case kRowSizesMinYDimensionValue:
					cell = [TextFieldTableViewCell cellForTable:tableView withStyle:UITableViewCellStyleValue1 withIdentifier:kCellIDTextField];
					if (cell != nil)
					{
						TextFieldTableViewCell* const textFieldCell = (TextFieldTableViewCell*)cell;
						
						UITextField* textFieldView = [textFieldCell textField];
						
						[textFieldCell setTextLabelWidth:180.0];
						[[textFieldCell textLabel] setText:@"Min. y-dimension"];
						[textFieldView setDelegate:self];
						[textFieldView setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
						[textFieldView setTag:kTagMinYDimension];
						[textFieldView setText:[NSString stringWithFormat:@"%.2f",[[NSUserDefaults standardUserDefaults] doubleForKey:kUserDefaultsKeyMinYDimension]]];
					} /* if */
					break;
			} /* switch */
			break;
		case kSectionSnap:
			switch ([indexPath row])
			{
				case kRowSnapFlag:
					cell = [SwitchTableViewCell cellForTable:tableView style:UITableViewCellStyleValue1 withIdentifier:kCellIDSwitch];
					if (cell != nil)
					{
						SwitchTableViewCell* const switchCell = (SwitchTableViewCell*)cell;
						
						[switchCell setTag:kTagSnapFlag];
						[[switchCell switchControl] removeTarget:self action:NULL forControlEvents:UIControlEventValueChanged];
						[[switchCell switchControl] addTarget:self action:@selector(actionSnapFlag:) forControlEvents:UIControlEventValueChanged];
						[[switchCell switchControl] setOn:[[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsKeySnapToLimits]];
						[[switchCell textLabel] setText:@"Snap to limits"];
					} /* if */
					break;
				case kRowSnapXLimit:
					cell = [TextFieldTableViewCell cellForTable:tableView withStyle:UITableViewCellStyleValue1 withIdentifier:kCellIDTextField];
					if (cell != nil)
					{
						TextFieldTableViewCell* const textFieldCell = (TextFieldTableViewCell*)cell;
						
						UITextField* textFieldView = [textFieldCell textField];
						
						[textFieldCell setTextLabelWidth:180.0];
						[[textFieldCell textLabel] setText:@"x-border"];
						[textFieldView setDelegate:self];
						[textFieldView setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
						[textFieldView setTag:kTagSnapXBorder];
						[textFieldView setText:[NSString stringWithFormat:@"%.2f",[[NSUserDefaults standardUserDefaults] doubleForKey:kUserDefaultsKeySnapXBorder]]];
					} /* if */
					break;
				case kRowSnapYLimit:
					cell = [TextFieldTableViewCell cellForTable:tableView withStyle:UITableViewCellStyleValue1 withIdentifier:kCellIDTextField];
					if (cell != nil)
					{
						TextFieldTableViewCell* const textFieldCell = (TextFieldTableViewCell*)cell;
						
						UITextField* textFieldView = [textFieldCell textField];
						
						[textFieldCell setTextLabelWidth:180.0];
						[[textFieldCell textLabel] setText:@"y-border"];
						[textFieldView setDelegate:self];
						[textFieldView setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
						[textFieldView setTag:kTagSnapYBorder];
						[textFieldView setText:[NSString stringWithFormat:@"%.2f",[[NSUserDefaults standardUserDefaults] doubleForKey:kUserDefaultsKeySnapYBorder]]];
					} /* if */
					break;
			} /* switch */
	} /* switch */
	return cell;
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section)
	{
		case kSectionEffects:
			return 2;
		case kSectionGeneral:
			return 3;
		case kSectionSizes:
			return 8;
		case kSectionSnap:
			return 3;
	} /* switch */
	return 0;
}

#pragma mark - UITableViewDelegate protocol
-(NSIndexPath*) tableView:(UITableView*)tableView willSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	return nil;
}

#pragma mark - UITextFieldDelegate protocol
-(void) textFieldDidEndEditing:(UITextField*)textField
{
	switch ([textField tag])
	{
		case kTagDarkening:
			[[NSUserDefaults standardUserDefaults] setDouble:[[textField text] doubleValue] forKey:kUserDefaultsKeyDarkening];
			break;
		case kTagMaxXDimension:
			[[NSUserDefaults standardUserDefaults] setDouble:[[textField text] doubleValue] forKey:kUserDefaultsKeyMaxXDimension];
			break;
		case kTagMaxYDimension:
			[[NSUserDefaults standardUserDefaults] setDouble:[[textField text] doubleValue] forKey:kUserDefaultsKeyMaxYDimension];
			break;
		case kTagMinXDimension:
			[[NSUserDefaults standardUserDefaults] setDouble:[[textField text] doubleValue] forKey:kUserDefaultsKeyMinXDimension];
			break;
		case kTagMinYDimension:
			[[NSUserDefaults standardUserDefaults] setDouble:[[textField text] doubleValue] forKey:kUserDefaultsKeyMinYDimension];
			break;
		case kTagRelativePosition:
			if (([[textField text] integerValue] >= 1) && ([[textField text] integerValue] <= 15))
				[[NSUserDefaults standardUserDefaults] setInteger:[[textField text] integerValue] forKey:kUserDefaultsKeyRelativePosition];
			break;
		case kTagSnapXBorder:
			[[NSUserDefaults standardUserDefaults] setDouble:[[textField text] doubleValue] forKey:kUserDefaultsKeySnapXBorder];
			break;
		case kTagSnapYBorder:
			[[NSUserDefaults standardUserDefaults] setDouble:[[textField text] doubleValue] forKey:kUserDefaultsKeySnapYBorder];
			break;
	} /* switch */
}

-(BOOL) textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
	switch ([textField tag])
	{
		case kTagRelativePosition:
			return (([string length] == 0) || NSEqualRanges(NSMakeRange(0,[string length]),[string rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]]));
	} /* switch */
	return YES;
}

#pragma mark - Private methods
-(void) actionAbsoluteMaxXDimension:(UISwitch*)sender
{
	[[NSUserDefaults standardUserDefaults] setBool:[sender isOn] forKey:kUserDefaultsKeyAbsoluteMaxXDimension];
}

-(void) actionAbsoluteMaxYDimension:(UISwitch*)sender
{
	[[NSUserDefaults standardUserDefaults] setBool:[sender isOn] forKey:kUserDefaultsKeyAbsoluteMaxYDimension];
}

-(void) actionAbsoluteMinXDimension:(UISwitch*)sender
{
	[[NSUserDefaults standardUserDefaults] setBool:[sender isOn] forKey:kUserDefaultsKeyAbsoluteMinXDimension];
}

-(void) actionAbsoluteMinYDimension:(UISwitch*)sender
{
	[[NSUserDefaults standardUserDefaults] setBool:[sender isOn] forKey:kUserDefaultsKeyAbsoluteMinYDimension];
}

-(void) actionDone:(UIBarButtonItem*)sender
{
	[[self tableView] endEditing:YES];
	if ([self presentingViewController] != nil)
		[self dismissViewControllerAnimated:YES completion:nil];
}

-(void) actionMove:(UISwitch*)sender
{
	if ([sender isOn])
		[[NSUserDefaults standardUserDefaults] setInteger:FSVSlidingStyleMove forKey:kUserDefaultsKeySlidingStyle];
	else
		[[NSUserDefaults standardUserDefaults] setInteger:FSVSlidingStyleOverlay forKey:kUserDefaultsKeySlidingStyle];
}

-(void) actionResize:(UISwitch*)sender
{
	[[NSUserDefaults standardUserDefaults] setBool:[sender isOn] forKey:kUserDefaultsKeyResize];
}

-(void) actionSnapFlag:(UISwitch*)sender
{
	[[NSUserDefaults standardUserDefaults] setBool:[sender isOn] forKey:kUserDefaultsKeySnapToLimits];
}

-(void) actionTapMinimization:(UISwitch*)sender
{
	[[NSUserDefaults standardUserDefaults] setBool:[sender isOn] forKey:kUserDefaultsKeyTapMinimization];
}

@end
