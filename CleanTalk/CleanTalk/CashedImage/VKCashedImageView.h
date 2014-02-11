//
//  VKCashedImageView.h
//  image_loader
//
//  Created by Vasyl Sadoviy on 9/15/12.
//  Copyright (c) 2012 Vakoms. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VKCashedImageView : UIImageView {
	NSString *mCashedImageURL;
	UIActivityIndicatorView *mActivityIndicatorView;
}
@property (nonatomic, retain) NSString *cashedImageURL;

// force stop ActivityIndicatorView
- (void) stopIndicatorView;
@end
