//
//  LCJsonRequest.h
//  BroBoard
//
//  Created by chen loman on 13-3-31.
//
//

#import <Foundation/Foundation.h>

@interface LCJsonRequest : NSObject
{
    NSString *serverURL;
	NSDictionary *paramDic;
	id delegate;
	SEL doneSelector;
	SEL errorSelector;
	BOOL requestDidSucceed;
    NSData* receivedData;
    NSDictionary* resultDic;
    NSString* errMsg;
}
- (id)initWithURL: (NSString *)serverURL   // IN
		 paramDic: (NSDictionary *)paramDic // IN
		 delegate: (id)deleage		 // IN
	 doneSelector: (SEL)doneSelector	// IN
	errorSelector: (SEL)errorSelector; //IN

-(void)sendAsynchronousRequest;
- (void)sendSynchronousRequest;
- (NSString*)getErrMsg;
- (NSDictionary*)getResultDic;
- (BOOL)isRequestDidSuccessed;
- (void)sendAsynchronousRequestAndcompletionHandler:(void (^)(NSData*)) handler NS_AVAILABLE(10_7, 5_0);

@end


@interface NSDictionary (UrlEncoding)
-(NSString*) urlEncodedString;
- (NSData*) urlEncodedData;
@end
