//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#import "AppDelegate.h"
#import "AppBoard_iPhone.h"
#import "AppBoard_iPad.h"
#import "LoginAndRegister.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WBApi.h"
#import <RennSDK/RennSDK.h>
#import "WeiboSDK.h"
#import "StartupController.h"


#pragma mark -

@implementation AppDelegate

/*
- (CAAnimation *)animationWithType:(KYNaviAnimationType)animationType direction:(KYNaviAnimationDirection)direction{
    CATransition *animation = [CATransition animation];
    [animation setDuration:kAnimationDuration];
    switch (animationType) {
        case KYNaviAnimationTypeFade:
            animation.type = kCATransitionFade; //淡化
            break;
        case KYNaviAnimationTypePush:
            animation.type = kCATransitionPush; //推挤
            break;
        case KYNaviAnimationTypeReveal:
            animation.type = kCATransitionReveal; //揭开
            break;
        case KYNaviAnimationTypeMoveIn:
            animation.type = kCATransitionMoveIn;//覆盖
            break;
        case KYNaviAnimationTypeCube:
            animation.type = @"cube";   //立方体
            break;
        case KYNaviAnimationTypeSuck:
            animation.type = @"suckEffect"; //吸收
            break;
        case KYNaviAnimationTypeSpin:
            animation.type = @"oglFlip";    //旋转
            break;
        case KYNaviAnimationTypeRipple:
            animation.type = @"rippleEffect";   //波纹
            break;
        case KYNaviAnimationTypePageCurl:
            animation.type = @"pageCurl";   //翻页
            break;
        case KYNaviAnimationTypePageUnCurl:
            animation.type = @"pageUnCurl"; //反翻页
            break;
        case KYNaviAnimationTypeCameraOpen:
            animation.type = @"cameraIrisHollowOpen";   //镜头开
            break;
        case KYNaviAnimationTypeCameraClose:
            animation.type = @"cameraIrisHollowClose";  //镜头关
            break;
        default:
            animation.type = kCATransitionPush; //推挤
            break;
    }
    
    switch (direction) {
        case KYNaviAnimationDirectionFromLeft:
            animation.subtype = kCATransitionFromLeft;
            break;
        case KYNaviAnimationDirectionFromRight:
            animation.subtype = kCATransitionFromRight;
            break;
        case KYNaviAnimationDirectionFromTop:
            animation.subtype = kCATransitionFromTop;
            break;
        case KYNaviAnimationDirectionFromBottom:
            animation.subtype = kCATransitionFromBottom;
            break;
        default:
            animation.subtype = kCATransitionFromRight;
            break;
    }
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    return animation;
}
*/
- (void)load
{
    StartupController* startup = [[StartupController alloc]init : self];
    self.window.rootViewController = startup;

    [UIApplication sharedApplication].statusBarHidden = YES;
    
    //[UIApplication sharedApplication].keyWindow.layer addAnimation:<#(CAAnimation *)#> forKey:<#(NSString *)#>
}

- (void)unload
{
	
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    //[super handleOpenURL:url];
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication
                        annotation:annotation wxDelegate:self];
}

@end
