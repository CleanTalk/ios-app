//
//  CTDetailStatsViewController.h
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/13/14.
//  Copyright (c) 2014 CleanTalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTDetailStatsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *tableView;
    IBOutlet UIButton *controlPanelButton;
}

@property (nonatomic, strong) NSMutableArray *dataSource;
@end
