//
//  VKImageLoader.h
//  image_loader
//
//  Created by Vasyl Sadoviy on 9/15/12.
//  Copyright (c) 2012 Vakoms. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NOTIFICATION_KEY @"VK_DOWNLOAD_NOTIFICATION"
#define IMAGE_PATH @"VK_IMAGE_PATH"
#define TEMP_FOLDER [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/tmp"]
#define PAUSE_DOWNLOAD_IMAGES @"pause_download_images"
@interface VKImageLoader : NSObject {
	NSInteger mSleepTime;
	dispatch_queue_t mAppLoaderQueue;
	BOOL mIsDownloadingImages;
	NSMutableArray *mImagesToDownload;
}
+ (id)initialize;
- (NSString*)loadImageUrl:(NSString*)pImageUrl;

@end
