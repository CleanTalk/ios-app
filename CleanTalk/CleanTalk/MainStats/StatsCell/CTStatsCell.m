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
- (IBAction)goToStatsForPeriod:(id)sender;

- (void)goToDetailStats:(NSString*)service;
- (void)openStatsForPeriod:(NSNumber*)tag forId:(NSString*)service;
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
    _imageUrl = [_imageUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [logoPhoto setCashedImageURL:_imageUrl];
}

- (void)setSiteName:(NSString *)siteName {
    _siteName = siteName;
    NSMutableAttributedString *siteTitle = [[NSMutableAttributedString alloc] initWithString:_siteName];
    
    [siteTitle addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, siteTitle.length)];
    [siteTitle addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange (0, siteTitle.length)];
    
    if ([deviceType() isEqualToString:IPHONE]) {
        [siteTitle addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} range:NSMakeRange (0, siteTitle.length)];
        
    } else {
        [siteTitle addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0]} range:NSMakeRange (0, siteTitle.length)];
        
    }
    
    [titleButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleButton setAttributedTitle:siteTitle forState:UIControlStateNormal];
    
    titleButton.frame = (CGRect){titleButton.frame.origin.x,titleButton.frame.origin.y,siteTitle.size.width + 5.0f,titleButton.frame.size.height};
}

- (void)setNewmessages:(NSString *)newmessages {
    if (newmessages) {
        newValuesLabel.hidden = NO;
        _newmessages = newmessages;
        NSMutableAttributedString *messagesString = [[NSMutableAttributedString alloc] initWithString:[self formatNumbers:_newmessages]];
        [messagesString addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange (0, messagesString.length)];
        
        if ([deviceType() isEqualToString:IPHONE]) {
            [messagesString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12.0]} range:NSMakeRange (0, messagesString.length)];
        } else {
            [messagesString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0]} range:NSMakeRange (0, messagesString.length)];
        }
        
        [newValuesLabel.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [newValuesLabel setAttributedTitle:messagesString forState:UIControlStateNormal];
        
        CGFloat width = messagesString.size.width + 3.0f;
        if (width < newValuesLabel.frame.size.height) {
            width = newValuesLabel.frame.size.height;
        }
        
        newValuesLabel.layer.cornerRadius = 7.0f;
        newValuesLabel.frame = (CGRect){titleButton.frame.origin.x + titleButton.frame.size.width,newValuesLabel.frame.origin.y,width,newValuesLabel.frame.size.height};
    } else {
        newValuesLabel.hidden = YES;
    }
}

#pragma mark - Public methods

- (void)displayStats:(NSDictionary*)dictionary {
    //service_id
    service_id = [dictionary valueForKey:@"service_id"];
    
    //today label
    NSMutableAttributedString *todayTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"TODAY", @"")];
    
    [todayTitle addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange (0, todayTitle.length)];
    
    if ([deviceType() isEqualToString:IPHONE]) {
        [todayTitle addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]} range:NSMakeRange (0, todayTitle.length)];
    } else {
        [todayTitle addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0]} range:NSMakeRange (0, todayTitle.length)];
    }
    
    [todayLabel setTextAlignment:NSTextAlignmentLeft];
    [todayLabel setAttributedText:todayTitle];
    
    // new messages values today
    NSMutableAttributedString *todaySpam = [[NSMutableAttributedString alloc] initWithString:[self formatNumbers:[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"today"] valueForKey:@"spam"]]]];
    [todaySpam addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, todaySpam.length)];
    [todaySpam addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange (0, todaySpam.length)];

    [todaySpamLabel setAttributedTitle:todaySpam forState:UIControlStateNormal];
    
    todaySpam = nil;
    todaySpam = [[NSMutableAttributedString alloc] initWithString:[self formatNumbers:[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"today"] valueForKey:@"allow"]]]];
    [todaySpam addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, todaySpam.length)];
    [todaySpam addAttributes:@{NSForegroundColorAttributeName:[UIColor greenColor]} range:NSMakeRange (0, todaySpam.length)];
    
    [todayAllowLabel setAttributedTitle:todaySpam forState:UIControlStateNormal];

    //yesterday label
    NSMutableAttributedString *yesterdayTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"YESTERDAY", @"")];
    
    [yesterdayTitle addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange (0, yesterdayTitle.length)];
    
    if ([deviceType() isEqualToString:IPHONE]) {
        [yesterdayTitle addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]} range:NSMakeRange (0, yesterdayTitle.length)];
    } else {
        [yesterdayTitle addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0]} range:NSMakeRange (0, yesterdayTitle.length)];
    }

    [yesterdayLabel setTextAlignment:NSTextAlignmentLeft];
    [yesterdayLabel setAttributedText:yesterdayTitle];
    
    // new messages values yesterday
    NSMutableAttributedString *yesterdaySpam = [[NSMutableAttributedString alloc] initWithString:[self formatNumbers:[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"yesterday"] valueForKey:@"spam"]]]];
    [yesterdaySpam addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, yesterdaySpam.length)];
    [yesterdaySpam addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange (0, yesterdaySpam.length)];

    [yesterdaySpamLabel setAttributedTitle:yesterdaySpam forState:UIControlStateNormal];
    
    yesterdaySpam = nil;
    yesterdaySpam = [[NSMutableAttributedString alloc] initWithString:[self formatNumbers:[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"yesterday"] valueForKey:@"allow"]]]];
    [yesterdaySpam addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, yesterdaySpam.length)];
    [yesterdaySpam addAttributes:@{NSForegroundColorAttributeName:[UIColor greenColor]} range:NSMakeRange (0, yesterdaySpam.length)];

    [yesterdayAllowLabel setAttributedTitle:yesterdaySpam forState:UIControlStateNormal];

    //week label
    NSMutableAttributedString *weekTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"WEEK", @"")];
    
    [weekTitle addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange (0, weekTitle.length)];
    
    if ([deviceType() isEqualToString:IPHONE]) {
        [weekTitle addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]} range:NSMakeRange (0, weekTitle.length)];
    } else {
        [weekTitle addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0]} range:NSMakeRange (0, weekTitle.length)];
    }
    
    [weekLabel setTextAlignment:NSTextAlignmentLeft];
    [weekLabel setAttributedText:weekTitle];

    // new messages values week
    NSMutableAttributedString *weekSpam = [[NSMutableAttributedString alloc] initWithString:[self formatNumbers:[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"week"] valueForKey:@"spam"]]]];
    [weekSpam addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, weekSpam.length)];
    [weekSpam addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange (0, weekSpam.length)];
    
    [weekSpamLabel setAttributedTitle:weekSpam forState:UIControlStateNormal];
    
    weekSpam = nil;
    weekSpam = [[NSMutableAttributedString alloc] initWithString:[self formatNumbers:[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"week"] valueForKey:@"allow"]]]];
    [weekSpam addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, weekSpam.length)];
    [weekSpam addAttributes:@{NSForegroundColorAttributeName:[UIColor greenColor]} range:NSMakeRange (0, weekSpam.length)];

    [weekAllowLabel setAttributedTitle:weekSpam forState:UIControlStateNormal];
}

#pragma mark - Buttons

- (IBAction)showDetailStats:(id)sender {
    if ([_delegate respondsToSelector:@selector(goToDetailStats:)]) {
        [_delegate performSelector:@selector(goToDetailStats:) withObject:service_id];
    }
}

- (IBAction)goToStatsForPeriod:(id)sender  {
    if ([_delegate respondsToSelector:@selector(openStatsForPeriod: forId:)]) {
        [_delegate performSelector:@selector(openStatsForPeriod: forId:) withObject:[NSNumber numberWithInteger:((UIButton*)sender).tag] withObject:service_id];
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

- (void)openStatsForPeriod:(NSNumber*)tag forId:(NSString*)service {
    
}
@end
