//
//  CTLoginViewController.h
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/8/14.
//  Copyright (c) 2014 CleanTalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTLoginViewController : UIViewController <UITextFieldDelegate> {
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *registrationButton;
    IBOutlet UIButton *renewPasswordButton;
    
    IBOutlet UITextField *emailTextField;
    IBOutlet UITextField *passwordTextField;
    
    BOOL isScroll;
}

@end
