//
//  WallpapersViewController.m
//  miniNL
//
//  Created by German Villegas on 5/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WallpapersViewController.h"
#import "WallpaperCell.h"
#import "Wallpaper.h"
#import "UIImage+Resize.h"
#import "AppDelegate.h"
#import "DejalActivityView.h"
#import "VerMasCell.h"

@interface WallpapersViewController ()
@property (nonatomic) NSInteger numWallpapers;
@end

@implementation WallpapersViewController

@synthesize wallpapers = _wallpapers;
@synthesize lbTitulo = _lbTitulo;
@synthesize tableView = _tableView;
@synthesize numWallpapers = _numWallpapers;

#pragma mark - View Life Cycle

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.lbTitulo.font = [UIFont fontWithName:@"MINIType v2 Regular" size:18];
    
    if ( !self.wallpapers) {
        [DejalActivityView activityViewForView:self.view withLabel:@"Cargando..."];
        
        [ApplicationDelegate.descargasEngine descargarWallpapersConURL:@"descargas/darUltimosWallpapers/" onCompletion:^(NSArray * array, NSInteger numWallpapers){
            
            _wallpapers = [NSMutableArray arrayWithArray:array] ;
            
            _numWallpapers = numWallpapers;
            
            [_tableView reloadData];
            
            [DejalActivityView removeView];
            
        }onError:^(NSError *error){
            [DejalActivityView removeView];
        }];
        
        
        
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
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table Management

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WallpaperCell";
    
    static NSString *VerMasCellIdentifier = @"VerMasCell";
    
    if (indexPath.row == _wallpapers.count) {
        VerMasCell *cell = [tableView dequeueReusableCellWithIdentifier:VerMasCellIdentifier];
        
        return cell;
    }
    
    WallpaperCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Wallpaper *wallpaper = [self.wallpapers objectAtIndex:indexPath.row];
    
    cell.wallpaper = wallpaper;
    
    return cell;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    
    Wallpaper *wallpaper = [self.wallpapers objectAtIndex:indexPath.row];
    
    // be somewhat generic here (slightly advanced usage)
    // we'll segue to ANY view controller that has a modelo @property
    if ([segue.destinationViewController respondsToSelector:@selector(setWallpaper:)]) {
        
        
//        [segue.destinationViewController performSelector:@selector(setPagina:) withObject:noticia.paginaURL];
        [segue.destinationViewController performSelector:@selector(setWallpaper:) withObject:wallpaper];
        [segue.destinationViewController performSelector:@selector(setTotal:) withObject: [NSNumber numberWithInteger:_numWallpapers]];
        [segue.destinationViewController performSelector:@selector(setActual:) withObject: [NSNumber numberWithInteger:indexPath.row+1]];
        
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return ( self.wallpapers.count +1 );
}

#pragma mark - Actions

- (IBAction)verMas:(UIButton *)sender {

    if (_wallpapers.count >= _numWallpapers) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lo siento"
                                                        message:@"No hay más wallpapers para descargar"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else{
        
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Buscando más Wallpapers..."];
        
        [ApplicationDelegate.descargasEngine descargarWallpapersConURL:[NSString stringWithFormat:@"descargas/darSiguientesWallpapers/%d", _wallpapers.count ] onCompletion:^(NSArray * array, NSInteger numWallpapers){
            
            BOOL encontrado = false;
            
            Wallpaper * w = [array objectAtIndex:0];
            
            for (int i = 0; i < _wallpapers.count && !encontrado; i++) {
                
                Wallpaper * wallpaper = [_wallpapers objectAtIndex:i];
                
                if ( [wallpaper.nombre isEqualToString:w.nombre] ) {
                    encontrado = true;
                }
            }
            
            if (encontrado) {
                
                [_wallpapers replaceObjectsInRange:NSMakeRange((_wallpapers.count-array.count), array.count) withObjectsFromArray:array];
            }
            else{
                [_wallpapers addObjectsFromArray:array];
            }
            
            
            [_tableView reloadData];
            [DejalBezelActivityView removeViewAnimated:YES];
            
            
        }onError:^(NSError *error){
            [DejalBezelActivityView removeViewAnimated:YES];
        }];
        
    }
    
    
    
}

- (IBAction)back:(UIButton *)sender {
    
    [[self navigationController] popViewControllerAnimated:YES];
    
}

- (IBAction)descargar:(UIButton *)sender {
    
    WallpaperCell * cell = (WallpaperCell*)[[sender superview] superview];
    int row = [self.tableView indexPathForCell:cell].row;
    
    Wallpaper *wallpaper = [_wallpapers objectAtIndex:row];
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Descargando Imagen..."];
    
    [ApplicationDelegate.descargasEngine descargarImagenConURL:wallpaper.imagenURL onCompletion:^(UIImage * imagen){
        
        UIImageWriteToSavedPhotosAlbum(imagen, nil, nil, nil);
        
        [DejalBezelActivityView removeView];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Felicitaciones"
                                                        message:@"El wallpaper a sido guardado en la galeria de imágenes."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
    } onError:^(NSError *error){
        NSLog(@"Hubo un error bajando la imagen ");
    }];
}

@end
