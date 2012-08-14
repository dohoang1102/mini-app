//
//  CoreDataViewController.h
//  Mini Colombia
//
//  Created by German Villegas on 16/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataViewController : UIViewController <NSFetchedResultsControllerDelegate, UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView * tableView;

// The controller (this class fetches nothing if this is not set).
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)performFetch;

@property (nonatomic) BOOL suspendAutomaticTrackingOfChangesInManagedObjectContext;

// Set to YES to get some debugging output in the console.
@property BOOL debug;


@end
