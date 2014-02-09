//
//  Global.h
//  OpenCloseTime
//
//  Created by Oleg.Sehelin on 5/23/13.
//  Copyright (c) 2013 Vakoms. All rights reserved.
//

#ifndef Resume_Global_h
#define Resume_Global_h

typedef enum {
    OCTEditButton,
    OCTGroupButton,
    OCTSortButton
}OCTOptionsBarButton;


//add -DDEBUG flag to c flags
#ifdef DEBUG
# define DLog(...) NSLog(__VA_ARGS__)
#else
# define DLog(...) /* */
#endif
#define ALog(...) NSLog(__VA_ARGS__)

//Getting device name
#define IPHONE @"iPhone"
#define IPAD @"iPad"

CG_INLINE NSString *deviceType()
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	if( UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM() )
		return IPAD;
	else
		return IPHONE;
#else
	return IPHONE;
#endif
}

// detect iPhone 5
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

// iPhone 5 support
#define ASSET_BY_SCREEN_HEIGHT(regular, longScreen) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : longScreen)

//Getting is device IOS6
CG_INLINE BOOL isIOS6()
{
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
		return TRUE;
	else
		return FALSE;
}

#define getVal(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define setVal(key,val) [[NSUserDefaults standardUserDefaults] setObject:val forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]

#define REGISTRATION_URL @"https://cleantalk.org/register"
#define RENEW_PASSWORD_URL @"https://cleantalk.org/my/reset_password"
#define API_URL @"https://cleantalk.org/"

#define IS_USER_ALREADY_LOGIN @"user_login"
#endif

