//
//  AppDelegate.h
//  miniNL
//
//  Created by German Villegas on 7/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticiasEngine.h"
#import "DescargasEngine.h"
#import "ComunidadEngine.h"

#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NoticiasEngine *noticiasEngine;
@property (strong, nonatomic) DescargasEngine *descargasEngine;
@property (strong, nonatomic) ComunidadEngine * comunidadEngine;

@end
