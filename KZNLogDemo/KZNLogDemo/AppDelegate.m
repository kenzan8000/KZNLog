#import "AppDelegate.h"
#import "KZNLog.h"
#import "KZNLogWebView.h"


#pragma mark - AppDelegate
@implementation AppDelegate


#pragma mark - life cycle
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
/*
    for (NSInteger i = 1; i < 5; i++) {
        KZNDemoLog(@"KZNLog Demo: %ld", i);
    }
*/
    self.webView = [KZNLogWebView new];
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    [self.webView setFrame:CGRectMake(0, statusBarHeight, self.window.frame.size.width, self.window.frame.size.height-statusBarHeight)];
    [self.window addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://raw2.github.com/kenzan8000/KZNLog/KZNLogDemo/WebView/index/"]]];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}


@end
