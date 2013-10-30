
//  UIWebView_NativeStorage.m
//  UIWebView-NativeStorage
//

//  Copyright (c) 2013 Synapsesoft. All rights reserved.
//

#import "UIWNativeStorage.h"

@implementation NSURL (ParseQuery)

- (NSDictionary *)queryAsDictionary {
  NSArray *components = [[self query] componentsSeparatedByString:@"&"];
  NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
  for (NSString *component in components) {
    NSArray *keyAndValues = [component componentsSeparatedByString:@"="];
    NSString* value = [[keyAndValues objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [parameters setObject:value forKey:[keyAndValues objectAtIndex:0]];
  }
  return parameters;
}
@end

@interface UIWNativeStorageProtocol : NSURLProtocol
@end

@implementation UIWNativeStorageProtocol

#pragma mark - NSURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
  NSURL *url = request.URL;
  return ([url.scheme isEqualToString:@"uiw"] && [url.host isEqualToString:@"nativestorage"]);
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
  return request;
}

#define ROUTE(__PATH) [self.request.URL.path isEqualToString:__PATH]

- (void)startLoading
{
  NSDictionary *params = [self.request.URL queryAsDictionary];
  //if([self.request.HTTPMethod isEqualToString:@"POST"] && [self.request.URL.path isEqualToString:@"/setItem"]){
  if(ROUTE(@"/setItem")){
    [self saveValue:params[@"value"] forKey:params[@"key"]];
    [self sendResponse:@"OK"];
  }
  else if(ROUTE(@"/getItem")){
    NSString *value = [self valueForKey:params[@"key"]];
    [self sendResponse:value];
  }
}

- (void)stopLoading
{
}

#pragma mark - Private

- (void)saveValue:(NSString *)value forKey:(NSString *)key
{
  [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)valueForKey:(NSString *)key
{
  return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void)sendResponse:(NSString *)body
{
  NSDictionary *headers = @{@"Access-Control-Allow-Origin" : @"*", @"Access-Control-Allow-Headers" : @"Content-Type"};
  NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:self.request.URL statusCode:200 HTTPVersion:@"1.1" headerFields:headers];
  [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
  [self.client URLProtocol:self didLoadData:[body dataUsingEncoding:NSUTF8StringEncoding]];
  [self.client URLProtocolDidFinishLoading:self];
}

@end

@implementation UIWNativeStorage

+ (BOOL)enable
{
  return [NSURLProtocol registerClass:[UIWNativeStorageProtocol class]];
}

+ (void)disable
{
  [NSURLProtocol unregisterClass:[UIWNativeStorageProtocol class]];
}

@end

