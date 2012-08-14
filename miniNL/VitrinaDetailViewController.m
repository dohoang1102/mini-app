//
//  VitrinaDetailViewController.m
//  Mini Colombia
//
//  Created by Juan José Villegas on 7/08/12.
//
//

#import "VitrinaDetailViewController.h"
#import "QuartzCore/QuartzCore.h"

@interface VitrinaDetailViewController ()

@end

@implementation VitrinaDetailViewController

@synthesize vitrina = _vitrina;

@synthesize vitrinaImageView = _vitrinaImageView;
@synthesize scrollView = _scrollView;

@synthesize lbTitulo = _lbTitulo;
@synthesize lbCiudad = _lbCiudad;

@synthesize lbInfoVitrina = _lbInfoVitrina;
@synthesize lbInfoEmpleado = _lbInfoEmpleado;

@synthesize empleadoImageView = _empleadoImageView;

-(void)setVitrina:(Vitrina *)vitrina{
    _vitrina = vitrina;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _vitrinaImageView.image = [UIImage imageNamed:_vitrina.imgVitrina];
    
    //Inicializa informacion de las vitrinas
    
    _lbInfoVitrina.numberOfLines = 0;
    _lbInfoVitrina.text = _vitrina.infoVitrina;
    
    CGSize lbsize = [_lbInfoVitrina.text sizeWithFont:_lbInfoVitrina.font constrainedToSize:_lbInfoVitrina.frame.size lineBreakMode:_lbInfoVitrina.lineBreakMode];
    
    _lbInfoVitrina.frame = CGRectMake(_lbInfoVitrina.frame.origin.x, _lbInfoVitrina.frame.origin.y, _lbInfoVitrina.frame.size.width, lbsize.height);
    
    NSString * newLine = @"\n";
    
    _lbInfoVitrina.text = [_vitrina.infoVitrina stringByReplacingOccurrencesOfString:@"\\n" withString:newLine];
    
    //Inicializa el titilo con el de la ciudad
    
    _lbCiudad.text = [NSString stringWithFormat:@"   %@\n", _vitrina.nombre];
    
    //Inicializa imagen del empleado
    
    _empleadoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 392, 170.0, 115.0)];
    
    [self.scrollView addSubview:_empleadoImageView];
    
    //Inicializa informacion del empleado
    
    _lbInfoEmpleado = [[UILabel alloc] initWithFrame:CGRectMake(_lbInfoVitrina.frame.origin.x, _empleadoImageView.frame.origin.y + _empleadoImageView.bounds.size.height + 10, _lbInfoVitrina.frame.size.width, lbsize.height)];
    
    _lbInfoEmpleado.numberOfLines = 0;
    
    _lbInfoEmpleado.text = [_vitrina.infoEmpleado stringByReplacingOccurrencesOfString:@"\\n" withString:newLine];;
    
    _lbInfoEmpleado.backgroundColor = [UIColor clearColor];
    
    _lbInfoEmpleado.textColor = [UIColor whiteColor];
    
    _lbInfoEmpleado.font = _lbInfoVitrina.font;
    
    [self.scrollView addSubview:_lbInfoEmpleado];
    
    //Cuadra el alto del scrollview
    
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
    
    self.lbCiudad.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.lbCiudad.layer.borderWidth = 4.0;
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"fondo-instrucciones.png"]];
    
    self.scrollView.backgroundColor = background;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setLbTitulo:nil];
    [self setLbCiudad:nil];
    [self setVitrinaImageView:nil];
    [self setScrollView:nil];
    [self setLbInfoEmpleado:nil];
    [self setLbInfoVitrina:nil];
    [self setEmpleadoImageView:nil];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

- (IBAction)back:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
