//
//  CTStatsCell.m
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/11/14.
//  Copyright (c) 2014 CleanTalk. All rights reserved.
//

#import "CTStatsCell.h"
#import <QuartzCore/QuartzCore.h>

@interface CTStatsCell () {
    NSString *service_id;
}
- (IBAction)showDetailStats:(id)sender;
- (void)goToDetailStats:(NSString*)service;
@end

@implementation CTStatsCell

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

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [logoPhoto setCashedImageURL:_imageUrl];
}

- (void)setSiteName:(NSString *)siteName {
    _siteName = siteName;
    NSMutableAttributedString *siteTitle = [[NSMutableAttributedString alloc] initWithString:_siteName];
    
    [siteTitle addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, siteTitle.length)];
    [siteTitle addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange (0, siteTitle.length)];
    [siteTitle addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} range:NSMakeRange (0, siteTitle.length)];
    
    [titleButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleButton setAttributedTitle:siteTitle forState:UIControlStateNormal];
    
    titleButton.frame = (CGRect){titleButton.frame.origin.x,titleButton.frame.origin.y,siteTitle.size.width + 5.0f,titleButton.frame.size.height};
}

- (void)setNewmessages:(NSString *)newmessages {
    newValuesLabel.hidden = NO;
    _newmessages = newmessages;
    NSMutableAttributedString *messagesString = [[NSMutableAttributedString alloc] initWithString:[self formatNumbers:_newmessages]];
    [messagesString addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange (0, messagesString.length)];
    [messagesString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12.0]} range:NSMakeRange (0, messagesString.length)];
    
    [newValuesLabel.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [newValuesLabel setAttributedTitle:messagesString forState:UIControlStateNormal];
    
    CGFloat width = messagesString.size.width + 3.0f;
    if (width < newValuesLabel.frame.size.height) {
        width = newValuesLabel.frame.size.height;
    }
    
    newValuesLabel.frame = (CGRect){titleButton.frame.origin.x + titleButton.frame.size.height,newValuesLabel.frame.origin.y,width,newValuesLabel.frame.size.height};
    newValuesLabel.layer.cornerRadius = 7.0f;
}

#pragma mark - Public methods

- (void)displayStats:(NSDictionary*)dictionary {
    //service_id
    service_id = [dictionary valueForKey:@"service_id"];
    
    //today label
    NSMutableAttributedString *todayTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"TODAY", @"")];
    
    [todayTitle addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange (0, todayTitle.length)];
    [todayTitle addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]} range:NSMakeRange (0, todayTitle.length)];
    
    [todayLabel setTextAlignment:NSTextAlignmentLeft];
    [todayLabel setAttributedText:todayTitle];
    
    //yesterday label
    NSMutableAttributedString *yesterdayTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"YESTERDAY", @"")];
    
    [yesterdayTitle addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange (0, yesterdayTitle.length)];
    [yesterdayTitle addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]} range:NSMakeRange (0, yesterdayTitle.length)];
    
    [yesterdayLabel setTextAlignment:NSTextAlignmentLeft];
    [yesterdayLabel setAttributedText:yesterdayTitle];
    
    //week label
    NSMutableAttributedString *weekTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"WEEK", @"")];
    
    [weekTitle addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange (0, weekTitle.length)];
    [weekTitle addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]} range:NSMakeRange (0, weekTitle.length)];
    
    [weekLabel setTextAlignment:NSTextAlignmentLeft];
    [weekLabel setAttributedText:weekTitle];

    todaySpamLabel.text = [self formatNumbers:[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"today"] valueForKey:@"spam"]]];
    todayAllowLabel.text = [self formatNumbers:[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"today"] valueForKey:@"allow"]]];

    yesterdaySpamLabel.text = [self formatNumbers:[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"yesterday"] valueForKey:@"spam"]]];
    yesterdayAllowLabel.text = [self formatNumbers:[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"yesterday"] valueForKey:@"allow"]]];

    weekSpamLabel.text = [self formatNumbers:[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"week"] valueForKey:@"spam"]]];
    weekAllowLabel.text = [self formatNumbers:[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"week"] valueForKey:@"allow"]]];    
}

#pragma mark - Buttons

- (IBAction)showDetailStats:(id)sender {
    if ([_delegate respondsToSelector:@selector(goToDetailStats:)]) {
        [_delegate performSelector:@selector(goToDetailStats:) withObject:service_id];
    }
}

#pragma mark - Formatting string

- (NSMutableString*)formatNumbers:(NSString*)numbers {
    NSInteger startPosition = numbers.length % 3;
    NSMutableString* resultString = [NSMutableString stringWithFormat:@""];
    
    if (numbers.length > 3) {
        if (startPosition != 0) {
            resultString = [NSMutableString stringWithFormat:@"%@ ",[numbers substringWithRange:NSMakeRange(0, startPosition)]];
            
            for (NSUInteger i = 0; i<(NSInteger)numbers.length/3; i++) {
                [resultString appendString:[NSString stringWithFormat:@"%@ ",[numbers substringWithRange:NSMakeRange(resultString.length - (i + 1), 3)]]];
            }
        } else {
            for (NSUInteger i = 0; i<(NSInteger)numbers.length/3; i++) {
                [resultString appendString:[NSString stringWithFormat:@"%@ ",[numbers substringWithRange:NSMakeRange(resultString.length - i*1, 3)]]];
            }
        }
        return resultString;
    } else {
        return [NSMutableString stringWithString:numbers];
    }
}

- (void)goToDetailStats:(NSString*)service {
    
}
@end
