
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#pragma GCC diagnostic ignored "-Wunused-variable"
#pragma GCC diagnostic ignored "-Wprotocol"
#pragma GCC diagnostic ignored "-Wmacro-redefined"
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
#pragma GCC diagnostic ignored "-Wincomplete-implementation"
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma GCC diagnostic ignored "-Wformat"
#pragma GCC diagnostic ignored "-Wunknown-warning-option"
#pragma GCC diagnostic ignored "-Wincompatible-pointer-types"
#pragma GCC diagnostic ignored "-Wunused-value"
#pragma GCC diagnostic ignored "-Wnullability-completeness"


#define rgbValue
#define UIColorFromHEX(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

 
static UIViewController *_topMostController(UIViewController *cont) {
UIViewController *topController = cont;
 while (topController.presentedViewController) {
 topController = topController.presentedViewController;
 }
 if ([topController isKindOfClass:[UINavigationController class]]) {
 UIViewController *visible = ((UINavigationController *)topController).visibleViewController;
 if (visible) {
topController = visible;
 }
}
 return (topController != cont ? topController : nil);
 }
 static UIViewController *topMostController() {
 UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
 UIViewController *next = nil;
  while ((next = _topMostController(topController)) != nil) {
 topController = next;
 }
 return topController;
}


void WriteData(id Data, NSString *DataFileName) {

    NSString *StringOfDate = [NSString stringWithFormat:@"%@",Data];

    NSString *DataFile = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),DataFileName];

    if (![[NSFileManager defaultManager] fileExistsAtPath:DataFile])
    [[NSFileManager defaultManager] createFileAtPath:DataFile contents:nil attributes:nil];

    NSString *PrevData = [NSString stringWithContentsOfFile:DataFile encoding:NSUTF8StringEncoding error:nil];

    NSString *NewData = [NSString stringWithFormat:@"%@\n\n-----------\n\n%@",PrevData,StringOfDate];

    [NewData writeToFile:DataFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
}



void Alert(float Timer,id Message, ...) {

    va_list args;
    va_start(args, Message);
    NSString *Formated = [[NSString alloc] initWithFormat:Message arguments:args];
    va_end(args);

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

    [NSThread sleepForTimeInterval:Timer];

    dispatch_async(dispatch_get_main_queue(), ^{

		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Hola" message:Formated preferredStyle:UIAlertControllerStyleAlert];

		UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		}];

		[alert addAction:action];

		[topMostController() presentViewController:alert animated:true completion:nil];
 

        });

    });

}
 



@interface CMManagerMini : NSObject
+(void) InitTextFieldAlertWithTitle:(NSString *)Title Message:(NSString *)Message Buttons:(NSArray *)Buttons CancelButtonTitle:(NSString *)CancelButtonTitle handler:(void(^_Nullable)(NSString * ButtonTitle, NSString * Text, UITextField * TextField))handler;
@end 

@implementation CMManagerMini

+(void) InitTextFieldAlertWithTitle:(NSString *)Title Message:(NSString *)Message Buttons:(NSArray *)Buttons CancelButtonTitle:(NSString *)CancelButtonTitle handler:(void(^)(NSString *  ButtonTitle, NSString * Text, UITextField * TextField))handler {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:Title message:Message preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textField resignFirstResponder];
    handler(nil,nil,textField);
    }];
    for (NSString *EachButton in Buttons) {
    NSArray *fields = alert.textFields;
    UITextField *getText = [fields firstObject];
    UIAlertAction *action = [UIAlertAction actionWithTitle:EachButton style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    handler(action.title,getText.text,nil);
    }];
    [alert addAction:action];
    }
    if (!(CancelButtonTitle == NULL)) {
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CancelButtonTitle  style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alert addAction:cancelAction];
    }
    [topMostController() presentViewController:alert animated:true completion:nil];
}
@end


 
 
UIButton *InitButtonWithName(NSString *BuName, UIView *View, id Target,SEL Action){

UIButton *Button = [UIButton buttonWithType:UIButtonTypeCustom];
[Button setTitle:BuName forState:UIControlStateNormal];
[Button addTarget:Target action:Action forControlEvents:UIControlEventTouchUpInside];
[View addSubview:Button];

  return Button;
}
 

#define MainPlist @"/var/jb/var/mobile/Library/Preferences/AVTools.plist"

void WriteToPlist(BOOL isLock) {

  NSMutableDictionary *MainDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:MainPlist];
  isLock ? [MainDictionary setValue:@"1" forKey:@"isLock"] : [MainDictionary setValue:@"2" forKey:@"isLock"];

  if (!MainDictionary[@"SeekTime"])
  [MainDictionary setValue:@"15" forKey:@"SeekTime"];

  [MainDictionary writeToFile:MainPlist atomically:YES];
}

BOOL isLocked(void) {
  if ([[NSMutableDictionary dictionaryWithContentsOfFile:MainPlist][@"isLock"] isEqual:@"1"]) return YES;
  return NO;
}

 

@interface SBControlCenterSystemAgent : NSObject
-(void) unlockOrientation;
-(void) lockOrientation;
-(BOOL) isOrientationLocked;
@end

@interface SBLockScreenManager : NSObject
-(void) NotificationAction:(NSString *)Name userInfo:(NSDictionary *)Info;
@end

@interface AVPlayerViewController : UIViewController
@end

@interface AVLayoutView : UIView
@property NSString *debugIdentifier;
@end


@interface AVTouchIgnoringView : UIView
@end
 
@interface AVPlaybackControlsController : NSObject
-(void)_seekByTimeInterval:(double)arg1 toleranceBefore:(double)arg2 toleranceAfter:(double)arg3;
@end 

@interface AVButton : NSObject
@property NSString *imageName;
@end 
