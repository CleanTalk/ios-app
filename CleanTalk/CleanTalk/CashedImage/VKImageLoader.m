//
//  VKImageLoader.m
//  image_loader
//
//  Created by Vasyl Sadoviy on 9/15/12.
//  Copyright (c) 2012 Vakoms. All rights reserved.
//

#import "VKImageLoader.h"

static VKImageLoader *gImageLoader = nil;
NSMutableArray *gCashedImagesList = nil;
@implementation VKImageLoader
#pragma mark - init
+ (id)initialize {
	if (gImageLoader == nil) {
		gImageLoader = [[VKImageLoader alloc] init];
	}
	return gImageLoader;
}

- (void)initCashImageArray {
	NSError *lError = nil;
	NSFileManager *lFileManager = [NSFileManager defaultManager];
	[[NSFileManager defaultManager] createDirectoryAtPath:TEMP_FOLDER
							  withIntermediateDirectories:NO
											   attributes:nil
													error:nil];
	//get list of files
	NSArray *lListOfFiles = [lFileManager contentsOfDirectoryAtPath:TEMP_FOLDER error:&lError];
	if ([lListOfFiles count] > 0) {
		gCashedImagesList = [lListOfFiles mutableCopy];
	} else {
		gCashedImagesList = [[NSMutableArray alloc] init];
	}
}

- (id)init {
	self = [super init];
	if (self) {
		[self initCashImageArray];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseDownloadingImages:) name:PAUSE_DOWNLOAD_IMAGES object:nil];
		mImagesToDownload = [[NSMutableArray alloc] init];
		mIsDownloadingImages = NO;
		mAppLoaderQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
	}
	return self;
}

#pragma mark - Notification handler -
- (void)pauseDownloadingImages:(NSNotification*)pNotification {
	if ([[pNotification name] isEqualToString:PAUSE_DOWNLOAD_IMAGES]) {
		mSleepTime += [[pNotification object] intValue];
	}
}

#pragma mark - Downloading Images 
- (void)startLoadImage {
	if (!mIsDownloadingImages) {
		if (mImagesToDownload.count > 0) {
			[self loadAndConverAppImage:[mImagesToDownload lastObject]];
		}
	}
}

- (void)loadAndConverAppImage:(NSString*)pImageUrl {
	mIsDownloadingImages = YES;
	dispatch_async(mAppLoaderQueue, ^{
		@autoreleasepool {
			if (mSleepTime > 0) {
				//stop thread for some time
				sleep((uint32_t)mSleepTime);
				mSleepTime = 0;
			}
			NSError *lError = nil;
			NSString *lImageUrl = [pImageUrl copy];
			NSString *lImageFile = [[[lImageUrl stringByReplacingOccurrencesOfString:@"\\" withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""];
			NSString *lFileName = [TEMP_FOLDER stringByAppendingFormat:@"/%@", lImageFile];
			DLog(@"-----------loaded file: %@", lFileName);
            NSURL *url = [[NSURL URLWithString:lImageUrl] standardizedURL];
            if (url) {
                NSData *lData = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&lError];
                [lData writeToFile:lFileName atomically:YES];
                [lImageUrl autorelease];
            }

			dispatch_async(dispatch_get_main_queue(), ^{
				[gCashedImagesList addObject:lImageFile];
				[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_KEY object:pImageUrl userInfo:[NSDictionary dictionaryWithObject:lFileName forKey:IMAGE_PATH]];
				[mImagesToDownload removeObject:lImageUrl];
				mIsDownloadingImages = NO;
				[self startLoadImage];
			});
		}
	});
}

- (NSString*)loadImageUrl:(NSString*)pImageUrl{
    if ([[pImageUrl class] isSubclassOfClass:[NSNull class]] == NO) {
        NSString *lResult = @"";
        NSString *lImageUrl = [pImageUrl copy];
        NSString *lImageFile = [[[lImageUrl stringByReplacingOccurrencesOfString:@"\\" withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""];
        NSInteger lIndex = [gCashedImagesList indexOfObject:lImageFile];
        if (lIndex == NSNotFound) {
            if ([mImagesToDownload indexOfObject:lImageUrl] == NSNotFound && lImageUrl != nil) {
                [mImagesToDownload addObject:lImageUrl];
                [self startLoadImage];
            }
        } else {
            lResult = [TEMP_FOLDER stringByAppendingFormat:@"/%@", lImageFile];
        }
        [lImageUrl release];
        return lResult;
    } else {
        return nil;
    }
}

#pragma mark - Memory Managment
- (oneway void)release {
	//this class is singelton, so it could not call release
}

- (id)retain {
	return self;
}

- (id) autorelease {
	return self;
}

- (void)dealloc {
	[gCashedImagesList removeAllObjects];
	[gCashedImagesList release];
	[super dealloc];
}
@end
