//
//  CTDetailGroupCell.m
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/13/14.
//  Copyright (c) 2014 CleanTalk. All rights reserved.
//

#import "CTDetailGroupCell.h"
#import <QuartzCore/QuartzCore.h>

#define Y_SEPARATOR_IPHONE 173.0f
#define Y_SEPARATOR_IPAD 143.0f

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
        [timeLabel sizeToFit];
        [statusLabel sizeToFit];        
    }
}

- (void)setSender:(NSString *)sender {
    if (![[sender class] isSubclassOfClass:[NSNull class]]) {
        _sender = sender;
        if (![_sender isEqualToString:@"<null>"]) {
            senderLabel.text = _sender;
        }else {
            senderLabel.text = @"\n";
        }
        [senderLabel sizeToFit];
    }
}

- (void)setType:(NSString *)type {
    if (![[type class] isSubclassOfClass:[NSNull class]]) {
        _type = type;
        typeLabel.text = _type;
        typeLabel.frame = (CGRect) {typeLabel.frame.origin.x,CGRectGetMaxY(senderLabel.frame),typeLabel.frame.size.width,typeLabel.frame.size.height};
        spamLabel.frame = (CGRect) {spamLabel.frame.origin.x,CGRectGetMaxY(senderLabel.frame),spamLabel.frame.size.width,spamLabel.frame.size.height};
        typeStatusLabel.frame = (CGRect) {typeStatusLabel.frame.origin.x,CGRectGetMaxY(senderLabel.frame),typeStatusLabel.frame.size.width,typeStatusLabel.frame.size.height};
        statusStatusLabel.frame = (CGRect) {statusStatusLabel.frame.origin.x,CGRectGetMaxY(senderLabel.frame),statusStatusLabel.frame.size.width,statusStatusLabel.frame.size.height};
    }
}

- (void)setIsSpam:(BOOL)isSpam {
    _isSpam = isSpam;

    NSMutableAttributedString *spamString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"SPAM", nil)];
    if (!isSpam) {
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
    
    CGFloat yVallue = Y_SEPARATOR_IPHONE;
    
    if ([deviceType() isEqualToString:IPAD]) {
        yVallue = Y_SEPARATOR_IPAD;
    }
    
    //add border
    commentLabel.layer.borderWidth = 1.0f;
    commentLabel.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
    commentLabel.layer.cornerRadius = 4.0f;

    CGSize constraint = CGSizeMake(commentLabel.frame.size.width,commentLabel.frame.size.height);
    CGSize size = [comment sizeWithFont:commentLabel.font constrainedToSize:constraint lineBreakMode:commentLabel.lineBreakMode];
    
    commentLabel.frame = (CGRect) {commentLabel.frame.origin.x,commentLabel.frame.origin.y, commentLabel.frame.size.width, size.height};

    sepView.frame = (CGRect){sepView.frame.origin.x,CGRectGetMaxY(commentLabel.frame) + 5.0,sepView.frame.size.width,1.0};
    
    commentLabel.text = [NSString stringWithFormat:@"%@",_comment];
}


@end
