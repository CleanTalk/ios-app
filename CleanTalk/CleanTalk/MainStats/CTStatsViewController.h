//
//  CTMainStatsViewController.h
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/8/14.
//  Copyright (c) 2014 CleanTalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTStatsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UIButton *siteButton;
    IBOutlet UIButton *logountButton;
    IBOutlet UIButton *refreshButton;
    IBOutlet UITableView *tableView;
}

@end
