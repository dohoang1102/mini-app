//
//  NoticiaDetailViewController.m
//  Mini Colombia
//
//  Created by German Villegas on 17/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NoticiaDetailViewController.h"
#import "AppDelegate.h"
#import "DejalActivityView.h"

@interface NoticiaDetailViewController ()

@end

@implementation NoticiaDetailViewController

@synthesize lbTitulo = _lbTitulo;
@synthesize webView = _webView;
@synthesize pagina = _pagina;
@synthesize noticia = _noticia;

#pragma mark - View Life Cycle

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.lbTitulo.font = [UIFont fontWithName:@"MINIType v2 Regular" size:18];

//    [DejalWhiteActivityView activityViewForView:self.view withLabel:@""];

    [ApplicationDelegate.noticiasEngine noticiaWithURL:_noticia.paginaURL onCompletion:^(NSString *webPage){
        

        
        [self.webView loadHTMLString:webPage baseURL:nil];
    }onError:^(NSError *error){
        NSLog(@"Error de algun tipo");
    }];
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setLbTitulo:nil];
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIWebViewDelegate Methods

- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    _webView.hidden = NO;
    [DejalWhiteActivityView removeView];
}

#pragma mark - Actions

- (IBAction)back:(UIButton *)sender {

    [[self navigationController] popViewControllerAnimated:YES];

}
@end
