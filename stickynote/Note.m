#import "Constants.h"
#import "NSDictionary+DefaultsValue.h"
#import "Note.h"

@implementation Note

# pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame defaults:(NSDictionary *)defaultsDict {
	self = [super initWithFrame:frame];
	if (self) {
		defaults = defaultsDict;
		[self setupStyle];
		[self setupClearButton];
		[self setupTextView];
	}
	return self;
}

# pragma mark - Setup

- (void)setupStyle {
	// TODO: Fix colors
	// BOOL useCustomColor = [defaults boolValueForKey:@"useCustomNoteColor" fallback:NO];
	self.backgroundColor = [UIColor yellowColor];//useCustomColor ? [defaults colorValueForKey:@"noteColor" fallback:@"#ffff00"] : [UIColor yellowColor];
	self.layer.cornerRadius = [defaults intValueForKey:@"cornerRadius" fallback:kDefaultCornerRadius];
	self.layer.masksToBounds = NO;
	self.layer.shadowOffset = CGSizeMake(-5, 5);
	self.layer.shadowRadius = 5;
	self.layer.shadowOpacity = 0.5;
	double alphaValue;
	if ([defaults boolValueForKey:@"useCustomAlpha" fallback:NO]) {
		alphaValue = [defaults doubleValueForKey:@"alphaValue" fallback:kDefaultAlpha];
	} else {
		alphaValue = kDefaultAlpha;
	}
	[self setAlpha:alphaValue];
}

- (void)setupClearButton {
	clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[clearButton setImage:[UIImage imageWithContentsOfFile:[kAssetsPath stringByAppendingString:@"/icon-clear.png"]] forState:UIControlStateNormal];
	clearButton.frame = CGRectMake(self.frame.size.width - kIconSize, 0, kIconSize, kIconSize);
	[clearButton addTarget:self action:@selector(clearTextView:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:clearButton];
}


- (void)setupTextView {
	textView = [[UITextView alloc] initWithFrame:CGRectMake(0, kIconSize, 250, self.frame.size.height - kIconSize) textContainer:nil];
	textView.backgroundColor = [UIColor clearColor];
	// TODO: Fix colors
	//BOOL useCustomFontColor = [defaults boolValueForKey:@"useCustomFontColor" fallback:NO];
	textView.textColor = [UIColor blackColor];//useCustomFontColor ? [defaults colorValueForKey:@"fontColor" fallback:@"#000000"] : [UIColor blackColor];
	NSNumber *defaultsFontSize = [defaults valueForKey:@"fontSize"];
	NSInteger fontSize = defaultsFontSize ? defaultsFontSize.intValue : kDefaultFontSize;
	textView.font = [UIFont systemFontOfSize:fontSize];

	// Setup 'Done' button on keyboard
	UIToolbar *doneButtonView = [[UIToolbar alloc] init];
    [doneButtonView sizeToFit];
	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard:)];
    [doneButtonView setItems:[NSArray arrayWithObjects:flexibleSpace, doneButton, nil]];
    textView.inputAccessoryView = doneButtonView;

	[self addSubview:textView];
}

# pragma mark - Actions

- (void)dismissKeyboard:(UIButton *)sender {
	[textView resignFirstResponder];
}

- (void)clearTextView:(UIButton *)sender {
	textView.text = @"";
}

@end