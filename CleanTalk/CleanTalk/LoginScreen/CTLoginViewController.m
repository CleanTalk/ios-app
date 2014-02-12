//
//  CTLoginViewController.m
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/8/14.
//  Copyright (c) 2014 CleanTalk. All rights reserved.
//

#import "CTLoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CTRequestHandler.h"
#import "CTStatsViewController.h"

#define SCROLL_DIF 30.0f

@interface CTLoginViewController ()
- (IBAction)loginPressed:(id)sender;
- (IBAction)registerNewUserPressed:(id)sender;
- (IBAction)resetPasswordPressed:(id)sender;
@end

@implementation CTLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
        
    //add border
    loginButton.layer.borderWidth = 2.0f;
    loginButton.layer.borderColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0].CGColor;
    loginButton.layer.cornerRadius = 4.0f;
    
    //registration button
    NSMutableAttributedString *registrationTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"REGISTRATION", @"")];

    [registrationTitle addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, registrationTitle.length)];
    [registrationTitle addAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} range:NSMakeRange (0, registrationTitle.length)];

    [registrationButton.titleLabel setTextAlignment:NSTextAlignmentRight];
    [registrationButton setAttributedTitle:registrationTitle forState:UIControlStateNormal];
    
    //reset password button
    NSMutableAttributedString *resetTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FORGOT_PASSWORD", @"")];
    [resetTitle addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, resetTitle.length)];
    [resetTitle addAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} range:NSMakeRange (0, resetTitle.length)];
    
    [renewPasswordButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [renewPasswordButton setAttributedTitle:resetTitle forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 0) {
        [emailTextField resignFirstResponder];
        [passwordTextField becomeFirstResponder];
        return  YES;
    } else {
        [passwordTextField resignFirstResponder];
        
        if (isScroll)
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame = (CGRect){self.view.frame.origin.x, self.view.frame.origin.y + SCROLL_DIF, self.view.frame.size.width, self.view.frame.size.height};
                isScroll = NO;
            }];

        return YES;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (!isScroll)
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = (CGRect){self.view.frame.origin.x, self.view.frame.origin.y - SCROLL_DIF, self.view.frame.size.width, self.view.frame.size.height};
            isScroll = YES;
        }];
    
    return YES;
}

#pragma mark - Buttons methods

- (IBAction)loginPressed:(id)sender {
    [[CTRequestHandler sharedInstance] loginWithName:emailTextField.text password:passwordTextField.text completionBlock:^(NSDictionary *response) {
        
        DLog(@"responce %@",response);
        if ([[response valueForKey:@"success"] isEqualToNumber:[NSNumber numberWithInteger:1]]) {
            
            setVal(IS_USER_ALREADY_LOGIN, [NSNumber numberWithBool:YES]);
            setVal(APP_SESSION_ID, [response valueForKey:@"app_session_id"]);
            
            CTStatsViewController *mainController = [[CTStatsViewController alloc] initWithNibName:@"CTStatsViewController" bundle:nil];
            [self.navigationController pushViewController:mainController animated:YES];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", @"") message:NSLocalizedString(@"ERROR_MESSAGE", @"") delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

- (IBAction)registerNewUserPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:REGISTRATION_URL]];
}

- (IBAction)resetPasswordPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RENEW_PASSWORD_URL]];
}

@end
