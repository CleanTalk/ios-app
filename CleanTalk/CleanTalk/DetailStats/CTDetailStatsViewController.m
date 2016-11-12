//
//  CTDetailStatsViewController.m
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/13/14.
//  Copyright (c) 2014 CleanTalk. All rights reserved.
//

#import "CTDetailStatsViewController.h"
#import "CTDetailGroupCell.h"
#import "CTRequestHandler.h"

#define HEIGHT_WITHOUT_COMMENT 130.0f
#define HEIGHT_WITHOUT_COMMENT_IPAD 102.0f

#define COMMENT_WIDTH_IPHONE 226.0f
#define COMMENT_HEIGHT_IPHONE 111.0f

#define COMMENT_WIDTH_IPAD 585.0f
#define COMMENT_HEIGHT_IPAD 72.0f

#define MARGIN 26.0f
#define MARGIN_IPAD 20.0f
#define STARTED_Y 76.0f
#define STARTED_Y_IPAD 68.0f
#define SPAM_BUTTON_HEIGHT 30.0f

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
    
    serviceNameLabel.text = _serviceName;
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

- (void)setServiceName:(NSString *)serviceName {
    _serviceName = serviceName;
    serviceNameLabel.text = _serviceName;
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
    lCell.delegate = self;
    lCell.approved = ![[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"approved"] isKindOfClass:[NSNull class]] ?
    [[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"approved"] integerValue] : 2;
    
    if ([[[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"sender_email"] class] isSubclassOfClass:[NSNull class]]) {
        lCell.sender = [NSString stringWithFormat:@"%@",[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"sender_nickname"]];
    } else if ([[[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"sender_nickname"] class] isSubclassOfClass:[NSNull class]] && ![[[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"sender_email"] class] isSubclassOfClass:[NSNull class]]) {
        lCell.sender = [NSString stringWithFormat:@"%@",[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"sender_email"]];
    }else if ([[[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"sender_nickname"] class] isSubclassOfClass:[NSNull class]] && [[[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"sender_email"] class] isSubclassOfClass:[NSNull class]]) {
        lCell.sender = @"";
    } else {
        lCell.sender = [NSString stringWithFormat:@"%@ (%@)",[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"sender_nickname"],[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"sender_email"]];
    }
    
    lCell.type = [[_dataSource objectAtIndex:indexPath.row] valueForKey:@"type"];
    lCell.isSpam = [[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"allow"] boolValue];
    lCell.messageId = [NSString stringWithFormat:@"%@",[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"request_id"]];
    
    if (lCell.approved != 2) {
        [lCell displayReportedLabel:[[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"approved"] boolValue]];
    }
    
    if (![[[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"message"] class] isSubclassOfClass:[NSNull class]]) {
        lCell.comment = [[NSString stringWithFormat:@"%@",[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"message"]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }

    return lCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![[[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"message"] class] isSubclassOfClass:[NSNull class]]) {
        
        NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0]};
        
        NSString *text = [[NSString stringWithFormat:@"%@",[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"message"]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if ([deviceType() isEqualToString:IPHONE]) {
            CGSize constraint = CGSizeMake(COMMENT_WIDTH_IPHONE,CGFLOAT_MAX);
            CGSize size = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            return STARTED_Y + (size.height < SPAM_BUTTON_HEIGHT ? SPAM_BUTTON_HEIGHT : size.height) + MARGIN;
        } else {
            CGSize constraint = CGSizeMake(COMMENT_WIDTH_IPAD,CGFLOAT_MAX);
            CGSize size = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            
            return STARTED_Y_IPAD + (size.height < SPAM_BUTTON_HEIGHT ? SPAM_BUTTON_HEIGHT : size.height) + MARGIN_IPAD;
        }
    } else {
        if ([deviceType() isEqualToString:IPHONE]) {
            return HEIGHT_WITHOUT_COMMENT;
        } else {
            return HEIGHT_WITHOUT_COMMENT_IPAD;
        }
    }
}

#pragma mark - Buttons

- (IBAction)controlPanelPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Cell delegate

- (void)updateStatusForMeesageWithId:(NSString *)messageId newStatus:(BOOL)status {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:NSLocalizedString(@"REPORTED_TITLE", nil)
                                  message:nil
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:NSLocalizedString(@"REPORTED_YES", nil)
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [[CTRequestHandler sharedInstance] changeStatusForMeesageWithId:messageId newStatus:status authKey:_authKey block:^(NSDictionary *response) {
                                 if ([response valueForKey:@"comment"]) {
                                     CTDetailGroupCell *cell = [self getCellForMessageId:messageId];
                                     cell.approved = status ? 1 : 0;
                                     [cell displayReportedLabel:status];
                                 }
                             }];

                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:NSLocalizedString(@"REPORTED_NO", nil)
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (CTDetailGroupCell *)getCellForMessageId:(NSString *)messageId {
    __block CTDetailGroupCell *cell = nil;
    [_dataSource enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj valueForKey:@"request_id"] isEqualToString:messageId]) {
            cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
            *stop = YES;
        }
    }];
    
    return cell;
}
@end
