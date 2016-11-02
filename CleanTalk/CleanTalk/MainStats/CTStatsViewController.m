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
#define SECONDS_PER_DAY 86400.0f

@interface CTStatsViewController ()
@property (nonatomic, assign) NSInteger pageNumber;

- (IBAction)logoutPressed:(id)sender;
- (IBAction)refreshPressed:(id)sender;
- (IBAction)goToWebSitePressed:(id)sender;
@end

static NSInteger kLoadingCellNumber = 9;

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

    _pageNumber = 1;
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
    lCell.tag = indexPath.row;
    NSLog(@"row %@ %ld",[[dataSource objectAtIndex:indexPath.row] valueForKey:@"servicename"], indexPath.row);
    if (![[[dataSource objectAtIndex:indexPath.row] valueForKey:@"servicename"] isKindOfClass:[NSNull class]]) {
        lCell.siteName = [[dataSource objectAtIndex:indexPath.row] valueForKey:@"servicename"];
    }
    
    if (![[[dataSource objectAtIndex:indexPath.row] valueForKey:@"favicon_url"] isKindOfClass:[NSNull class]]) {
        lCell.imageUrl = [[dataSource objectAtIndex:indexPath.row] valueForKey:@"favicon_url"];
    }
    
    if ([[[detailStatsDictionary objectForKey:[[dataSource objectAtIndex:indexPath.row] valueForKey:@"service_id"]] objectForKey:@"requests"] count] > 0) {
        lCell.newmessages = [NSString stringWithFormat:@"%lu",(unsigned long)[[[detailStatsDictionary objectForKey:[[dataSource objectAtIndex:indexPath.row] valueForKey:@"service_id"]] objectForKey:@"requests"] count]];
    } else {
        lCell.newmessages = nil;
    }
    
    [lCell displayStats:[dataSource objectAtIndex:indexPath.row]];
    return lCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % kLoadingCellNumber == 0 && indexPath.row != 0 && dataSource.count % 10 == 0) {
        _pageNumber++;
        [self refreshPressed:nil];
    }
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
    
    if (sender) {
        _pageNumber = 1;
    }
    
    if (!progressHud) {
        progressHud = [[MBProgressHUD alloc] initWithFrame:self.view.frame];
        [self.view addSubview:progressHud];
    }
    
    [progressHud show:YES];
    
    [[CTRequestHandler sharedInstance] mainStatsWithPageNumber:_pageNumber block:^(NSDictionary *response) {
        if ([[response valueForKey:@"auth"] isEqualToNumber:[NSNumber numberWithInteger:1]]) {

            if ([[[response objectForKey:@"services"] class] isSubclassOfClass:[NSArray class]]) {
                if (_pageNumber == 1) {
                    [dataSource removeAllObjects];
                    dataSource = [NSMutableArray arrayWithArray:[response objectForKey:@"services"]];
                    [tableView reloadData];
                } else {
                    [[response objectForKey:@"services"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (![self isSourceContainselementWithId:[obj valueForKey:@"service_id"]]) {
                            [dataSource addObject:obj];
                            [tableView beginUpdates];
                            [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:dataSource.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                            [tableView endUpdates];
                        }
                    }];
                }
                
                timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_VALUE target:self selector:@selector(refreshPressed:) userInfo:nil repeats:YES];
                
                 [self loadDetailStatForIndex:0];
            }
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", @"") message:NSLocalizedString(@"ERROR", @"") delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

- (BOOL)isSourceContainselementWithId:(NSString *)serviceID {
    __block BOOL result = NO;
    [dataSource enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj valueForKey:@"service_id"] isEqualToString:serviceID]) {
            result = YES;
            *stop = YES;
        }
    }];
    
    return result;
}

- (IBAction)goToWebSitePressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:API_URL]];
}

#pragma mark - StatsCell Delegate

- (void)goToDetailStats:(NSString*)service andTag:(NSNumber*)tag{
    if (!progressHud) {
        progressHud = [[MBProgressHUD alloc] initWithFrame:self.view.frame];
        [self.view addSubview:progressHud];
    }
    
    [progressHud show:YES];
    
    NSString *key = [NSString stringWithFormat:@"%@_%@",TIME_INTERVAL,service];
    
    CTDetailStatsViewController *detailStatsViewController = [[CTDetailStatsViewController alloc] initWithNibName:@"CTDetailStatsViewController" bundle:nil];
    detailStatsViewController.dataSource = [[detailStatsDictionary objectForKey:service] objectForKey:@"requests"];
    [self.navigationController pushViewController:detailStatsViewController animated:YES];
    [progressHud hide:YES];
    detailStatsViewController.serviceName = [[dataSource objectAtIndex:[tag integerValue]] valueForKey:@"servicename"];
    
    setVal(key, [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]);
    [detailStatsDictionary setObject:[NSDictionary dictionaryWithObject:[NSArray new] forKey:@"requests"] forKey:service];
}

- (void)openStatsForPeriod:(NSNumber*)tag forId:(NSArray*)service {
    if (!progressHud) {
        progressHud = [[MBProgressHUD alloc] initWithFrame:self.view.frame];
        [self.view addSubview:progressHud];
    }
    
    [progressHud show:YES];

    switch ([tag integerValue]) {
        case 30: {
            //get start of the day date
            
            // Get the year, month, day from the date
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
            
            // Set the hour, minute, second to be zero
            components.hour = 0;
            components.minute = 0;
            components.second = 0;
            
            // Create the date
            NSDate *startDate = [[NSCalendar currentCalendar] dateFromComponents:components];
            
            [[CTRequestHandler sharedInstance] detailStatForCurrentService:[service objectAtIndex:0] time:[startDate timeIntervalSince1970] day:1 allowed:NO andBlock:^(NSDictionary *response) {
                
                CTDetailStatsViewController *detailStatsViewController = [[CTDetailStatsViewController alloc] initWithNibName:@"CTDetailStatsViewController" bundle:nil];
                detailStatsViewController.dataSource = [response objectForKey:@"requests"];
                detailStatsViewController.serviceName = [[dataSource objectAtIndex:[[service objectAtIndex:1] integerValue]] valueForKey:@"servicename"];
                [self.navigationController pushViewController:detailStatsViewController animated:YES];
                [progressHud hide:YES];
            }];
            break;

        }
            
        case 31: {
            //get start of the day date
            
            // Get the year, month, day from the date
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
            
            // Set the hour, minute, second to be zero
            components.hour = 0;
            components.minute = 0;
            components.second = 0;
            
            // Create the date
            NSDate *startDate = [[NSCalendar currentCalendar] dateFromComponents:components];
            
            [[CTRequestHandler sharedInstance] detailStatForCurrentService:[service objectAtIndex:0] time:[startDate timeIntervalSince1970] day:1 allowed:YES andBlock:^(NSDictionary *response) {
                
                CTDetailStatsViewController *detailStatsViewController = [[CTDetailStatsViewController alloc] initWithNibName:@"CTDetailStatsViewController" bundle:nil];
                detailStatsViewController.dataSource = [response objectForKey:@"requests"];
                detailStatsViewController.serviceName = [[dataSource objectAtIndex:[[service objectAtIndex:1] integerValue]] valueForKey:@"servicename"];
                [self.navigationController pushViewController:detailStatsViewController animated:YES];
                [progressHud hide:YES];
            }];
            break;
            
        }
        case 40: {
            // Get the year, month, day from the date
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[[NSDate date] dateByAddingTimeInterval: -SECONDS_PER_DAY]];
            
            // Set the hour, minute, second to be zero
            components.hour = 0;
            components.minute = 0;
            components.second = 0;
            
            // Create the date
            NSDate *startDate = [[NSCalendar currentCalendar] dateFromComponents:components];

            [[CTRequestHandler sharedInstance] detailStatForCurrentService:[service objectAtIndex:0] time:[startDate timeIntervalSince1970] day:1 allowed:NO andBlock:^(NSDictionary *response) {
                
                CTDetailStatsViewController *detailStatsViewController = [[CTDetailStatsViewController alloc] initWithNibName:@"CTDetailStatsViewController" bundle:nil];
                detailStatsViewController.dataSource = [response objectForKey:@"requests"];
                detailStatsViewController.serviceName = [[dataSource objectAtIndex:[[service objectAtIndex:1] integerValue]] valueForKey:@"servicename"];
                [self.navigationController pushViewController:detailStatsViewController animated:YES];
                [progressHud hide:YES];
            }];
            break;
        }
            
        case 41: {
            // Get the year, month, day from the date
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[[NSDate date] dateByAddingTimeInterval: -SECONDS_PER_DAY]];
            
            // Set the hour, minute, second to be zero
            components.hour = 0;
            components.minute = 0;
            components.second = 0;
            
            // Create the date
            NSDate *startDate = [[NSCalendar currentCalendar] dateFromComponents:components];

            
            [[CTRequestHandler sharedInstance] detailStatForCurrentService:[service objectAtIndex:0] time:[startDate timeIntervalSince1970] day:1 allowed:YES andBlock:^(NSDictionary *response) {
                
                CTDetailStatsViewController *detailStatsViewController = [[CTDetailStatsViewController alloc] initWithNibName:@"CTDetailStatsViewController" bundle:nil];
                detailStatsViewController.dataSource = [response objectForKey:@"requests"];
                detailStatsViewController.serviceName = [[dataSource objectAtIndex:[[service objectAtIndex:1] integerValue]] valueForKey:@"servicename"];
                [self.navigationController pushViewController:detailStatsViewController animated:YES];
                [progressHud hide:YES];
            }];
            break;
        }

        case 50: {
         
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[[NSDate date] dateByAddingTimeInterval: -(SECONDS_PER_DAY*7)]];
            
            // Set the hour, minute, second to be zero
            components.hour = 0;
            components.minute = 0;
            components.second = 0;
            
            // Create the date
            NSDate *startDate = [[NSCalendar currentCalendar] dateFromComponents:components];

            [[CTRequestHandler sharedInstance] detailStatForCurrentService:[service objectAtIndex:0] time:[startDate timeIntervalSince1970] day:7 allowed:NO andBlock:^(NSDictionary *response) {
                
                CTDetailStatsViewController *detailStatsViewController = [[CTDetailStatsViewController alloc] initWithNibName:@"CTDetailStatsViewController" bundle:nil];
                detailStatsViewController.dataSource = [response objectForKey:@"requests"];
                detailStatsViewController.serviceName = [[dataSource objectAtIndex:[[service objectAtIndex:1] integerValue]] valueForKey:@"servicename"];
                [self.navigationController pushViewController:detailStatsViewController animated:YES];
                [progressHud hide:YES];
            }];
            break;
        }
            
        case 51: {
            
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[[NSDate date] dateByAddingTimeInterval: -(SECONDS_PER_DAY*7)]];
            
            // Set the hour, minute, second to be zero
            components.hour = 0;
            components.minute = 0;
            components.second = 0;
            
            // Create the date
            NSDate *startDate = [[NSCalendar currentCalendar] dateFromComponents:components];

            [[CTRequestHandler sharedInstance] detailStatForCurrentService:[service objectAtIndex:0] time:[startDate timeIntervalSince1970] day:7 allowed:YES andBlock:^(NSDictionary *response) {
                
                CTDetailStatsViewController *detailStatsViewController = [[CTDetailStatsViewController alloc] initWithNibName:@"CTDetailStatsViewController" bundle:nil];
                detailStatsViewController.dataSource = [response objectForKey:@"requests"];
                detailStatsViewController.serviceName = [[dataSource objectAtIndex:[[service objectAtIndex:1] integerValue]] valueForKey:@"servicename"];
                [self.navigationController pushViewController:detailStatsViewController animated:YES];
                [progressHud hide:YES];
            }];
            break;
        }

        default:
            break;
    }
}
#pragma mark - Detail Stats

- (void)loadDetailStatForIndex:(NSInteger)index {
    __block NSInteger indexNumber = index;
    
    if (index < dataSource.count) {
        NSString *key = [NSString stringWithFormat:@"%@_%@",TIME_INTERVAL,[[dataSource objectAtIndex:index]valueForKey:@"service_id"]];
        [[CTRequestHandler sharedInstance] detailStatForCurrentService:[[dataSource objectAtIndex:index] valueForKey:@"service_id"] time:[getVal(key) floatValue] andBlock:^(NSDictionary *response) {
            
            if (response) {
                [detailStatsDictionary setObject:response forKey:[[dataSource objectAtIndex:index] valueForKey:@"service_id"]];
            }
            
            indexNumber ++;
            [self loadDetailStatForIndex:indexNumber];
        }];
    } else {
        [progressHud hide:YES];
        [tableView reloadData];
    }
}
@end
