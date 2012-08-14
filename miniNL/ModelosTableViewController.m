//
//  ModelosTableViewController.m
//  miniNL
//
//  Created by German Villegas on 3/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ModelosTableViewController.h"
#import "Modelo+FamiliaMini.h"
#import "Edicion+FamiliaMini.h"
#import "EdicionesViewController.h"
#import "UIImage+Resize.h"
#import "ModelosCell.h"
#import "DejalActivityView.h"


#define CREATE @"CREATE"
#define DELETE @"DELETE"
#define UPDATE @"UPDATE"


@interface ModelosTableViewController ()
@property (nonatomic) BOOL beganUpdates;
@end

@implementation ModelosTableViewController

#pragma mark - Properties

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize suspendAutomaticTrackingOfChangesInManagedObjectContext = _suspendAutomaticTrackingOfChangesInManagedObjectContext;
@synthesize debug = _debug;
@synthesize beganUpdates = _beganUpdates;

@synthesize tableModelos;
@synthesize lbTitulo = _lbTitulo;
@synthesize familiaMiniDB = _familiaMiniDB;

#pragma mark - Core Data Comunication

-(NSDictionary *) executeRequest:(NSString *) query{
    
    // NSLog(@"[%@ %@] sent %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), query);
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    
    NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), results);
    
    return results;
}

-(void) fetchModelos:(UIManagedDocument *) document{
    
    NSString *query = @"http://minicolombia.herokuapp.com/familiaMini/dar-modelos/";
    
    //Recorro el arreglo de modelos y los agrego a la base de datos
    [DejalBezelActivityView currentActivityView].activityLabel.text = @"Descargando Contenido...";
    dispatch_queue_t fetchQ = dispatch_queue_create("Modelo Fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSDictionary *root = [self executeRequest:query];
        NSArray *modelos = [root valueForKey:MODELOS];
        [document.managedObjectContext performBlock:^{ // perform in the NSMOC's safe thread (main thread)
            for (NSDictionary *modelo in modelos) {
                NSArray *ediciones = [modelo valueForKey:@"ediciones"];
                
                [Modelo saveModelo:modelo withEdiciones:ediciones inContext:document.managedObjectContext];
                // table will automatically update due to NSFetchedResultsController's observing of the NSMOC
            }
            // should probably saveToURL:forSaveOperation:(UIDocumentSaveForOverwriting)completionHandler: here!
            // we could decide to rely on UIManagedDocument's autosaving, but explicit saving would be better
            // because if we quit the app before autosave happens, then it'll come up blank next time we run
            // this is what it would look like (ADDED AFTER LECTURE) ...
            [Modelo setTimestamp:[root objectForKey:TIMESTAMP]];
            NSLog(@"Timestamp tomado %@", [Modelo getTimestamp]);
            [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
            // note that we don't do anything in the completion handler this time
            //[_activityIndicator stopAnimating];
            [ DejalBezelActivityView removeViewAnimated:YES ]; 
        }];
    });
    dispatch_release(fetchQ);

}


-(void) actualizarModelos:(UIManagedDocument *) familiaMiniDB{
    
    NSDictionary *root = [self executeRequest:[NSString stringWithFormat:@"http://minicolombia.herokuapp.com/familiaMini/hayNuevosModelos/%@",[Modelo getTimestamp]]];
    
    //Agrego timestamp al plist
    [Modelo setTimestamp:[root valueForKey:TIMESTAMP]];
    
    //Miro si hay actualizaciones
    BOOL hayActualizaciones = [[root valueForKey:HAY_ACTUALIZACIONES]boolValue];
    
    
    
    if(hayActualizaciones){
        //recorro el arreglo de las actualizaciones y grabo en la base de datos
        //[DejalBezelActivityView currentActivityView].activityLabel.text = @"Actualizando...";
        
        dispatch_queue_t fetchQ = dispatch_queue_create("Actualizaciones", NULL);
        dispatch_async(fetchQ, ^{
            NSArray *actualizaciones = [root valueForKey:@"actualizaciones"];
            [familiaMiniDB.managedObjectContext performBlock:^{ 
                
                for (NSDictionary *actualizacion in actualizaciones) {
                    
                    //Miro la accion
                    
                    NSString *accion = [actualizacion valueForKey:@"accion"];
                    NSString *tipo = [actualizacion valueForKey:@"tipo"];
                    
                    
                    if( [ accion isEqualToString:CREATE] ){
                        if([tipo isEqualToString:@"modelo"]){
                            [Modelo saveModeloWithInfo:[actualizacion valueForKey:@"modelo"] inManagedObjectContext:familiaMiniDB.managedObjectContext];
                        }
                        else {
                            [Edicion edicionForModelo:[Modelo buscarModeloPorNombre:[actualizacion valueForKeyPath:@"edicion.nombre_modelo"] inManagedObjectContext:familiaMiniDB.managedObjectContext] andInfo:[actualizacion valueForKey:@"edicion"] inManagedObjectContext:familiaMiniDB.managedObjectContext];
                        }
                        
                    }
                    else if ([accion isEqualToString:DELETE] ) {
                        
                        if( [tipo isEqualToString:@"modelo"] ){
                            
                            [Modelo deleteModelo:[actualizacion valueForKey:@"nombre"] inManagedObjectContext:familiaMiniDB.managedObjectContext];
                        }
                        else {
                            [Edicion deleteEdicion:[actualizacion valueForKey:@"nombre"] inManagedObjectContext:familiaMiniDB.managedObjectContext];
                        }
                    }
                    else if ([accion isEqualToString:UPDATE]) {
                        
                        if( [tipo isEqualToString:@"modelo"] ){
                            
                            [Modelo updateModelo:[actualizacion objectForKey:@"nombre"] forModeloInfo:[actualizacion objectForKey:@"modelo"] inManagedObjectContext:familiaMiniDB.managedObjectContext];
                        }
                        else {
                            [Edicion updateEdicion:[actualizacion valueForKey:@"nombre"] forNewInfo:[actualizacion objectForKey:@"edicion"] inManagedObjectContext:familiaMiniDB.managedObjectContext];
                        }
                    }
                }
                
                [Modelo setTimestamp:[root objectForKey:TIMESTAMP]];
                NSLog(@"Timestamp tomado %@", [Modelo getTimestamp]);
                [familiaMiniDB saveToURL:familiaMiniDB.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
                // note that we don't do anything in the completion handler this time

                //[_activityIndicator stopAnimating];
                //[DejalBezelActivityView removeViewAnimated:YES];
            }];
            
        });
        dispatch_release(fetchQ);
    }
    else {
        //[_activityIndicator stopAnimating];
        //[DejalBezelActivityView removeViewAnimated:YES];
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
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.familiaMiniDB.fileURL path]]) {
        // does not exist on disk, so create it
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Buscando Actualizaciones..."].showNetworkActivityIndicator = YES;
        [self.familiaMiniDB saveToURL:self.familiaMiniDB.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            
            //[self setupFetchedResultsController];
            if ([self reachable]) {
                [self fetchModelos:self.familiaMiniDB];
            }
            
            [self setupFetchedResultsController];
            
        }];
    } else if (self.familiaMiniDB.documentState == UIDocumentStateClosed) {
        // exists on disk, but we need to open it
        [DejalWhiteActivityView activityViewForView:self.view withLabel:@"Cargando..."];
        [self.familiaMiniDB openWithCompletionHandler:^(BOOL success) {
            
            if ([self reachable]) {
                dispatch_queue_t fetchQ = dispatch_queue_create("Setup Fetchecontroller", NULL);
                dispatch_async(fetchQ, ^{
                    
                    [self actualizarModelos:self.familiaMiniDB];
                });
                dispatch_release(fetchQ);
            }
            
            [self setupFetchedResultsController];
            
            [DejalWhiteActivityView removeView];
            
        }];
    } else if (self.familiaMiniDB.documentState == UIDocumentStateNormal) {
        // already open and ready to use
        [self actualizarModelos:self.familiaMiniDB];
        dispatch_queue_t fetchQ = dispatch_queue_create("Setup Fetchecontroller", NULL);
        dispatch_async(fetchQ, ^{
            [self setupFetchedResultsController];
            
        });
        dispatch_release(fetchQ);
        
    }
}

- (void)setFamiliaMiniDB:(UIManagedDocument *)familiaMiniDB
{
    if (_familiaMiniDB != familiaMiniDB) {
        _familiaMiniDB = familiaMiniDB;
        [self useDocument];
    }
}

#pragma mark - View Management

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.lbTitulo.font = [UIFont fontWithName:@"MINIType v2 Regular" size:18];
    if(!self.familiaMiniDB){
        
        
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Familia Database"];
        
        //NSURL *url = [NSURL fileURLWithPath:@"/db/Familia Database"];
        
        
        
        // url is now "<Documents Directory>/Default Photo Database"
        self.familiaMiniDB = [[UIManagedDocument alloc] initWithFileURL:url]; // setter will create this for us on disk 
        
        //[ _activityIndicator startAnimating];
        
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table Management


- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Modelo"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"nombre" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    // no predicate because we want ALL the Photographers
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.familiaMiniDB.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ModeloCell";
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    ModelosCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
//    if (cell == nil) {
////        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        
//        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"ModelosCell" owner:nil options:nil];
//        
//        for (id currentObject in topLevelObjects) {
//            if([currentObject isKindOfClass: [UITableViewCell class]])
//            {
//                cell = (ModelosCell *) currentObject;
//                break;
//            }
//        }
//        //cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
//                                    
//    }
    
    // ask NSFetchedResultsController for the NSMO at the row in question
    Modelo *modelo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // Then configure the cell using it ...
    //cell.textLabel.text = modelo.nombre;
    
    UIImage *img = [UIImage imageWithContentsOfFile:modelo.thumbnailURL];
    
//    CGRect screenBounds = [[UIScreen mainScreen] bounds];
//    
//    CGFloat screenScale = [[UIScreen mainScreen] scale];
    
    
    
//    cell.imageView.image = [img resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(295   , 135) interpolationQuality: kCGInterpolationHigh];
    cell.imagenModelo.image = [img resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(300   , 130) interpolationQuality: kCGInterpolationHigh];
    
//    cell.imageView.image = [UIImage imageWithCGImage:[img CGImage] scale:1.8 orientation:UIImageOrientationUp];
    
    return cell;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableModelos indexPathForCell:sender];
    Modelo *modelo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // be somewhat generic here (slightly advanced usage)
    // we'll segue to ANY view controller that has a modelo @property
    if ([segue.destinationViewController respondsToSelector:@selector(setModelo:)]) {
        // use performSelector:withObject: to send without compiler checking
        // (which is acceptable here because we used introspection to be sure this is okay)
        [segue.destinationViewController performSelector:@selector(setModelo:) withObject:modelo];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 225;
}

#pragma mark - Fetching

- (void)performFetch
{
    if (self.fetchedResultsController) {
        if (self.fetchedResultsController.fetchRequest.predicate) {
            if (self.debug) NSLog(@"[%@ %@] fetching %@ with predicate: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultsController.fetchRequest.entityName, self.fetchedResultsController.fetchRequest.predicate);
        } else {
            if (self.debug) NSLog(@"[%@ %@] fetching all %@ (i.e., no predicate)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultsController.fetchRequest.entityName);
        }
        NSError *error;
        [self.fetchedResultsController performFetch:&error];
        if (error) NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
    } else {
        if (self.debug) NSLog(@"[%@ %@] no NSFetchedResultsController (yet?)", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    }
    [self.tableModelos reloadData];
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)newfrc
{
    NSFetchedResultsController *oldfrc = _fetchedResultsController;
    if (newfrc != oldfrc) {
        _fetchedResultsController = newfrc;
        newfrc.delegate = self;
//        if ((!self.title || [self.title isEqualToString:oldfrc.fetchRequest.entity.name]) && (!self.navigationController || !self.navigationItem.title)) {
//            self.title = newfrc.fetchRequest.entity.name;
//        }
        if (newfrc) {
            if (self.debug) NSLog(@"[%@ %@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), oldfrc ? @"updated" : @"set");
            [self performFetch]; 
        } else {
            if (self.debug) NSLog(@"[%@ %@] reset to nil", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
            [self.tableModelos reloadData];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//	return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
//}

//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//	return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
//}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return [self.fetchedResultsController sectionIndexTitles];
//}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext) {
        [self.tableModelos beginUpdates];
        self.beganUpdates = YES;
    }
}

//- (void)controller:(NSFetchedResultsController *)controller
//  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
//		   atIndex:(NSUInteger)sectionIndex
//	 forChangeType:(NSFetchedResultsChangeType)type
//{
//    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
//    {
//        switch(type)
//        {
//            case NSFetchedResultsChangeInsert:
//                [self.tableModelos insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//                break;
//                
//            case NSFetchedResultsChangeDelete:
//                [self.tableModelos deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//                break;
//        }
//    }
//}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{		
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
    {
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                [self.tableModelos insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.tableModelos deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
                [self.tableModelos reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeMove:
                [self.tableModelos deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableModelos insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (self.beganUpdates) [self.tableModelos endUpdates];
}

- (void)endSuspensionOfUpdatesDueToContextChanges
{
    _suspendAutomaticTrackingOfChangesInManagedObjectContext = NO;
}

- (void)setSuspendAutomaticTrackingOfChangesInManagedObjectContext:(BOOL)suspend
{
    if (suspend) {
        _suspendAutomaticTrackingOfChangesInManagedObjectContext = YES;
    } else {
        [self performSelector:@selector(endSuspensionOfUpdatesDueToContextChanges) withObject:0 afterDelay:0];
    }
}

#pragma mark - Acciones

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
