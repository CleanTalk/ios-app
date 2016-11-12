//
//  CTDetailGroupCell.h
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/13/14.
//  Copyright (c) 2014 CleanTalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CTDetailGroupCellDelegate <NSObject>
- (void)updateStatusForMeesageWithId:(NSString *)messageId newStatus:(BOOL)status;

@end

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
    IBOutlet UIView *containerView;
    IBOutlet UIButton *allowedButton;
    IBOutlet UILabel *reportedLabel;
}

@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *sender;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) BOOL isSpam;
@property (nonatomic, assign) NSInteger approved;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *messageId;
@property (nonatomic, weak) id <CTDetailGroupCellDelegate> delegate;

- (void)displayReportedLabel:(BOOL)isSpam;
@end
