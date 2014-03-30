#pragma mark - KZNLogView
/// terminal to display logs
@interface KZNLogView : UIView {
}


#pragma mark - property


#pragma mark - class method
/**
 * singleton
 * @return KZNLogView
 */
+ (KZNLogView *)sharedLogView;


#pragma mark - api
/**
 * display string on terminal
 * @param string string to display
 */
- (void)displayLogWithString:(NSString *)string;

/**
 * clear string on terminal
 */
- (void)clearLog;

/**
 * save string on terminal as a file(text file in NSDocumentDirectory)
 */
- (void)saveLog;

/**
 * present logview
 * @param present YES or NO
 */
- (void)present:(BOOL)present;


@end
