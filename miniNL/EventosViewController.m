//
//  EventosViewController.m
//  Mini Colombia
//
//  Created by Juan José Villegas on 6/08/12.
//
//

#import "EventosViewController.h"
#import "ComunidadEngine.h"
#import "AppDelegate.h"
#import "Evento.h"
#import "UIImage+Resize.h"
#import "UIButton+ActivityIndicatorView.h"
#import "DejalActivityView.h"

@interface EventosViewController ()
@property (nonatomic, strong) NSArray * botonesEventos;
@end

@implementation EventosViewController

@synthesize eventos = _eventos;

@synthesize scrollView = _scrollView;
@synthesize lbTitulo = _lbTitulo;

@synthesize botonesEventos = _botonesEventos;

@synthesize btnEvento1 = _btnEvento1;
@synthesize btnEvento2 = _btnEvento2;
@synthesize btnEvento3 = _btnEvento3;
@synthesize btnEvento4 = _btnEvento4;
@synthesize btnEvento5 = _btnEvento5;
@synthesize btnEvento6 = _btnEvento6;
@synthesize btnEvento7 = _btnEvento7;
@synthesize btnEvento8 = _btnEvento8;


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //Agrego activity indicator como subview

    //Inicializo los botones con sus respectivas imagenes
    
    _botonesEventos = [NSArray arrayWithObjects:_btnEvento1,_btnEvento2,_btnEvento3,_btnEvento4,_btnEvento5,_btnEvento6,_btnEvento7,_btnEvento8, nil];
    
    [DejalWhiteActivityView activityViewForView:self.view withLabel:@"Buscando nuevos eventos..."];
    
    [ApplicationDelegate.comunidadEngine descargarNuevosEventos:^(NSArray * eventos){
        
        _eventos = eventos;
        
        for (int i = 0; i < _eventos.count; i++) {
            
            Evento * evento = [_eventos objectAtIndex:i];
            
            NSArray * comp = [evento.posicion componentsSeparatedByString:@"-"];
            
            UIButton * btn= [_botonesEventos objectAtIndex:([[comp objectAtIndex:1] intValue]-1)];
            
            
            [ApplicationDelegate.comunidadEngine descargarImagenConURL:evento.thumbnailURL onCompletion:^(UIImage * img){
                
//                NSArray * comp = [evento.posicion componentsSeparatedByString:@"-"];
//                
//                UIButton * btn= [_botonesEventos objectAtIndex:([[comp objectAtIndex:1] intValue]-1)];
                         
                UIImage * newImage = [img resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:btn.bounds.size interpolationQuality: kCGInterpolationHigh];

                [btn setBackgroundImage:newImage forState:UIControlStateNormal];
                
                btn.hidden = NO;
                
                if (i == (_eventos.count -1)) {
                    [DejalWhiteActivityView removeView];
                }
                
            }onError:^(NSError * error){
                
            }];
        }
  
    }onError:^(NSError * error){
        
    }];
        
    //Inicializa Boton 1
//    Evento * e = [_eventos objectAtIndex:1];
//    
//    [ApplicationDelegate.comunidadEngine descargarImagenConURL:e.thumbnailURL onCompletion:^(UIImage * img){
//        
//        [_btnEvento1 setImage:img forState:UIControlStateNormal];
//        
//    }onError:^(NSError * error){
//        
//    }];
    
    
    //Inicializa Boton 2
    
    //Inicializa Boton 3
    
    //Inicializa Boton 4
    
    //Inicializa Boton 5
    
    //Inicializa Boton 6
    
    //Inicializa Boton 7
    
    //Inicializa Boton 8
    
    //Inicializa scrollView
    
    CGFloat scrollViewHeight = 0.0f;
    
    for (UIView* view in _scrollView.subviews)
    {
        
        
        scrollViewHeight += view.frame.size.height;
        
    }
    
    [_scrollView setContentSize:(CGSizeMake(self.scrollView.frame.size.width, scrollViewHeight))];
    
    _scrollView.contentInset= UIEdgeInsetsMake(0.0, 0.0, 100.0, 0.0);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.lbTitulo.font = [UIFont fontWithName:@"MINIType v2 Regular" size:18];
    
    
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setLbTitulo:nil];
    [self setBtnEvento1:nil];
    [self setBtnEvento2:nil];
    [self setBtnEvento3:nil];
    [self setBtnEvento4:nil];
    [self setBtnEvento5:nil];
    [self setBtnEvento6:nil];
    [self setBtnEvento7:nil];
    [self setBtnEvento8:nil];
    
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)back:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
