//
//  EdicionesViewController.h
//  miniNL
//
//  Created by German Villegas on 4/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Modelo.h"

@interface EdicionesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) Modelo *modelo;

@property (weak, nonatomic) IBOutlet UILabel *lbTitulo;

@property (weak, nonatomic) IBOutlet UIImageView *imagenModelo;

@property (weak, nonatomic) IBOutlet UITableView *tableEdiciones;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;

// The controller (this class fetches nothing if this is not set).
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)performFetch;

@property (nonatomic) BOOL suspendAutomaticTrackingOfChangesInManagedObjectContext;

// Set to YES to get some debugging output in the console.
@property BOOL debug;

- (IBAction)back:(UIButton *)sender;

@end
