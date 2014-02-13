//
//  CTDetailStatsViewController.m
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/13/14.
//  Copyright (c) 2014 CleanTalk. All rights reserved.
//

#import "CTDetailStatsViewController.h"
#import "CTDetailGroupCell.h"

#define HEIGHT_WITHOUT_COMMENT 90.0f
#define HEIGHT_WITH_COMMENT 180.0f

@interface CTDetailStatsViewController ()
- (IBAction)controlPanelPressed:(id)sender;
@end

@implementation CTDetailStatsViewController

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
    
    //control panel button
    NSMutableAttributedString *panelTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"PANEL", @"")];
    
    [panelTitle addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, panelTitle.length)];
    [panelTitle addAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} range:NSMakeRange (0, panelTitle.length)];
    
    [controlPanelButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [controlPanelButton setAttributedTitle:panelTitle forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties 

- (void)setDataSource:(NSMutableArray *)dataSource {
    [_dataSource removeAllObjects];
    _dataSource = [NSMutableArray arrayWithArray:dataSource];
    [tableView reloadData];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *lTopLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CTDetailGroupCell" owner:nil options:nil];
    
    CTDetailGroupCell *lCell = (CTDetailGroupCell*)[lTopLevelObjects objectAtIndex:0];
    lCell.time = [[_dataSource objectAtIndex:indexPath.row] valueForKey:@"datetime"];
    lCell.nickName = [[_dataSource objectAtIndex:indexPath.row] valueForKey:@"sender_nickname"];
    lCell.email = [[_dataSource objectAtIndex:indexPath.row] valueForKey:@"sender_email"];
    lCell.type = [[_dataSource objectAtIndex:indexPath.row] valueForKey:@"type"];
    lCell.isSpam = [[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"allow"] boolValue];
    
    if (![[[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"message"] class] isSubclassOfClass:[NSNull class]]) {
        lCell.comment = [[_dataSource objectAtIndex:indexPath.row] valueForKey:@"message"];
    }
    return lCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![[[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"message"] class] isSubclassOfClass:[NSNull class]]) {
        return HEIGHT_WITH_COMMENT;
    } else {
        return HEIGHT_WITHOUT_COMMENT;
    }
}

#pragma mark - Buttons

- (IBAction)controlPanelPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
