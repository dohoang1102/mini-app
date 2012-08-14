//
//  EdicionDetailViewController.m
//  miniNL
//
//  Created by German Villegas on 10/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EdicionDetailViewController.h"
#import "UIImage+Resize.h"
#import "QuartzCore/QuartzCore.h"

@interface EdicionDetailViewController ()

@end

@implementation EdicionDetailViewController

@synthesize edicion = _edicion;
@synthesize lbTitulo = _lbTitulo;
@synthesize imageEdicionView = _imageEdicionView;
@synthesize lbEdicion = _lbEdicion;
@synthesize textWebView = _textWebView;
@synthesize btnTestDrive = _btnTestDrive;


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    //Titulo
    
    self.lbTitulo.font = [UIFont fontWithName:@"MINIType v2 Regular" size:18];
    
    //Nombre edicion
    NSArray *rgb = [self.edicion.templateColor componentsSeparatedByString:@","];
    
    self.lbEdicion.layer.borderWidth = 4.0;
    CGFloat r = [[rgb objectAtIndex:0] floatValue]/255.0;
    CGFloat g = [[rgb objectAtIndex:1] floatValue]/255.0;
    CGFloat b = [[rgb objectAtIndex:2] floatValue]/255.0;
    
    UIColor *color = [UIColor colorWithRed: r green: g  blue: b  alpha:1.0];
    
    self.lbEdicion.layer.borderColor = color.CGColor;
    
    //self.lbEdicion.layer.borderWidth = 4.0;
    self.lbEdicion.textColor = color;
    self.lbEdicion.text = [NSString stringWithFormat:@"  %@", self.edicion.nombre];
    
    //Imagen Edicion
    
    UIImage  *img = [UIImage imageWithContentsOfFile:self.edicion.imagenURL];
    
    self.imageEdicionView.image = [img resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(300, 200) interpolationQuality: kCGInterpolationHigh];
    
    //Texto edicion
     //NSLog(@"Texto de webview: %@", self.edicion.descripcion);
    
    [self.textWebView loadHTMLString:self.edicion.descripcion baseURL:nil];
    
    //TestDrive
    
    if ([self.edicion.testDrive isEqualToNumber:[NSNumber numberWithInt:0]] ) {
        [self.btnTestDrive removeFromSuperview];
        NSLog(@"test drive: %@", self.edicion.testDrive);
    }
    else {
        [self.btnTestDrive setBackgroundColor:color];
        
        
        
        if (r > 0.79) {
            [self.btnTestDrive setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.btnTestDrive setTitleColor:color forState:UIControlStateHighlighted];
        }
        else {
            [self.btnTestDrive setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.btnTestDrive setTitleColor:color forState:UIControlStateHighlighted];
        }
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setLbTitulo:nil];
    [self setImageEdicionView:nil];
    [self setLbEdicion:nil];
    [self setTextWebView:nil];
    [self setBtnTestDrive:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.destinationViewController respondsToSelector:@selector(setCarro:)]) {
        
        [segue.destinationViewController performSelector:@selector(setCarro:) withObject:  _edicion.nombre];
    }
    
}

#pragma mark - UIWebviewDelegate Methods

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    _textWebView.hidden = NO;
}

#pragma mark - Actions

- (IBAction)back:(UIButton *)sender {
    
    [[self navigationController] popViewControllerAnimated:YES];
}
@end
