#pragma mark - KZNLogWebViewDelegate
@protocol KZNLogWebViewDelegate <NSObject>


@optional
- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
navigationType:(UIWebViewNavigationType)navigationType;

- (void)webViewDidStartLoad:(UIWebView *)webView;

- (void)webViewDidFinishLoad:(UIWebView *)webView;

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;


@end


#pragma mark - KZNLogWebView
/// UIWebView to display console.log
@interface KZNLogWebView : UIWebView <UIWebViewDelegate> {
}


#pragma mark - property
@property (nonatomic, weak) IBOutlet id<KZNLogWebViewDelegate> kznLogWebViewDelegate;


@end
