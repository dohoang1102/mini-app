//
//  CategoriaNoticiasViewController.m
//  Mini Colombia
//
//  Created by Juan José on 17/07/12.
//  Copyright (c) 2012 Juan José Villegas. All rights reserved.
//

#import "CategoriaNoticiasViewController.h"
#import "AppDelegate.h"
#import "CategoriaNoticiasCell.h"
#import "Noticia.h"
#import "UIImage+Resize.h"
#import "Noticia+Create.h"
#import "DejalActivityView.h"

@interface CategoriaNoticiasViewController ()
@property (nonatomic) NSArray *noticias;
@end

@implementation CategoriaNoticiasViewController
@synthesize lbCategoria = _lbCategoria;
@synthesize tableView = _tableView;
@synthesize noticias = _noticias;
@synthesize categoria = _categoria;
@synthesize moc = _moc;

-(void)setCategoria:(NSString *)categoria{
    _categoria = categoria;
    
    _lbCategoria.text = categoria;
    
    
}

-(void)setMoc:(NSManagedObjectContext *)moc{
    
    _moc = moc;
    
    [DejalWhiteActivityView activityViewForView:self.view withLabel:@"Buscando..."].showNetworkActivityIndicator = YES;
    
    [ApplicationDelegate.noticiasEngine darNoticiasPorCategoria:_categoria inManagedObjectContext:self.moc onCompletion:^(NSArray * array){
        
        self.noticias = array;
        [self.tableView reloadData];
        [DejalWhiteActivityView removeView];
        
    }onError:^(NSError * error){
        
    }];

}

#pragma mark - View Life Cycle

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.lbCategoria.font = [UIFont fontWithName:@"MINIType v2 Regular" size:18];
    
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setLbCategoria:nil];
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
    static NSString *CellIdentifier = @"CategoriaNoticiasCell";
    
    CategoriaNoticiasCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    

    Noticia *noticia = [self.noticias objectAtIndex:indexPath.row];
    
    cell.thumbnailImageView.image = [[noticia thumbnailImage] resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:cell.thumbnailImageView.bounds.size interpolationQuality: kCGInterpolationHigh];
    
    
    cell.lbTitulo.text = noticia.titulo;
    cell.lbFecha.text = noticia.fecha;
    cell.txtResumen.text = noticia.resumen;
    
    
    return cell;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    
    Noticia *noticia = [self.noticias objectAtIndex:indexPath.row];
    
    // be somewhat generic here (slightly advanced usage)
    // we'll segue to ANY view controller that has a modelo @property
    if ([segue.destinationViewController respondsToSelector:@selector(setPagina:)]) {

        
        [segue.destinationViewController performSelector:@selector(setPagina:) withObject:noticia.paginaURL];
        [segue.destinationViewController performSelector:@selector(setNoticia:) withObject:noticia];
        
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.noticias.count;
}

#pragma mark - Actions

- (IBAction)back:(UIButton *)sender {
    
    [[self navigationController] popViewControllerAnimated:YES];
    
}
@end
