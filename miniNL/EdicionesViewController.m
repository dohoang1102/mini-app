//
//  EdicionesViewController.m
//  miniNL
//
//  Created by German Villegas on 4/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EdicionesViewController.h"
#import "Edicion.h"
#import "EdicionCell.h"
#import "UIImage+Resize.h"

@interface EdicionesViewController ()
@property (nonatomic) BOOL beganUpdates;
@end

@implementation EdicionesViewController

#pragma mark - Properties

@synthesize lbTitulo = _lbTitulo;
@synthesize imagenModelo = _imagenModelo;
@synthesize tableEdiciones = _tableEdiciones;
@synthesize imageScrollView = _imageScrollView;
@synthesize modelo = _modelo;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize suspendAutomaticTrackingOfChangesInManagedObjectContext = _suspendAutomaticTrackingOfChangesInManagedObjectContext;
@synthesize debug = _debug;
@synthesize beganUpdates = _beganUpdates;

#pragma mark - View Management

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupFetchedResultsController];
    
    self.imagenModelo.image = [UIImage imageWithContentsOfFile:self.modelo.imagenURL];
    
    self.lbTitulo.font = [UIFont fontWithName:@"MINIType v2 Regular" size:18];
    
    self.lbTitulo.text = [self.modelo.nombre uppercaseString];
    
    self.imageScrollView.contentSize = self.imagenModelo.image.size;
    
    self.imagenModelo.frame = CGRectMake(0, 0, self.imagenModelo.image.size.width, self.imagenModelo.image.size.height);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setImagenModelo:nil];
    [self setLbTitulo:nil];
    [self setTableEdiciones:nil];
    [self setImageScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return NO;
}

#pragma mark - Table Management

- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Edicion"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"nombre" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    // no predicate because we want ALL the Photographers
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.modelo.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EdicionCell";
    
    EdicionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        //cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
//    }
    
    
    
    // ask NSFetchedResultsController for the NSMO at the row in question
    Edicion *edicion = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Then configure the cell using it ...
    //cell.textLabel.text = modelo.nombre;
    UIImage  *img = [UIImage imageWithContentsOfFile:edicion.thumbnailURL];
    cell.edicionImageView.image = [img resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(115   , 96) interpolationQuality: kCGInterpolationHigh];
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos", [modelo.photos count]];
    
    return cell;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableEdiciones indexPathForCell:sender];
    Edicion *edicion = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // be somewhat generic here (slightly advanced usage)
    // we'll segue to ANY view controller that has a modelo @property
    if ([segue.destinationViewController respondsToSelector:@selector(setEdicion:)]) {
        // use performSelector:withObject: to send without compiler checking
        // (which is acceptable here because we used introspection to be sure this is okay)
        [segue.destinationViewController performSelector:@selector(setEdicion:) withObject:edicion];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 98;
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
    [self.tableEdiciones reloadData];
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
            [self.tableEdiciones reloadData];
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


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext) {
        [self.tableEdiciones beginUpdates];
        self.beganUpdates = YES;
    }
}


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
                [self.tableEdiciones insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.tableEdiciones deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
                [self.tableEdiciones reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeMove:
                [self.tableEdiciones deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableEdiciones insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (self.beganUpdates) [self.tableEdiciones endUpdates];
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



- (IBAction)back:(UIButton *)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}
@end
