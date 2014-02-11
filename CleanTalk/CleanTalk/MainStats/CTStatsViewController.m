//
//  CTMainStatsViewController.m
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/8/14.
//  Copyright (c) 2014 CleanTalk. All rights reserved.
//

#import "CTStatsViewController.h"
#import "CTRequestHandler.h"

@interface CTStatsViewController ()

- (IBAction)logoutPressed:(id)sender;
- (IBAction)refreshPressed:(id)sender;
- (IBAction)goToWebSitePressed:(id)sender;
@end

@implementation CTStatsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    //display navigation bar
    self.navigationController.navigationBarHidden = YES;
    
    //add border
    refreshButton.layer.borderWidth = 2.0f;
    refreshButton.layer.borderColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0].CGColor;
    refreshButton.layer.cornerRadius = 4.0f;
    [refreshButton setTitle:NSLocalizedString(@"REFRESH", @"") forState:UIControlStateNormal];
    
    //registration button
    NSMutableAttributedString *siteTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"SITE", @"")];
    
    [siteTitle addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, siteTitle.length)];
    [siteTitle addAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} range:NSMakeRange (0, siteTitle.length)];
    
    [siteButton.titleLabel setTextAlignment:NSTextAlignmentRight];
    [siteButton setAttributedTitle:siteTitle forState:UIControlStateNormal];
    
    //reset password button
    NSMutableAttributedString *logoutTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"LOGOUT", @"")];
    [logoutTitle addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, logoutTitle.length)];
    [logoutTitle addAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} range:NSMakeRange (0, logoutTitle.length)];
    
    [logountButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [logountButton setAttributedTitle:logoutTitle forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - Buttons 

- (IBAction)logoutPressed:(id)sender {
    setVal(IS_USER_ALREADY_LOGIN, [NSNumber numberWithBool:NO]);
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)refreshPressed:(id)sender {
    [[CTRequestHandler sharedInstance] mainStats:^(NSDictionary *response) {
        DLog(@"responce %@",response);
    }];
}

- (IBAction)goToWebSitePressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:API_URL]];
}

@end
