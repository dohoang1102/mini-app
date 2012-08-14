//
//  NoticiaDetailViewController.h
//  Mini Colombia
//
//  Created by German Villegas on 17/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Noticia+Create.h"

@interface NoticiaDetailViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, strong) NSString * pagina;
@property (nonatomic, strong) Noticia * noticia;
@property (weak, nonatomic) IBOutlet UILabel *lbTitulo;
@property (weak, nonatomic) IBOutlet UIWebView *webView;


- (IBAction)back:(UIButton *)sender;

@end
