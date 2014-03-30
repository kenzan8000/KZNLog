#import "KZNLogView.h"


// DEBUG_KZNLOG
// DEBUG_KZNLOG_WEBVIEW


#ifdef DEBUG_KZNLOG
#   define InitKZNLog [KZNLogView sharedLogView]


#   define KZNLog(fmt, ...)\
    {\
        NSString *KZNLogString = [NSString stringWithFormat:\
            @"\n//////////////////////////////////////////////////\nline:%d\nfunction:%s\n\nlog:\n" fmt @"\n\n\n",\
            __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__\
        ];\
        \
        NSLog(@"%@", KZNLogString);\
        [[KZNLogView sharedLogView] displayLogWithString:KZNLogString];\
    }

#   define KZNSimpleLog(fmt, ...)\
    {\
        NSString *KZNLogString = [NSString stringWithFormat:\
            @"\n//////////////////////////////////////////////////\n" fmt @"\n\n\n",\
            ##__VA_ARGS__\
        ];\
        \
        NSLog(@"%@", KZNLogString);\
        [[KZNLogView sharedLogView] displayLogWithString:KZNLogString];\
    }

#else

#   define KZNLog(...)

#   define KZNSimpleLog(...)

#endif
