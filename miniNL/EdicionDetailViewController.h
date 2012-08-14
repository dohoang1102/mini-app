//
//  EdicionDetailViewController.h
//  miniNL
//
//  Created by German Villegas on 10/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Edicion.h"

@interface EdicionDetailViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, strong) Edicion *edicion;
@property (weak, nonatomic) IBOutlet UILabel *lbTitulo;
@property (weak, nonatomic) IBOutlet UIImageView *imageEdicionView;

@property (weak, nonatomic) IBOutlet UILabel *lbEdicion;

@property (weak, nonatomic) IBOutlet UIWebView *textWebView;
@property (weak, nonatomic) IBOutlet UIButton *btnTestDrive;

- (IBAction)back:(UIButton *)sender;

@end
