//
//  CTRequestHandler.h
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/8/14.
//  Copyright (c) 2014 CleanTalk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AuthCompletion)(NSDictionary *response);

@interface CTRequestHandler : NSObject

+ (id)sharedInstance;

- (void)loginWithName:(NSString*)name password:(NSString*)pasword completionBlock:(AuthCompletion)block;

- (void)mainStats:(AuthCompletion)block;

- (void)detailStatForCurrentService:(NSString*)serviceId time:(CGFloat)time andBlock:(AuthCompletion)block;
@end
