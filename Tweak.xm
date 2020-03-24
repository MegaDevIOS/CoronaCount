


/// Global Setup & Inludes
#import <WebKit/WebKit.h>
#import "QuartzCore/QuartzCore.h"
#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>

HBPreferences *pfs;
NSString * country;



#define trigger @"com.megadev.coronacount/trigger"
#define changecolor @"com.megadev.coronacount/changecolor"


UIColor *statuscolor;

@interface UIStatusBarWindow : UIWindow

@property (nonatomic, retain) NSString *cases;
@property(nonatomic, strong) UILabel *label;

@end
NSNumber *cases;
NSNumber *startcases;
NSString *type;
static bool customcountry;
static bool enabled;



////Begin tweak
%group corona


//// Probably should not have hook the window but yea :/ 
%hook UIStatusBarWindow
%property(nonatomic, strong) UILabel *label;

-(void)setStatusBar:(id)arg1{

%orig;


///Define NSNotification
[[NSNotificationCenter defaultCenter] addObserver:self
selector:@selector(refresh:) 
name:@"trigger"
object:nil];

[[NSNotificationCenter defaultCenter] addObserver:self
selector:@selector(updatecolor:) 
name:@"changecolor"
object:nil];


NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.megadev.coronacount"];



////Detect prefs

if ([prefs integerForKey:@"type"] == 0) {

type = @" Cases";
}


if ([prefs integerForKey:@"type"] == 1) {

type = @" Deaths";
}



if ([prefs integerForKey:@"type"] == 2) {

type = @" Cured";
}



///// Detect devicz orientation so counter hides when watching a video
[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
[[NSNotificationCenter defaultCenter]
addObserver:self selector:@selector(orientationChanged:)
name:UIDeviceOrientationDidChangeNotification
object:[UIDevice currentDevice]];








NSURL *targetURL;

if(!customcountry){

targetURL = [NSURL URLWithString:@"https://corona.lmao.ninja/all"];

}else{


NSString *nospacecountry = [country stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; /// Replace spaces with %20 for url encoding
NSString *comburl = [NSString stringWithFormat:@"https://corona.lmao.ninja/countries/%@", nospacecountry];


NSString *stonks = [comburl lowercaseString]; // Api doesnt accept uppercase letters
targetURL = [NSURL URLWithString:stonks];

}


NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];



[NSURLConnection sendAsynchronousRequest: request
queue: [NSOperationQueue mainQueue]
completionHandler: ^(NSURLResponse *urlResponse, NSData *responseData, NSError *requestError) {
// Check for Errors
if (requestError || !responseData) {
// jump back to the main thread to update the UI
dispatch_async(dispatch_get_main_queue(), ^{

});
} else {
// jump back to the main thread to update the UI
dispatch_async(dispatch_get_main_queue(), ^{




NSDictionary *s = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:NULL];

NSString *validation = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];


if([validation containsString:@"found"]){

///Check if api returned error 

UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Country Not found!"
message:[NSString stringWithFormat:@"Country not found: %@", country]
delegate:self
cancelButtonTitle:@"OK"
otherButtonTitles:nil];
[alert show];

}


if ([prefs integerForKey:@"type"] == 0) {
/// Try to fetch cases
@try {
startcases =[s objectForKey:@"cases"];

}

@catch (NSException *exception) {
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Country Not found!"
message:[NSString stringWithFormat:@"Country not found: %@", country]
delegate:self
cancelButtonTitle:@"OK"
otherButtonTitles:nil];
[alert show];
}
}


if ([prefs integerForKey:@"type"] == 1) {

@try {
startcases =[s objectForKey:@"deaths"];

}

@catch (NSException *exception) {
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Country Not found!"
message:[NSString stringWithFormat:@"Country not found: %@", country]
delegate:self
cancelButtonTitle:@"OK"
otherButtonTitles:nil];
[alert show];
}
}



if ([prefs integerForKey:@"type"] == 2) {

@try {
startcases =[s objectForKey:@"recovered"];

}

@catch (NSException *exception) {
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Country Not found!"
message:[NSString stringWithFormat:@"Country not found: %@", country]
delegate:self
cancelButtonTitle:@"OK"
otherButtonTitles:nil];
[alert show];
}


}


NSNumberFormatter *formatter = [NSNumberFormatter new];
[formatter setNumberStyle:NSNumberFormatterDecimalStyle]; 

NSString *myString = [formatter stringFromNumber:startcases];






dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{



if(startcases.intValue > 0){



CGRect coronaframe;
CGFloat screenBounds = [UIScreen mainScreen].bounds.size.height;
/// x , xs , pro
if(screenBounds == 812 ){

coronaframe =  CGRectMake([UIScreen mainScreen].bounds.size.width - 95 , 26, 90, 20);

}



/// pro max , xs max
if(screenBounds > 812 ){

coronaframe = CGRectMake([UIScreen mainScreen].bounds.size.width - 106 , 26, 90, 20);
}




/// 8   ,  7  , 6  
if(screenBounds < 812 ){
if(screenBounds > 700){

coronaframe = CGRectMake([UIScreen mainScreen].bounds.size.width - 90 , 12, 90, 20);


}else{
coronaframe =  CGRectMake([UIScreen mainScreen].bounds.size.width - 85 , 10, 90, 20);
}
}



UILabel *label = [[UILabel alloc] initWithFrame:coronaframe];
label.backgroundColor = [UIColor clearColor];
label.textAlignment = NSTextAlignmentCenter;
[label setFont:[UIFont systemFontOfSize:10]];
label.textColor = statuscolor;
label.numberOfLines = 0;
label.lineBreakMode = UILineBreakModeWordWrap;
label.text = [NSString stringWithFormat:@"%@%@", myString, type];

[self addSubview:label];
self.label = label;



}


});

});
}
}
];












}
%new
- (void) orientationChanged:(NSNotification *)note
{
  if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)){
  self.label.hidden = YES;
}
else {
self.label.hidden = NO;
}
}


//// Fetch info
%new
- (void) refresh:(NSNotification *) notification{



NSURL *targetURL;

if(!customcountry){

targetURL = [NSURL URLWithString:@"https://corona.lmao.ninja/all"];

}else{

NSString *nospacecountry = [country stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
NSString *comburl = [NSString stringWithFormat:@"https://corona.lmao.ninja/countries/%@", nospacecountry];


NSString *stonks = [comburl lowercaseString];
targetURL = [NSURL URLWithString:stonks];

NSLog(@"MEME %@",stonks);
}


NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];



[NSURLConnection sendAsynchronousRequest: request
queue: [NSOperationQueue mainQueue]
completionHandler: ^(NSURLResponse *urlResponse, NSData *responseData, NSError *requestError) {
// Check for Errors
if (requestError || !responseData) {
// jump back to the main thread to update the UI
dispatch_async(dispatch_get_main_queue(), ^{



});
} else {
// jump back to the main thread to update the UI
dispatch_async(dispatch_get_main_queue(), ^{

NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.megadev.coronacount"];


NSDictionary *s = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:NULL];





if ([prefs integerForKey:@"type"] == 0) {

@try {
cases =[s objectForKey:@"cases"];


}

@catch (NSException *exception) {

}
}


if ([prefs integerForKey:@"type"] == 1) {

@try {
cases =[s objectForKey:@"deaths"];

}

@catch (NSException *exception) {

}
}



if ([prefs integerForKey:@"type"] == 2) {

@try {
cases =[s objectForKey:@"recovered"];

}

@catch (NSException *exception) {

}


}


NSNumberFormatter *formatter = [NSNumberFormatter new];
[formatter setNumberStyle:NSNumberFormatterDecimalStyle]; 

NSString *myString = [formatter stringFromNumber:cases];






dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{


//// Check wether the number is diffirent from the previois fetch
if(cases.intValue > 0){

if(startcases.intValue < cases.intValue){



startcases = cases;

[UIView animateWithDuration:1.0 delay:0.2 options:0 animations:^{
self.label.textColor = [UIColor redColor];
} completion:^(BOOL finished)
{
  self.label.text = [NSString stringWithFormat:@"%@%@", myString, type];


}];


dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

self.label.textColor = statuscolor;
});


}

}


});

});
}
}
];

}

%new
- (void)updatecolor:(NSNotification *) notification{

self.label.textColor = statuscolor;



}
%end



//// update color
%hook _UIStatusBar 

-(void)setForegroundColor:(id)arg1{
%orig;

statuscolor =  MSHookIvar<UIColor *>(self, "_foregroundColor");

  [[NSNotificationCenter defaultCenter] 
  postNotificationName:@"changecolor" 
  object:self];
}


%end


//// Time event for fetching the api Reccomeneded by Smokin1337

%hook SBUIController

- (void)updateBatteryState:(id)arg1 {
%orig;



[[NSNotificationCenter defaultCenter] 
postNotificationName:@"trigger" 
object:self];

}
%end




%end

%ctor {
pfs = [[HBPreferences alloc] initWithIdentifier:@"com.megadev.coronacount"];

[pfs registerBool:&enabled default:YES forKey:@"enabled"];

[pfs registerBool:&customcountry default:NO forKey:@"customcountry"];

[pfs registerObject:&country default:@"USA" forKey:@"country"];

if(enabled){
%init(corona);

}




}