
+ (BOOL)doesContainScheme:(NSURL *)standardizedURL scheme:(NSString *)scheme {
    NSString *urlname = [standardizedURL absoluteString];
    NSRange rangeValue;
    rangeValue = [urlname rangeOfString:scheme options:NSCaseInsensitiveSearch];
    return (rangeValue.length > 0);
}


- (BOOL)shouldHandleURL:(NSURL *)URL {
    NSURL *standardizedURL = [URL standardizedURL];
    NSURL *standardizedRedirectURL = [_request.redirectURL standardizedURL];
    
    NSArray *URLTypes = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
    if (URLTypes != nil) {
        for (int i = 0; i < [URLTypes count]; ++i) {
            NSDictionary *schemesDict = [URLTypes objectAtIndex:i];
            NSArray *schemes = [schemesDict objectForKey:@"CFBundleURLSchemes"];
            for (int j = 0; j < [schemes count]; ++j) {
                NSString *scheme = [[schemes objectAtIndex:j] lowercaseString];
                if ([OIDAuthorizationSession doesContainScheme: standardizedURL scheme:scheme]) {
                    return TRUE;
                }
            }
        }
    }
    return [[self class] URL:URL matchesRedirectionURL:_request.redirectURL];
}

