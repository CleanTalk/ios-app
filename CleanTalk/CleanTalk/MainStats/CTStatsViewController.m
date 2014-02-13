//
//  CTMainStatsViewController.m
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/8/14.
//  Copyright (c) 2014 CleanTalk. All rights reserved.
//

#import "CTStatsViewController.h"
#import "CTRequestHandler.h"
#import "CTLoginViewController.h"
#import "CTStatsCell.h"
#import "CTDetailStatsViewController.h"

#define CELL_HEIGHT 146.0f
#define TIMER_VALUE 1800.0f

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
        detailStatsDictionary = [NSMutableDictionary new];
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
    
    //load data
    tableView.separatorColor = [UIColor clearColor];
    [self refreshPressed:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [tableView reloadData];
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
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *lTopLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CTStatsCell" owner:nil options:nil];

    CTStatsCell *lCell = (CTStatsCell*)[lTopLevelObjects objectAtIndex:0];
    lCell.delegate = self;
    lCell.siteName = [[dataSource objectAtIndex:indexPath.row] valueForKey:@"hostname"];
    lCell.imageUrl = [NSString stringWithFormat:@"http://%@.com/favicon.ico",[[dataSource objectAtIndex:indexPath.row] valueForKey:@"hostname"]];
    if ([[[detailStatsDictionary objectForKey:[[dataSource objectAtIndex:indexPath.row] valueForKey:@"service_id"]] objectForKey:@"requests"] count] > 0) {
        lCell.newmessages = [NSString stringWithFormat:@"%d",[[[detailStatsDictionary objectForKey:[[dataSource objectAtIndex:indexPath.row] valueForKey:@"service_id"]] objectForKey:@"requests"] count]];
    }
    [lCell displayStats:[dataSource objectAtIndex:indexPath.row]];
    return lCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

#pragma mark - Buttons 

- (IBAction)logoutPressed:(id)sender {
    setVal(IS_USER_ALREADY_LOGIN, [NSNumber numberWithBool:NO]);
    
    BOOL isFind = NO;
    for (NSUInteger i=0; i<[[self.navigationController viewControllers] count]; i++) {
        if ([[[self.navigationController.viewControllers objectAtIndex:i] class] isSubclassOfClass:[CTLoginViewController class]]) {
            isFind = YES;
            break;
        }
    }
    
    if (isFind) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
         CTLoginViewController *loginViewController = [[CTLoginViewController alloc] initWithNibName:@"CTLoginViewController" bundle:nil];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
}

- (IBAction)refreshPressed:(id)sender {
    
    if ([timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
        
    [[CTRequestHandler sharedInstance] mainStats:^(NSDictionary *response) {
        if ([[response valueForKey:@"auth"] isEqualToNumber:[NSNumber numberWithInteger:1]]) {
            [dataSource removeAllObjects];
            if ([[[response objectForKey:@"services"] class] isSubclassOfClass:[NSArray class]]) {
                dataSource = [NSMutableArray arrayWithArray:[response objectForKey:@"services"]];
                [tableView reloadData];
                timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_VALUE target:self selector:@selector(refreshPressed:) userInfo:nil repeats:YES];
                
                 [self loadDetailStatForIndex:0];
            }
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", @"") message:NSLocalizedString(@"ERROR", @"") delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

- (IBAction)goToWebSitePressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:API_URL]];
}

#pragma mark - StatsCell Delegate

- (void)goToDetailStats:(NSString*)service {
    NSString *key = [NSString stringWithFormat:@"%@_%@",TIME_INTERVAL,service];
    
    CTDetailStatsViewController *detailStatsViewController = [[CTDetailStatsViewController alloc] initWithNibName:@"CTDetailStatsViewController" bundle:nil];
    detailStatsViewController.dataSource = [[detailStatsDictionary objectForKey:service] objectForKey:@"requests"];
    [self.navigationController pushViewController:detailStatsViewController animated:YES];
    
    setVal(key, [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]);
    [detailStatsDictionary setObject:[NSDictionary dictionaryWithObject:[NSArray new] forKey:@"requests"] forKey:service];
}

#pragma mark - Detail Stats

- (void)loadDetailStatForIndex:(NSInteger)index {
    __block NSInteger indexNumber = index;
    
    if (index < dataSource.count) {
        NSString *key = [NSString stringWithFormat:@"%@_%@",TIME_INTERVAL,[[dataSource objectAtIndex:index]valueForKey:@"service_id"]];
        [[CTRequestHandler sharedInstance] detailStatForCurrentService:[[dataSource objectAtIndex:index] valueForKey:@"service_id"] time:[getVal(key) floatValue] andBlock:^(NSDictionary *response) {
            
            [detailStatsDictionary setObject:response forKey:[[dataSource objectAtIndex:index] valueForKey:@"service_id"]];
            
            indexNumber ++;
            [self loadDetailStatForIndex:indexNumber];
        }];
    } else {
        [tableView reloadData];
    }
}
@end
