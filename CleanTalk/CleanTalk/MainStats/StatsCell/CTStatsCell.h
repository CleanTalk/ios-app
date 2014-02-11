//
//  CTStatsCell.h
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/11/14.
//  Copyright (c) 2014 CleanTalk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKCashedImageView.h"

@interface CTStatsCell : UITableViewCell {
    IBOutlet VKCashedImageView *logoPhoto;
    IBOutlet UIButton *titleButton;
    
    IBOutlet UILabel *todayLabel;
    IBOutlet UILabel *todaySpamLabel;
    IBOutlet UILabel *todayAllowLabel;

    IBOutlet UILabel *yesterdayLabel;
    IBOutlet UILabel *yesterdaySpamLabel;
    IBOutlet UILabel *yesterdayAllowLabel;

    IBOutlet UILabel *weekLabel;
    IBOutlet UILabel *weekSpamLabel;
    IBOutlet UILabel *weekAllowLabel;
    
    IBOutlet UILabel *newValuesLabel;
}

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *siteName;
@property (nonatomic, strong) NSString *newmessages;

- (void)displayStats:(NSDictionary*)dictionary;
@end
