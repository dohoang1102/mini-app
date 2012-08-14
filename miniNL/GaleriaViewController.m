//
//  GaleriaViewController.m
//  Mini Colombia
//
//  Created by Juan José Villegas on 6/08/12.
//
//

#import "GaleriaViewController.h"
#import "ImagenGridViewCell.h"
#import "AppDelegate.h"
#import "DejalActivityView.h"

@interface GaleriaViewController ()

@end

@implementation GaleriaViewController

@synthesize gridView = _gridView;
@synthesize lbTitulo = _lbTitulo;
@synthesize imagenes = _imagenes;


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if (!_imagenes) {
        [DejalWhiteActivityView activityViewForView:self.view withLabel:@"Buscando Imagenes..."];
    }
    
    [ApplicationDelegate.comunidadEngine descargarImagenesGaleria:^(NSArray *array){
       
        _imagenes = array;
        [_gridView reloadData];
        [DejalWhiteActivityView removeView];
    }onError:^(NSError *error){
        
        NSLog(@"Hubo un error en comunidad engine");
        
    }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.lbTitulo.font = [UIFont fontWithName:@"MINIType v2 Regular" size:18];
    
    self.gridView = [[AQGridView alloc] initWithFrame:CGRectMake(10.0, 96.0, 300, 364)];
    
    self.gridView.delegate = self;
    self.gridView.dataSource = self;
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.gridView.autoresizesSubviews = YES;
    
    [self.view addSubview:_gridView];
    
    [_gridView reloadData];
    
}

- (void)viewDidUnload
{
    [self setLbTitulo:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.gridView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Grid View Data Source

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) aGridView
{
    return _imagenes.count;
}

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString * ImagenCellIdentifier = @"ImagenCellIdentifier";
    static NSString * VerMasCellIdentifier = @"VerMasCell";
    
    ImagenGridViewCell *cell = (ImagenGridViewCell *) [aGridView dequeueReusableCellWithIdentifier:ImagenCellIdentifier];
    
    if (cell == nil) {
        cell = [[ImagenGridViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, 145, 144) reuseIdentifier:ImagenCellIdentifier];
    }
    
    cell.imagenGaleria = [_imagenes objectAtIndex:index];
    
//    cell.imageView.image = [_imagenes objectAtIndex:index];
    
    return cell;
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return CGSizeMake(145.0, 146.0);
}

-(void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index{

    [self performSegueWithIdentifier:@"ImagenDetailPush" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSUInteger index = [self.gridView indexOfSelectedItem];
    
    ImagenGaleria * imagenGaleria = [_imagenes objectAtIndex:index];
    
    if ([segue.destinationViewController respondsToSelector:@selector(setImagenGaleria:)]) {
        
        [segue.destinationViewController performSelector:@selector(setImagenGaleria:) withObject:imagenGaleria];
        [segue.destinationViewController performSelector:@selector(setTotal:) withObject: [NSNumber numberWithUnsignedInteger:_imagenes.count]];
        [segue.destinationViewController performSelector:@selector(setActual:) withObject: [NSNumber numberWithInteger:index+1]];
        
        
    }
}

#pragma mark - Actions

- (IBAction)back:(UIButton *)sender {
    
    [[self navigationController] popViewControllerAnimated:YES];
}
@end
