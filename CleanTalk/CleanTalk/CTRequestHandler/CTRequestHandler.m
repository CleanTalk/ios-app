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
    
    NSMutableString *parametersString = [NSMutableString stringWithFormat:@"login=%@&password=%@&app_device_token=%@",name, pasword, getVal(DEVICE_TOKEN)];
    
    NSData *requestData = [parametersString dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:requestData];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (data) {
            block ([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]);
        } else {
            block (nil);
        }
    }];
}

- (void)mainStats:(AuthCompletion)block {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@my/main?app_mode=1",API_URL]]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0f];
    [request setHTTPMethod:@"POST"];
    
    NSMutableString *parametersString = [NSMutableString stringWithFormat:@"app_session_id=%@",getVal(APP_SESSION_ID)];
    
    NSData *requestData = [parametersString dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:requestData];

    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (data) {
            block ([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil]);
        } else {
            block (nil);
        }
    }];
}

- (void)detailStatForCurrentService:(NSString*)serviceId time:(CGFloat)time andBlock:(AuthCompletion)block {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/my/show_requests?app_mode=1",API_URL]]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0f];
    [request setHTTPMethod:@"POST"];
    
    CGFloat timeValue = 0.0f;
    if (time) {
        timeValue = time;
    }
    
    NSMutableString *parametersString = [NSMutableString stringWithFormat:@"app_session_id=%@&start_from=%f&service_id=%@&allow=1",getVal(APP_SESSION_ID),timeValue,serviceId];
    
    NSData *requestData = [parametersString dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:requestData];
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (data) {
            block ([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil]);
        } else {
            block (nil);
        }
    }];
}

- (void)detailStatForCurrentService:(NSString*)serviceId time:(CGFloat)time day:(NSInteger)day allowed:(BOOL)allowed andBlock:(AuthCompletion)block {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/my/show_requests?app_mode=1",API_URL]]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0f];
    [request setHTTPMethod:@"POST"];
    
    CGFloat timeValue = 0.0f;
    if (time) {
        timeValue = time;
    }
    
    NSMutableString *parametersString = [NSMutableString stringWithFormat:@"app_session_id=%@&start_from=%f&service_id=%@&days=%ld&allow=%d",getVal(APP_SESSION_ID),timeValue,serviceId,(long)day,allowed];
    
    NSData *requestData = [parametersString dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:requestData];
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (data) {
            block ([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil]);
        } else {
            block (nil);
        }
    }];
}
@end
