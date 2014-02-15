//
//  CTDetailGroupCell.m
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/13/14.
//  Copyright (c) 2014 CleanTalk. All rights reserved.
//

#import "CTDetailGroupCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation CTDetailGroupCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Properties 

- (void)setTime:(NSString *)time {
    if (![[time class] isSubclassOfClass:[NSNull class]]) {
        _time = time;
        timeLabel.text = _time;
    }
}

- (void)setNickName:(NSString *)nickName {
    if (![[nickName class] isSubclassOfClass:[NSNull class]]) {
        _nickName = nickName;
        nicknameLabel.text = _nickName;
    }
}

- (void)setEmail:(NSString *)email {
    if (![[email class] isSubclassOfClass:[NSNull class]]) {
        _email = email;
        emailLabel.text = _email;
    }
}

- (void)setType:(NSString *)type {
    if (![[type class] isSubclassOfClass:[NSNull class]]) {
        _type = type;
        typeLabel.text = _type;
    }
    _type = type;
    typeLabel.text = _type;
}

- (void)setIsSpam:(BOOL)isSpam {
    _isSpam = isSpam;

    NSMutableAttributedString *spamString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"SPAM", nil)];
    if (isSpam) {
        [spamString addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, spamString.length)];
        [spamString addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange (0, spamString.length)];
    } else {
        spamString = nil;
        spamString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"ALLOW", nil)];
        [spamString addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, spamString.length)];
        [spamString addAttributes:@{NSForegroundColorAttributeName:[UIColor greenColor]} range:NSMakeRange (0, spamString.length)];
    }
    
    spamLabel.attributedText = spamString;
}

- (void)setComment:(NSString *)comment {
    _comment = comment;
    commentLabel.hidden = NO;
    sepView.hidden = NO;
    commentLabel.text = [NSString stringWithFormat:@"  %@",_comment];
    
    //add border
    commentLabel.layer.borderWidth = 2.0f;
    commentLabel.layer.borderColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0].CGColor;
    commentLabel.layer.cornerRadius = 4.0f;
}

@end
