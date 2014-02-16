//
//  VKCashedImageView.m
//  image_loader
//
//  Created by Vasyl Sadoviy on 9/15/12.
//  Copyright (c) 2012 Vakoms. All rights reserved.
//

#import "VKCashedImageView.h"
#import "VKImageLoader.h"

#define PROGRESS_VIEW_SIZE 32

@interface VKCashedImageView()
- (void)initStartObjects;
- (void)setElemetPosition;
@end

@implementation VKCashedImageView
@synthesize cashedImageURL = mCashedImageURL;

#pragma mark - Init Method
- (id) init {
	self = [super init];
	if (self) {
		[self initStartObjects];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self initStartObjects];
		[self setElemetPosition];
    }
    return self;
}
- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    self = [super initWithImage:image highlightedImage:highlightedImage]; 
    if (self) {
        [self initStartObjects];
		[self setElemetPosition];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initStartObjects];
    [self setElemetPosition];
}

- (void)initStartObjects {
    if (!mActivityIndicatorView) {
        mActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [mActivityIndicatorView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin |
         UIViewAutoresizingFlexibleLeftMargin |
         UIViewAutoresizingFlexibleRightMargin |
         UIViewAutoresizingFlexibleTopMargin];
        [mActivityIndicatorView startAnimating];
        [self addSubview:mActivityIndicatorView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downlodedImageNotification:) name:NOTIFICATION_KEY object:nil];        
    }
}

#pragma mark - Set Position
- (void)setFrame:(CGRect)frame{
	[super setFrame:frame];
	[self setElemetPosition];
}

- (void)setElemetPosition{
	[mActivityIndicatorView setFrame:CGRectMake(self.frame.size.width/2 - PROGRESS_VIEW_SIZE/2,
												self.frame.size.height/2 - PROGRESS_VIEW_SIZE/2,
												PROGRESS_VIEW_SIZE,
												PROGRESS_VIEW_SIZE)];	
}

#pragma mark - Notification Observer
- (void)downlodedImageNotification:(NSNotification*)pNotification {
	if ([[pNotification name] isEqualToString:NOTIFICATION_KEY]) {
		if ([[pNotification object] isEqualToString:mCashedImageURL]) {
			[self setImage:[UIImage imageWithContentsOfFile:[[pNotification userInfo] objectForKey:IMAGE_PATH]]];
			[mActivityIndicatorView removeFromSuperview];
		}
	}
}

#pragma mark - Properties
- (void)setCashedImageURL:(NSString *)cashedImageURL {
    [self initStartObjects];
	DLog(@"cashedImageURL: %@", cashedImageURL);
	mCashedImageURL = [cashedImageURL copy];
	NSString *lPathToFile = [[VKImageLoader initialize] loadImageUrl:mCashedImageURL];
	if (lPathToFile.length > 0) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:lPathToFile]) {
            [self setImage:[UIImage imageWithContentsOfFile:lPathToFile]];
        } else {
            [self setImage:[UIImage imageNamed:@"defaultIcon"]];
        }
		[mActivityIndicatorView removeFromSuperview];
	}
}

- (void) stopIndicatorView {
    [mActivityIndicatorView removeFromSuperview];
}
#pragma mark - Dealloc
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[mActivityIndicatorView release];
	[mCashedImageURL release];
	[super dealloc];
}

@end
