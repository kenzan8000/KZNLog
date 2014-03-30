#import "KZNLogWebView.h"
#import "KZNLog.h"


#pragma mark - KZNLogWebView
@implementation KZNLogWebView


#pragma mark - synthesize
@synthesize kznLogWebViewDelegate;


#pragma mark - initializer
- (id)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.delegate = self;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.delegate = self;
    }
    return self;
}


#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
#ifdef DEBUG_KZNLOG_WEBVIEW
    // display console.log
    NSString *urlString = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([urlString hasPrefix:@"KZNLogWebView:"]) {
        KZNSimpleLog(@"%@", [[urlString componentsSeparatedByString:@":#iOS#"] objectAtIndex:1]);
        return NO;
    }
#endif

    if (self.kznLogWebViewDelegate == nil) { return YES; }
    if ([self.kznLogWebViewDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)] == NO) { return YES; }
    return [self.kznLogWebViewDelegate webView:webView
                    shouldStartLoadWithRequest:request
                                navigationType:navigationType];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (self.kznLogWebViewDelegate == nil) { return; }
    if ([self.kznLogWebViewDelegate respondsToSelector:@selector(webViewDidStartLoad:)] == NO) { return; }
    [self.kznLogWebViewDelegate webViewDidStartLoad:webView];
}

- (void)webView:(UIWebView *)webView
didFailLoadWithError:(NSError *)error
{
    if (self.kznLogWebViewDelegate == nil) { return; }
    if ([self.kznLogWebViewDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)] == NO) { return; }
    [self.kznLogWebViewDelegate webView:webView
                   didFailLoadWithError:error];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
#ifdef DEBUG_KZNLOG_WEBVIEW
    NSString *JavaScriptString = @"console.log = function(log) { var iframe = document.createElement('IFRAME'); iframe.setAttribute('src', 'KZNLogWebView:#iOS#' + log); document.documentElement.appendChild(iframe); iframe.parentNode.removeChild(iframe); iframe = null; }";
    [self stringByEvaluatingJavaScriptFromString:JavaScriptString];
#endif
    if (self.kznLogWebViewDelegate == nil) { return; }
    if ([self.kznLogWebViewDelegate respondsToSelector:@selector(webViewDidFinishLoad:)] == NO) { return; }
    [self.kznLogWebViewDelegate webViewDidFinishLoad:webView];
}


@end
