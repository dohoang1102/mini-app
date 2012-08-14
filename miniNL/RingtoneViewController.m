//
//  RingtoneViewController.m
//  miniNL
//
//  Created by German Villegas on 5/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RingtoneViewController.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "RingtoneCell.h"
#import "Ringtone.h"
#import "DejalActivityView.h"

@interface RingtoneViewController ()

@end

@implementation RingtoneViewController

@synthesize ringtones = _ringtones;
@synthesize tableView = _tableView;


#pragma mark - View Life Cycle

-(void) viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [DejalActivityView activityViewForView:self.view withLabel:@"Buscando Ringtones..."];
    
    [ApplicationDelegate.descargasEngine descargarRingtonesConURL:@"descargas/darRingtones/" onCompletion:^(NSArray * array, NSInteger num){
        
        _ringtones = array;
        
        [_tableView reloadData];
        _tableView.hidden = NO;
        [DejalActivityView  removeView];
        
    }onError:^(NSError *error){
        
    }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table Management

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RingtoneCell";
    
    RingtoneCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    Ringtone *ringtone = [_ringtones objectAtIndex:indexPath.row];
    
    cell.lbNombre.text = ringtone.nombre;
    
   
    
    cell.ringtone = ringtone;
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.ringtones.count;
}


#pragma mark - Actions

- (IBAction)back:(UIButton *)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}


- (IBAction)descargar:(UIButton *)sender {
    
    RingtoneCell * cell = (RingtoneCell*)[[sender superview] superview];
//    int row = [self.tableView indexPathForCell:cell].row;
    
//    Ringtone *ringtone = [_wallpapers objectAtIndex:row];
    
    Ringtone * ringtone = cell.ringtone;
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Descargando Ringtone..."];
    
    
    
    [ApplicationDelegate.descargasEngine descargarRingtoneConURL:ringtone.archivoURL fileName:ringtone.nombre onCompletion:^(MKNetworkOperation * op){

        
        [DejalBezelActivityView removeView];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Felicitaciones"
                                                        message:@"El ringtone a sido guardado."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
    } onError:^(NSError *error){
        NSLog(@"Hubo un error bajando la imagen ");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                        message:@"Hubo problemas en la descarga. Por favor inténtelo de nuevo"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
    }];

    
}
@end
