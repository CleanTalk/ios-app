//
//  CTDetailGroupCell.h
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/13/14.
//  Copyright (c) 2014 CleanTalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTDetailGroupCell : UITableViewCell {
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *senderLabel;
    IBOutlet UILabel *typeLabel;
    IBOutlet UILabel *spamLabel;
    IBOutlet UILabel *commentLabel;
    IBOutlet UIImageView *sepView;
    IBOutlet UILabel *statusLabel;
    IBOutlet UILabel *typeStatusLabel;
    IBOutlet UILabel *statusStatusLabel;
}

@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *sender;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) BOOL isSpam;
@property (nonatomic, strong) NSString *comment;

@end
