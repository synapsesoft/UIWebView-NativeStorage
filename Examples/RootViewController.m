//
//  RootViewController.m
//  UIWebView-NativeStorage
//

#import "RootViewController.h"

#import "UIWNativeStorage.h"

@interface RootViewController()
@property(nonatomic, strong) UIWNativeStorage *nativeStorage;
@end

@implementation RootViewController

- (void)dealloc
{
  [UIWNativeStorage disable];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
  NSURL *url = [[NSBundle mainBundle] URLForResource:@"index.html" withExtension:nil subdirectory:@"www"];
  [webView loadRequest:[NSURLRequest requestWithURL:url]];
  
  [UIWNativeStorage enable];
  
  [self.view addSubview:webView];
}

@end
