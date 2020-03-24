#include "CoronaRootListController.h"
#import <Preferences/PSEditableTableCell.h>
#import <Cephei/HBPreferences.h>


@implementation CoronaRootListController

-(instancetype)init {
self = [super init];

if (self) {
HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
appearanceSettings.tintColor = [UIColor colorWithRed:0.53 green:0.70 blue:0.37 alpha:1.0];
appearanceSettings.tableViewCellSeparatorColor = [UIColor colorWithWhite:0 alpha:0];
self.hb_appearanceSettings = appearanceSettings;
self.respringButton = [[UIBarButtonItem alloc] initWithTitle:@"Respring"
style:UIBarButtonItemStylePlain
target:self
action:@selector(respring:)];
self.respringButton.tintColor = [UIColor colorWithRed:0.53 green:0.70 blue:0.37 alpha:1.0];
self.navigationItem.rightBarButtonItem = self.respringButton;




}

return self;
}

-(NSArray *)specifiers {
if (_specifiers == nil) {
_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
}

return _specifiers;
}


- (void)respring:(id)sender {
NSTask *t = [[[NSTask alloc] init] autorelease];
[t setLaunchPath:@"/usr/bin/killall"];
[t setArguments:[NSArray arrayWithObjects:@"backboardd", nil]];
[t launch];
}




@end



@interface megacorona : PSEditableTableCell
@end

@implementation megacorona
-(id)initWithStyle:(long long)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3 {
self = [super initWithStyle:arg1 reuseIdentifier:arg2 specifier:arg3];
if (self) {
UITextField* textField = [self textField];
textField.textAlignment = NSTextAlignmentRight;
textField.delegate = self;



}
return self;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
if (textField == self.text) {
[textField resignFirstResponder];
return NO;
}
return YES;
}


-(void)textFieldDidEndEditing:(UITextField *)textField {

HBPreferences *pfs = [[HBPreferences alloc] initWithIdentifier:@"com.megadev.coronacount"];
NSString *stringpost = textField.text;

[pfs setObject:stringpost forKey:@"country"];

UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Country Selected!"
message:textField.text
delegate:self
cancelButtonTitle:@"OK"
otherButtonTitles:nil];
[alert show];


textField.text = @"";




}

@end