// By @CrazyMind90

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AVTools.h"
#import "CrossOverIPC.h"

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



BOOL DidStartServer = NO;
BOOL DidInitButton = NO;
BOOL isSeekingAllowed = NO;


%hook AVPlayerViewController
-(void) viewWillAppear:(BOOL)arg {
  %orig;

  DidInitButton = NO;
}
%end 



void SendNotificationMessage(NSString *Action) {
// CPDistributedMessagingCenter *c = [CPDistributedMessagingCenter centerNamed:@"com.crazymind90.AVTools"];
// rocketbootstrap_distributedmessagingcenter_apply(c);
// [c sendMessageName:@"AVTools" userInfo:@{@"Action" : Action}];
    #define _serviceName @"com.crazymind90.AVTools"
    CrossOverIPC *crossOver = [objc_getClass("CrossOverIPC") centerNamed:_serviceName type:SERVICE_TYPE_SENDER];
    [crossOver sendMessageName:@"AVTools" userInfo:@{@"Action" : Action}];
}

 
%hook SBLockScreenManager 
-(void) lockScreenViewControllerDidDismiss {

  %orig;

  if (![[NSFileManager defaultManager] fileExistsAtPath:MainPlist]) 
  [@{} writeToFile:MainPlist atomically:YES];

  if (!DidStartServer) {
  #define _serviceName @"com.crazymind90.AVTools"
  CrossOverIPC *crossOver = [objc_getClass("CrossOverIPC") centerNamed:_serviceName type:SERVICE_TYPE_LISTENER];
  [crossOver registerForMessageName:@"AVTools" target:self selector:@selector(NotificationAction:userInfo:)];

  DidStartServer = YES;
  }

  WriteToPlist([[%c(SBControlCenterSystemAgent) alloc] isOrientationLocked]);
}

%new
-(void) NotificationAction:(NSString *)Name userInfo:(NSDictionary *)Info {
 
    if ([(NSString *)[Info objectForKey:@"Action"] isEqual:@"Rotate"]) { 
    SBControlCenterSystemAgent *SystemAgent = [[%c(SBControlCenterSystemAgent) alloc] init];
    if ([SystemAgent isOrientationLocked])
    [SystemAgent unlockOrientation];
    else
    [SystemAgent lockOrientation];

    } else {
    
    NSMutableDictionary *MainDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:MainPlist];
    [MainDictionary setValue:(NSString *)Info[@"Action"] forKey:@"SeekTime"];
    [MainDictionary writeToFile:MainPlist atomically:YES];

    }
}
%end

%hook SBControlCenterSystemAgent
-(void) unlockOrientation {
  %orig;
  WriteToPlist(NO);
}
-(void) lockOrientation {
  %orig;
  WriteToPlist(YES);
}
%end



%hook AVTouchIgnoringView 
-(void) layoutSubviews {
 
 %orig;

 if (self.subviews.count <= 0)
 return %orig;

 AVLayoutView *Layout = self.subviews[0];

 if ([Layout isKindOfClass:[%c(AVLayoutView) class]] && [Layout.debugIdentifier isEqual:@"ScreenModeControls"]) {

  if (!DidInitButton) { 

  #pragma mark - RotateButton
  UIButton *RotateButton = InitButtonWithName(@"",self,self,@selector(Button_Tapped:));

  if (isLocked()) { 
  [RotateButton setImage:[UIImage systemImageNamed:@"lock.rotation"] forState:UIControlStateNormal];
  RotateButton.tintColor = UIColor.orangeColor;
  RotateButton.tag = 1;
  } else { 
  [RotateButton setImage:[UIImage systemImageNamed:@"lock.rotation.open"] forState:UIControlStateNormal];
  RotateButton.tintColor = UIColorFromHEX(0x999999);
  RotateButton.tag = 2;
  }

  RotateButton.alpha = 0.8;
  RotateButton.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMinXMaxYCorner;
  RotateButton.layer.cornerRadius = 15.4;
  RotateButton.layer.backgroundColor = UIColorFromHEX(0x181818).CGColor;

  [RotateButton setTranslatesAutoresizingMaskIntoConstraints:false];
  [NSLayoutConstraint activateConstraints:@[
  [RotateButton.topAnchor constraintEqualToAnchor:Layout.bottomAnchor constant:2],
  [RotateButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:0],
  [RotateButton.trailingAnchor constraintEqualToAnchor:self.leadingAnchor constant:60],
  [RotateButton.bottomAnchor constraintEqualToAnchor:Layout.bottomAnchor constant:49]
  ]];

  #pragma mark - Lock image layout
  [RotateButton.imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [RotateButton.imageView.topAnchor constraintEqualToAnchor:RotateButton.topAnchor constant:11].active = YES;
  [RotateButton.imageView.leadingAnchor constraintEqualToAnchor:RotateButton.leadingAnchor constant:16].active = YES;
  [RotateButton.imageView.trailingAnchor constraintEqualToAnchor:RotateButton.trailingAnchor constant:-16].active = YES;
  [RotateButton.imageView.bottomAnchor constraintEqualToAnchor:RotateButton.bottomAnchor constant:-11].active = YES;


  #pragma mark - SeekButton
  float SeekTime = [[[NSMutableDictionary dictionaryWithContentsOfFile:MainPlist] objectForKey:@"SeekTime"] floatValue];
  if (SeekTime <= 0)
  SendNotificationMessage(@"15");

  UIButton *SeekButton = InitButtonWithName([NSMutableDictionary dictionaryWithContentsOfFile:MainPlist][@"SeekTime"],self,self,@selector(SeekButton_Tapped:));

  SeekButton.alpha = 0.8;
  SeekButton.layer.maskedCorners = kCALayerMaxXMaxYCorner | kCALayerMaxXMinYCorner;
  SeekButton.layer.cornerRadius = 15.4;
  SeekButton.layer.backgroundColor = UIColorFromHEX(0x303030).CGColor;

  [SeekButton setTranslatesAutoresizingMaskIntoConstraints:false];
  [NSLayoutConstraint activateConstraints:@[
  [SeekButton.topAnchor constraintEqualToAnchor:Layout.bottomAnchor constant:2],
  [SeekButton.leadingAnchor constraintEqualToAnchor:RotateButton.trailingAnchor constant:0],
  [SeekButton.trailingAnchor constraintEqualToAnchor:RotateButton.trailingAnchor constant:60],
  [SeekButton.bottomAnchor constraintEqualToAnchor:Layout.bottomAnchor constant:49]
  ]];

  DidInitButton = YES;
   }
 }
}

%new 
-(void) SeekButton_Tapped:(UIButton *)Sender {

  [CMManagerMini InitTextFieldAlertWithTitle:@"Set skip time" Message:nil Buttons:@[@"Set"] CancelButtonTitle:@"Cancel" handler:^(NSString * ButtonTitle, NSString * Text, UITextField * TextField) {

    TextField.keyboardType = UIKeyboardTypeNumberPad;
    TextField.text = (NSString *)[[NSMutableDictionary dictionaryWithContentsOfFile:MainPlist] objectForKey:@"SeekTime"];

    if ([ButtonTitle isEqual:@"Set"]) {

    [Sender setTitle:Text forState:UIControlStateNormal];

    SendNotificationMessage([NSString stringWithFormat:@"%@",Text] ? : @"10");

    }

    }];
  
}

%new
-(void) Button_Tapped:(UIButton *)Sender {
    
    SendNotificationMessage(@"Rotate");

    if (Sender.tag == 1) {
    [Sender setImage:[UIImage systemImageNamed:@"lock.rotation.open"] forState:UIControlStateNormal];
    Sender.tintColor = UIColorFromHEX(0x999999);
    Sender.tag = 2;
    } else {
    [Sender setImage:[UIImage systemImageNamed:@"lock.rotation"] forState:UIControlStateNormal];
    Sender.tintColor = UIColor.orangeColor;
    Sender.tag = 1;
    }
}

%end
 







%hook AVPlaybackControlsController
- (void)skipButtonTouchUpInside:(id)Sender {
    %orig;

    float SeekTime = [[[NSMutableDictionary dictionaryWithContentsOfFile:MainPlist] objectForKey:@"SeekTime"] floatValue];
    if (SeekTime <= 0)
    SeekTime = 15;

    AVButton *avbutton = Sender;
    isSeekingAllowed = YES;
    if ([avbutton.imageName.lowercaseString containsString:@"forward"])
    [self _seekByTimeInterval:SeekTime toleranceBefore:0.5 toleranceAfter:0.5];
    else 
    [self _seekByTimeInterval:-SeekTime toleranceBefore:0.5 toleranceAfter:0.5];
}
- (void)_seekByTimeInterval:(double)arg1 toleranceBefore:(double)arg2 toleranceAfter:(double)arg3 {

    if (isSeekingAllowed) {
    isSeekingAllowed = NO;
    return %orig;
    }
    return;
}
%end














// 
