UIWebView-NativeStorage
=======================

A Extended Class for URL loading . Save into iOS App sandbox from JavaScript interface.


```objc
// RootViewController.m
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
  NSURL *url = [[NSBundle mainBundle] URLForResource:@"index.html" withExtension:nil subdirectory:@"www"];
  [webView loadRequest:[NSURLRequest requestWithURL:url]];
  
  [UIWNativeStorage enable];
  
  [self.view addSubview:webView];
}

- (void)dealloc
{
  [UIWNativeStorage disable];
}
```


```js
// jQuery
function set(key, value){
  $.get("uiw://nativestorage/setItem", {key: key, value: value})
    .success(function(){
      alert("OK");
    });
}

function get(key){
  $.get("uiw://nativestorage/getItem", {key: key})
    .success(function(response){
      alert(response)
    });
}
```
