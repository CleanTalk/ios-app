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

- (void)mainStatsWithPageNumber:(NSInteger)pageNumber block:(AuthCompletion)block;

- (void)detailStatForCurrentService:(NSString*)serviceId time:(CGFloat)time andBlock:(AuthCompletion)block;

- (void)detailStatForCurrentService:(NSString*)serviceId time:(CGFloat)time day:(NSInteger)day allowed:(BOOL)allowed andBlock:(AuthCompletion)block;

- (void)changeStatusForMeesageWithId:(NSString *)messageId newStatus:(BOOL)status authKey:(NSString *)authKey block:(AuthCompletion)block;
@end
