//
//  CTRequestHandler.m
//  CleanTalk
//
//  Created by Oleg Sehelin on 2/8/14.
//  Copyright (c) 2014 CleanTalk. All rights reserved.
//

#import "CTRequestHandler.h"

@implementation CTRequestHandler

static CTRequestHandler *sRequestHandler;

+ (id)sharedInstance {
    if (!sRequestHandler) {
        sRequestHandler = [[CTRequestHandler alloc] init];
    }
    return sRequestHandler;
}

- (void)loginWithName:(NSString*)name password:(NSString*)pasword completionBlock:(AuthCompletion)block {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@my/session?app_mode=1",API_URL]]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0f];
    [request setHTTPMethod:@"POST"];
    
    NSMutableString *parametersString = [NSMutableString stringWithFormat:@"login=%@&password=%@",name, pasword];
    
    NSData *requestData = [parametersString dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:requestData];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        block ([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil]);
    }];
}

@end
