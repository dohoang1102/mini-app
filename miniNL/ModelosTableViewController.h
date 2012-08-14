//
//  ModelosTableViewController.h
//  miniNL
//
//  Created by German Villegas on 3/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface ModelosTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>{
    
    UITableView *tableModelos;
}
- (IBAction)back:(UIButton *)sender;

@property (nonatomic, strong) UIManagedDocument *familiaMiniDB;

@property (nonatomic, strong) IBOutlet UITableView *tableModelos;

@property (weak, nonatomic) IBOutlet UILabel *lbTitulo;



// The controller (this class fetches nothing if this is not set).
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)performFetch;

@property (nonatomic) BOOL suspendAutomaticTrackingOfChangesInManagedObjectContext;

// Set to YES to get some debugging output in the console.
@property BOOL debug;


@end
