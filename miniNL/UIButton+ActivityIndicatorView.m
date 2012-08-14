//
//  UIButton+ActivityIndicatorView.m
//  Mini Colombia
//
//  Created by Juan José Villegas on 13/08/12.
//
//

#import "UIButton+ActivityIndicatorView.h"
#import <objc/runtime.h>

@implementation UIButton (ActivityIndicatorView)

static char UIB_PROPERTY_KEY;

@dynamic activityView;

-(void) setActivityView:(UIActivityIndicatorView *)activityView{
    objc_setAssociatedObject(self, &UIB_PROPERTY_KEY, activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addSubview:activityView];
}

-(UIActivityIndicatorView *) activityView{
    return (UIActivityIndicatorView *)objc_getAssociatedObject(self, &UIB_PROPERTY_KEY);
}

@end
