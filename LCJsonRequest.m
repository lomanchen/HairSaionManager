//
//  LCJsonRequest.m
//  BroBoard
//
//  Created by chen loman on 13-3-31.
//
//

#import "LCJsonRequest.h"

@implementation NSDictionary (UrlEncoding)

static NSString *toString(id object) {
    return [NSString stringWithFormat: @"%@", object];
}

// helper function: get the url encoded string form of any object
static NSString *urlEncode(id object) {
    NSString *string = toString(object);
    return [string stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
}


-(NSString*) urlEncodedString {
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in self) {
        id value = [self objectForKey: key];
        NSString *part = [NSString stringWithFormat: @"%@=%@", urlEncode(key), urlEncode(value)];
        [parts addObject: part];
    }
    return [parts componentsJoinedByString: @"&"];
}

- (NSData*) urlEncodedData
{
    return [[self urlEncodedString]dataUsingEncoding:NSUTF8StringEncoding];
}

@end

@implementation LCJsonRequest
- (id)initWithURL:(NSURL *)aServerURL paramDic:(NSDictionary *)aParamDic delegate:(id)aDeleage doneSelector:(SEL)aDoneSelector errorSelector:(SEL)aErrorSelector
{
    if ((self = [super init]))
    {
        serverURL = aServerURL;
        paramDic = aParamDic;
        delegate = aDeleage;
        doneSelector = aDoneSelector;
        errorSelector = aErrorSelector;
    }
    return self;
}

- (void)sendAsynchronousRequest
{
    NSURL *URL = [NSURL URLWithString:serverURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[paramDic urlEncodedData]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        
        if (!error && responseCode == 200) {
            id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (res && [res isKindOfClass:[NSDictionary class]])
            {
                resultDic = res;
                NSString* result = [res objectForKey:@"result"];
                if (nil == result || [result isEqualToString:@""])
                {
                    errMsg = @"返回结果为空!";
                }
                if ([result isEqualToString:@"OK"])
                {
                    requestDidSucceed = YES;
                    if (nil != delegate && [delegate respondsToSelector:doneSelector])
                    {
                        [delegate performSelector:doneSelector withObject:self];
                        return;
                    }
                }
                else
                {
                    errMsg = [res objectForKey:@"message"];
                }
            }
            else
            {
                errMsg = @"返回结果异常!";
            }
        }
        else
        {
            errMsg = [NSString stringWithFormat:@"HTTP请求错误,Code[%d]:%@", responseCode, [error description]];
        }
        if (nil != delegate && [delegate respondsToSelector:errorSelector])
        {
            [delegate performSelector:errorSelector withObject:self];
            return;
        }
    }];
}

- (void)sendAsynchronousRequestAndcompletionHandler:(void (^)(NSData*)) handler NS_AVAILABLE(10_7, 5_0)
{
    NSURL *URL = [NSURL URLWithString:serverURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[paramDic urlEncodedData]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        
        if (!error && responseCode == 200) {
            id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (res && [res isKindOfClass:[NSDictionary class]])
            {
                resultDic = res;
                NSString* result = [res objectForKey:@"result"];
                if (nil == result || [result isEqualToString:@""])
                {
                    errMsg = @"返回结果为空!";
                }
                if ([result isEqualToString:@"OK"])
                {
                    requestDidSucceed = YES;
                    if (handler)
                    {
                        handler(data);
                        return;
                    }
                }
                else
                {
                    errMsg = [res objectForKey:@"message"];
                }
            }
            else
            {
                errMsg = @"返回结果异常!";
            }
        }
        else
        {
            errMsg = [NSString stringWithFormat:@"HTTP请求错误,Code[%d]:%@", responseCode, [error description]];
        }
        if (nil != delegate && [delegate respondsToSelector:errorSelector])
        {
            [delegate performSelector:errorSelector withObject:self];
            return;
        }
    }];
}

- (void)sendSynchronousRequest
{
    NSURL *URL = [NSURL URLWithString:serverURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[paramDic urlEncodedData]];
    NSError* error = nil;
    NSURLResponse* response = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
    
    if (!error && responseCode == 200)
    {
        id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (res && [res isKindOfClass:[NSDictionary class]]) {
            resultDic = res;
            NSString* result = [res objectForKey:@"result"];
            if (nil == result || [result isEqualToString:@""])
            {
                errMsg = @"返回结果为空!";
            }
            if ([result isEqualToString:@"OK"])
            {
                requestDidSucceed = YES;
                if (nil != delegate && [delegate respondsToSelector:doneSelector])
                {
                    [delegate performSelector:doneSelector withObject:self];
                    return;
                }
            }
            else
            {
                errMsg = [res objectForKey:@"message"];
            }
        }
        else
        {
            errMsg = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        }
    }
    else
    {
        errMsg = [NSString stringWithFormat:@"HTTP请求错误,Code[%d]:%@", responseCode, [error description]];
    }
    if (nil != delegate && [delegate respondsToSelector:errorSelector])
    {
        [delegate performSelector:errorSelector withObject:self];
        return;
    }
}

- (BOOL)isRequestDidSuccessed
{
    return requestDidSucceed;
}
- (NSString*)getErrMsg
{
    return errMsg;
}

- (NSDictionary*)getResultDic
{
    return resultDic;
}
@end
