#import "KZNLogView.h"


#pragma mark - constant
static const CGFloat kKZNLogViewButtonWidth = 48.0f;
static const CGFloat kKZNLogViewBarHeight = 24.0f;


#pragma mark - KZNLogView
@interface KZNLogView()


#pragma mark - property
/// keep touchpoint to resize or to translate terminal
@property (nonatomic, assign) CGPoint previousTouchPoint;
/// terminal is resizing now or not
@property (nonatomic, assign) BOOL isResizing;
/// terminal is translating now or not
@property (nonatomic, assign) BOOL isTranslating;

/// textview like terminal
@property (nonatomic, strong) UITextView *terminalView;
/// titlelabel of terminal
@property (nonatomic, strong) UILabel *titleLabel;
/// togglepresentbutton of terminal
@property (nonatomic, strong) UIButton *togglePresentButton;
/// clearlogbutton of terminal
@property (nonatomic, strong) UIButton *clearLogButton;
/// savelogbutton of terminal
@property (nonatomic, strong) UIButton *saveLogButton;
/// bottombar of terminal
@property (nonatomic, strong) UIView *bottomBarView;


@end


#pragma mark - KZNLogView
@implementation KZNLogView


#pragma mark - synthesize
@synthesize previousTouchPoint;
@synthesize terminalView;
@synthesize titleLabel;
@synthesize togglePresentButton;
@synthesize clearLogButton;
@synthesize saveLogButton;
@synthesize bottomBarView;


#pragma mark - initializer
- (id)init
{
    self = [super init];
    if (self) {
        self.terminalView = [UITextView new];
        self.titleLabel = [UILabel new];
        self.togglePresentButton = [UIButton new];
        self.clearLogButton = [UIButton new];
        self.saveLogButton = [UIButton new];
        self.bottomBarView = [UIView new];
        [self addSubview:self.terminalView];
        [self addSubview:self.bottomBarView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.clearLogButton];
        [self addSubview:self.saveLogButton];

        // button events
        [self.togglePresentButton addTarget:self
                                     action:@selector(touchedUpInsideWithTogglePresentButton:)
                           forControlEvents:UIControlEventTouchUpInside];
        [self.clearLogButton addTarget:self
                                action:@selector(touchedUpInsideWithClearLogButton:)
                      forControlEvents:UIControlEventTouchUpInside];
        [self.saveLogButton addTarget:self
                               action:@selector(touchedUpInsideWithSaveLogButton:)
                     forControlEvents:UIControlEventTouchUpInside];

        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window setWindowLevel:UIWindowLevelAlert];
        [window addSubview:self];
        [window addSubview:self.togglePresentButton];

        // settings
        [self.terminalView setEditable:NO];
        [self setHidden:YES];
        self.isResizing = NO;
        self.isTranslating = NO;

        // initial position and size
        CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        CGRect terminalFrame = CGRectMake(
            0, statusBarHeight, window.frame.size.width, window.frame.size.height-statusBarHeight*2
        );
        [self setFrame:terminalFrame];

        [self design];
    }
    return self;
}


#pragma mark - release
- (void)dealloc
{
    [self.togglePresentButton removeFromSuperview];
    self.togglePresentButton = nil;
    [self.bottomBarView removeFromSuperview];
    self.bottomBarView = nil;
    [self.saveLogButton removeFromSuperview];
    self.saveLogButton = nil;
    [self.clearLogButton removeFromSuperview];
    self.clearLogButton = nil;
    [self.titleLabel removeFromSuperview];
    self.titleLabel = nil;
    [self.terminalView removeFromSuperview];
    self.terminalView = nil;
}


#pragma mark - class method
+ (KZNLogView *)sharedLogView
{
    static dispatch_once_t onceToken;
    static KZNLogView *g_KZNLogView = nil;
    dispatch_once(&onceToken, ^ () {
        g_KZNLogView = [KZNLogView new];
    });
    return g_KZNLogView;
}


#pragma mark - event listener
/**
 * event when togglePresentButton was touched up inside.
 * @param button togglePresentButton
 */
- (void)touchedUpInsideWithTogglePresentButton:(UIButton *)button
{
    [self present:self.hidden];
}

/**
 * event when clearLogButton was touched up inside.
 * @param button clearLogButton
 */
- (void)touchedUpInsideWithClearLogButton:(UIButton *)button
{
    [self clearLog];
}

/**
 * event when savelogbutton was touched up inside.
 * @param button savelogbutton4
 */
- (void)touchedUpInsideWithSaveLogButton:(UIButton *)button
{
    [self saveLog];
}


#pragma mark - api
- (void)displayLogWithString:(NSString *)string
{
    // add string to textview
    NSString *currentLog = self.terminalView.text;
    [self.terminalView setText:
        [NSString stringWithFormat:@"%@%@",
            string, currentLog
        ]
    ];
}

- (void)clearLog
{
    [self.terminalView setText:@""];
}

- (void)saveLog
{
    // check file, folder
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *fileName = [NSString stringWithFormat:@"%@.txt", NSStringFromClass([KZNLogView class])];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];

    // save text file
    NSError *error = nil;
    [self.terminalView.text writeToFile:filePath
                             atomically:YES
                               encoding:NSUTF8StringEncoding
                                  error:&error];
}

- (void)present:(BOOL)isPresent
{
    [self setHidden:!isPresent];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window setWindowLevel:UIWindowLevelAlert];
    [window bringSubviewToFront:self];
    [window bringSubviewToFront:self.togglePresentButton];
    [self design];
}


#pragma mark - private api
/**
 * override UIView#setFrame
 * @param rect CGRect
 */
- (void)setFrame:(CGRect)rect
{
    // can not resize
    if (rect.size.width < kKZNLogViewButtonWidth * 2 ||
        rect.size.height < kKZNLogViewBarHeight * 2) {
        return;
    }

    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    // can not move
    if (rect.origin.x < 0 ||
        rect.origin.x+rect.size.width > window.frame.size.width) {
        return;
    }
    else if (rect.origin.y < statusBarHeight ||
            rect.origin.y+rect.size.height > window.frame.size.height-statusBarHeight) {
        return;
    }

    // setFrame
    if ([[super class] instancesRespondToSelector:@selector(setFrame:)]) {
        [super setFrame:rect];
    }

    // adjust UI position
    [self.terminalView setFrame:CGRectMake(0, kKZNLogViewBarHeight, rect.size.width, rect.size.height-kKZNLogViewBarHeight*2)];
    [self.titleLabel setFrame:CGRectMake(0, 0, rect.size.width, kKZNLogViewBarHeight)];
    [self.togglePresentButton setFrame:CGRectMake(0, 0, kKZNLogViewButtonWidth, kKZNLogViewBarHeight)];
    [self.clearLogButton setFrame:CGRectMake(rect.size.width-kKZNLogViewButtonWidth, 0, kKZNLogViewButtonWidth, kKZNLogViewBarHeight)];
    [self.saveLogButton setFrame:CGRectMake(0, 0, kKZNLogViewButtonWidth, kKZNLogViewBarHeight)];
    [self.bottomBarView setFrame:CGRectMake(0, rect.size.height-kKZNLogViewBarHeight, rect.size.width, kKZNLogViewBarHeight)];
}

/**
 * override UIResponder#touchesBegan:event:
 * @param touches NSSet
 * @param event UIEvent
 */
- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    // detect touchPoint contains topbar or bottombar area
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    CGRect topRect = self.titleLabel.frame;
    CGRect bottomRect = self.bottomBarView.frame;
    if (CGRectContainsPoint(topRect, touchPoint)) {
        self.isTranslating = YES;
    }
    else if (CGRectContainsPoint(bottomRect, touchPoint)) {
        self.isResizing = YES;
    }

    self.previousTouchPoint = touchPoint;

    [self design];
}

/**
 * override UIResponder#touchesMoved:event
 * @param touches NSSet
 * @param event UIEvent
 */
- (void)touchesMoved:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    [self setFrameWithTouches:touches];
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    self.previousTouchPoint = touchPoint;
    [self design];
}

/**
 * override UIResponder#touchesEnded:event
 * @param touches NSSet
 * @param event UIEvent
 */
- (void)touchesEnded:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    [self setFrameWithTouches:touches];
    self.isResizing = self.isTranslating = NO;
    [self design];
}

/**
 * change terminal position and size
 * @param touches NSSet
 */
- (void)setFrameWithTouches:(NSSet *)touches
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    CGSize translation = (CGSize){
        touchPoint.x - self.previousTouchPoint.x,
        touchPoint.y -  self.previousTouchPoint.y
    };

    CGRect transformedFrame = self.frame;
    if (self.isTranslating) {
        transformedFrame.origin.x += translation.width;
        transformedFrame.origin.y += translation.height;
    }
    else if (self.isResizing) {
        transformedFrame.size.width += translation.width;
        transformedFrame.size.height += translation.height;
    }

    [self setFrame:transformedFrame];
}

/**
 * design UI
 */
- (void)design
{
    // background
    [self setBackgroundColor:[UIColor clearColor]];

    // terminal
    [self.terminalView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f]];
    [self.terminalView setTextColor:[UIColor lightGrayColor]];
    if ([[[UIDevice currentDevice] systemVersion] integerValue] * 10000 >= __IPHONE_7_0) {
        [self.terminalView.textContainer setLineBreakMode:NSLineBreakByCharWrapping];
    }

    // topbar
    [self.titleLabel setBackgroundColor:[UIColor colorWithRed:0.7f green:0.7f blue:0.7f alpha:1.0f]];
    [self.titleLabel setTextColor:[UIColor blackColor]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    if (self.isTranslating) { [self.titleLabel setText:@"translating"]; }
    else if (self.isResizing) { [self.titleLabel setText:@"resizing"]; }
    else { [self.titleLabel setText:@"terminal"]; }

    // buttons
    NSArray *buttons = @[self.togglePresentButton, self.clearLogButton, self.saveLogButton,];
    NSArray *titles = @[((self.hidden) ? @"show" : @"hide"), @"clear", @"save",];
    NSArray *colors = @[[UIColor blueColor], [UIColor whiteColor],];
    UIControlState controlStates[] = {UIControlStateNormal, UIControlStateHighlighted};
    for (NSInteger i = 0; i < buttons.count; i++) {
        [buttons[i] setTitle:titles[i]
                    forState:UIControlStateNormal];
        for (NSInteger j = 0; j < colors.count; j++) {
            [buttons[i] setTitleColor:colors[j]
                             forState:controlStates[j]];
        }
    }

    // bottombar
    [self.bottomBarView setBackgroundColor:[UIColor colorWithRed:0.7f green:0.7f blue:0.7f alpha:1.0f]];
}


@end
