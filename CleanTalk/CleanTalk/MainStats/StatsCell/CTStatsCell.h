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
    IBOutlet UIButton *todaySpamLabel;
    IBOutlet UIButton *todayAllowLabel;

    IBOutlet UILabel *yesterdayLabel;
    IBOutlet UIButton *yesterdaySpamLabel;
    IBOutlet UIButton *yesterdayAllowLabel;

    IBOutlet UILabel *weekLabel;
    IBOutlet UIButton *weekSpamLabel;
    IBOutlet UIButton *weekAllowLabel;
    
    IBOutlet UIButton *newValuesLabel;
}

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *siteName;
@property (nonatomic, strong) NSString *newmessages;
@property (nonatomic, unsafe_unretained) id delegate;

- (void)displayStats:(NSDictionary*)dictionary;
@end
