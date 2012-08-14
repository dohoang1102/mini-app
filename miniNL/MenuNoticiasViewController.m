//
//  MenuNoticiasViewController.m
//  Mini Colombia
//
//  Created by German Villegas on 16/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuNoticiasViewController.h"
#import "Noticia+Create.h"
#import "NoticiaCell.h"
#import "UIImage+Resize.h"
#import "DejalActivityView.h"


@interface MenuNoticiasViewController ()

@end

@implementation MenuNoticiasViewController

@synthesize noticiasDB = _noticiasDB;
@synthesize lbTitulo = _lbTitulo;


#pragma mark - Core Data Comunication

-(NSDictionary *) executeRequest:(NSString *) query{
    
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    
    return results;
}

-(void) fetchUltimasNoticias:(UIManagedDocument *) document withUpdating: (BOOL) updating{
    
    NSString *query = [NSString stringWithFormat:@"http://minicolombia.herokuapp.com/noticias/darUltimasNoticias/%@/", [Noticia getTimestamp] ];
    
    NSDictionary *root = [self executeRequest:query];
    
    [Noticia setTimestamp:[root valueForKey:@"timestamp"]];
    
    BOOL hayActualizaciones = [[root valueForKey:@"hayActualizaciones"] boolValue];
    
    if (hayActualizaciones) {
        //Recorro el arreglo de noticias y los agrego a la base de datos
        [DejalBezelActivityView currentActivityView].activityLabel.text = @"Descargando Contenido...";
        dispatch_queue_t fetchQ = dispatch_queue_create("Noticias Fetcher", NULL);
        dispatch_async(fetchQ, ^{
            
            NSArray *noticias = [root valueForKey:@"noticias"];
            [document.managedObjectContext performBlock:^{ // perform in the NSMOC's safe thread (main thread)
                for (NSDictionary *noticiaInfo in noticias) {
                    
                    if (updating) {
                        [Noticia updateNoticiaWithInfo:noticiaInfo inManagedObjectContext:document.managedObjectContext];
                    } else {
                        [Noticia noticiaWithInfo:noticiaInfo inManagedObjectContext:document.managedObjectContext saveContext:YES];
                    }
                    
                    
                }
                
                [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
                
                if(!updating){
                    [ DejalBezelActivityView removeViewAnimated:YES ];
                }
                
            }];
        });
        dispatch_release(fetchQ);
    }
    
}

-(BOOL)reachable {
    Reachability *r = [Reachability reachabilityWithHostname:@"minicolombia.herokuapp.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        return NO;
    }
    return YES;
}

- (void)useDocument
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.noticiasDB.fileURL path]]) {
        // does not exist on disk, so create it
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Buscando Actualizaciones..."].showNetworkActivityIndicator = YES;
        [self.noticiasDB saveToURL:self.noticiasDB.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            
            
            if ([self reachable]) {
                
                [Noticia setTimestamp:[NSString stringWithFormat:@"%d",0]];
                [self fetchUltimasNoticias:self.noticiasDB withUpdating:NO];
            }

            
            
            [self setupFetchedResultsController];
            
        }];
    } else if (self.noticiasDB.documentState == UIDocumentStateClosed) {
        // exists on disk, but we need to open it
        [DejalWhiteActivityView activityViewForView:self.view withLabel:@"Cargando..."];
        [self.noticiasDB openWithCompletionHandler:^(BOOL success) {
            
            if ([self reachable]) {
                dispatch_queue_t fetchQ = dispatch_queue_create("Setup Fetch Controller", NULL);
                dispatch_async(fetchQ, ^{
                    
                    [self fetchUltimasNoticias:self.noticiasDB withUpdating:YES];
                });
                dispatch_release(fetchQ);
            }
            
            
            
            [self setupFetchedResultsController];
            
            [DejalWhiteActivityView removeView];

        }];
    } else if (self.noticiasDB.documentState == UIDocumentStateNormal) {
        // already open and ready to use
        [self fetchUltimasNoticias:self.noticiasDB withUpdating:YES];

        
        dispatch_queue_t fetchQ = dispatch_queue_create("Setup Fetchecontroller", NULL);
        dispatch_async(fetchQ, ^{
            [self setupFetchedResultsController];
            
        });
        dispatch_release(fetchQ);
        
    }
}

- (void)setNoticiasDB:(UIManagedDocument *)noticiasDB
{
    if (_noticiasDB != noticiasDB) {
        _noticiasDB = noticiasDB;
        [self useDocument];
    }
}

#pragma mark - View Management

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.lbTitulo.font = [UIFont fontWithName:@"MINIType v2 Regular" size:18];
    
    if(!self.noticiasDB){
        
        
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Noticias Database"];
                
        
        // url is now "<Documents Directory>/Default Photo Database"
        self.noticiasDB = [[UIManagedDocument alloc] initWithFileURL:url]; // setter will create this for us on disk 
        
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

#pragma mark - Table Management


- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Noticia"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"categoria" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    // no predicate because we want ALL the Photographers
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.noticiasDB.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NoticiaCell";
    
    NoticiaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

   
    
    // ask NSFetchedResultsController for the NSMO at the row in question
    Noticia *noticia = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // Then configure the cell using it ...
    
    
    UIImage *img = [UIImage imageWithContentsOfFile:noticia.thumbnailURL];
    
    cell.thumbnailImageView.image = [img resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:cell.thumbnailImageView.bounds.size interpolationQuality: kCGInterpolationHigh];
    

    cell.lbTitulo.text = noticia.titulo;
    cell.lbFecha.text = noticia.fecha;
    cell.lbCategoria.text = noticia.categoria;
    cell.txtResumen.text = noticia.resumen;
    
    
    if ([noticia.categoria isEqualToString:@"Noticia Internacional."]) {
        [cell.btnVerMas setTitle:@"Ver más noticias internacionales" forState:UIControlStateNormal];
    }
    else if ([noticia.categoria isEqualToString:@"Noticia Nacional."]) {
        [cell.btnVerMas setTitle:@"Ver más noticias nacionales" forState:UIControlStateNormal];
    }
    else if ([noticia.categoria isEqualToString:@"Promoción."]) {
        [cell.btnVerMas setTitle:@"Ver más promociones" forState:UIControlStateNormal];
    }
    else if ([noticia.categoria isEqualToString:@"Novedad."]) {
        [cell.btnVerMas setTitle:@"Ver más novedades" forState:UIControlStateNormal];
    }
    
//    [cell.btnVerMas setTitle:[[[NSString stringWithFormat:@"Ver más %@", noticia.categoria] lowercaseString] capitalizedString] forState:UIControlStateNormal];
    
    return cell;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    UIButton *button = (UIButton *)sender;
    // Get the UITableViewCell which is the superview of the UITableViewCellContentView which is the superview of the UIButton
    NoticiaCell * cell = (NoticiaCell*)[[button superview] superview];
    int row = [self.tableView indexPathForCell:cell].row;
    
    Noticia *noticia = [[self.fetchedResultsController fetchedObjects] objectAtIndex:row];
    
    // be somewhat generic here (slightly advanced usage)
    // we'll segue to ANY view controller that has a modelo @property
    if ([segue.destinationViewController respondsToSelector:@selector(setPagina:)]) {
        // use performSelector:withObject: to send without compiler checking
        // (which is acceptable here because we used introspection to be sure this is okay)
        
        
        [segue.destinationViewController performSelector:@selector(setPagina:) withObject:noticia.paginaURL];
        [segue.destinationViewController performSelector:@selector(setNoticia:) withObject:noticia];
        
    }
    else if ([segue.destinationViewController respondsToSelector:@selector(setCategoria:)]) {
        // use performSelector:withObject: to send without compiler checking
        // (which is acceptable here because we used introspection to be sure this is okay)
        [segue.destinationViewController performSelector:@selector(setCategoria:) withObject:noticia.categoria];
        [segue.destinationViewController performSelector:@selector(setMoc:) withObject:_noticiasDB.managedObjectContext];
    }
}

@end
