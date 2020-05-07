#include "SNPRootListController.h"
#import <spawn.h>

@implementation SNPRootListController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.gabrielsiu.stickynoteprefs.plist"];
	if (![preferences[@"useCustomNoteColor"] boolValue]) {
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"noteColorCell"]] animated:NO];
	}
	if (![preferences[@"useCustomFontColor"] boolValue]) {
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"fontColorCell"]] animated:NO];
	}
	if (![preferences[@"useCustomAlpha"] boolValue]) {
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"alphaCell"]] animated:NO];
	}
	if (![preferences[@"useCustomDuration"] boolValue]) {
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"durationCell"]] animated:NO];
	}
	if (![preferences[@"useCustomButtonSize"] boolValue]) {
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"buttonSizeCell"]] animated:NO];
	}
	if (![preferences[@"useCustomFont"] boolValue]) {
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"customFontCell"]] animated:NO];
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"availableFontsCell"]] animated:NO];
	}
}

- (void)reloadSpecifiers {
	[super reloadSpecifiers];
	
	NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.gabrielsiu.stickynoteprefs.plist"];
	if (![preferences[@"useCustomNoteColor"] boolValue]) {
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"noteColorCell"]] animated:NO];
	}
	if (![preferences[@"useCustomFontColor"] boolValue]) {
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"fontColorCell"]] animated:NO];
	}
	if (![preferences[@"useCustomAlpha"] boolValue]) {
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"alphaCell"]] animated:NO];
	}
	if (![preferences[@"useCustomDuration"] boolValue]) {
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"durationCell"]] animated:NO];
	}
	if (![preferences[@"useCustomButtonSize"] boolValue]) {
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"buttonSizeCell"]] animated:NO];
	}
	if (![preferences[@"useCustomFont"] boolValue]) {
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"customFontCell"]] animated:NO];
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"availableFontsCell"]] animated:NO];
	}
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];

		NSArray *chosenIDs = @[@"noteColorCell", @"fontColorCell", @"alphaCell", @"durationCell", @"buttonSizeCell", @"customFontCell", @"availableFontsCell"];
		self.savedSpecifiers = (!self.savedSpecifiers) ? [[NSMutableDictionary alloc] init] : self.savedSpecifiers;
		for (PSSpecifier *specifier in _specifiers) {
			if ([chosenIDs containsObject:[specifier propertyForKey:@"id"]]) {
				[self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];
			}
		}
	}

	return _specifiers;
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
	[super setPreferenceValue:value specifier:specifier];

	NSString *key = [specifier propertyForKey:@"key"];
	NSString *prevID;
	NSString *chosenID;

	if ([key isEqualToString:@"useCustomNoteColor"]) {
		prevID = @"useCustomNoteColorCell";
		chosenID = @"noteColorCell";
	} else if ([key isEqualToString:@"useCustomFontColor"]) {
		prevID = @"useCustomFontColorCell";
		chosenID = @"fontColorCell";
	} else if ([key isEqualToString:@"useCustomAlpha"]) {
		prevID = @"useCustomAlphaCell";
		chosenID = @"alphaCell";
	} else if ([key isEqualToString:@"useCustomDuration"]) {
		prevID = @"useCustomDurationCell";
		chosenID = @"durationCell";
	} else if ([key isEqualToString:@"useCustomButtonSize"]) {
		prevID = @"useCustomButtonSizeCell";
		chosenID = @"buttonSizeCell";
	} else if ([key isEqualToString:@"useCustomFont"]) {
		prevID = @"useCustomFontCell";
		chosenID = @"customFontCell";
	} else {
		return;
	}

	if (![value boolValue]) {
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[chosenID]] animated:YES];
		// Also remove the available fonts cell upon disabling custom fonts
		if ([key isEqualToString:@"useCustomFont"]) {
			[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"availableFontsCell"]] animated:YES];
		}
	} else if (![self containsSpecifier:self.savedSpecifiers[chosenID]]) {
		[self insertContiguousSpecifiers:@[self.savedSpecifiers[chosenID]] afterSpecifierID:prevID animated:YES];
		// Also insert the available fonts cell upon enabling custom fonts
		if ([key isEqualToString:@"useCustomFont"]) {
			[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"availableFontsCell"]] afterSpecifierID:@"customFontCell" animated:YES];
		}
	}
}

- (void)openFonts {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://iosfontlist.com/"]];
}

- (void)respring {
	pid_t pid;
	int status;
	const char* argv[] = {"sbreload", NULL};
	posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char* const*)argv, NULL);
	waitpid(pid, &status, WEXITED);
}

@end
