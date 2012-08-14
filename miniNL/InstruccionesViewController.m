//
//  InstruccionesViewController.m
//  miniNL
//
//  Created by German Villegas on 10/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InstruccionesViewController.h"

@interface InstruccionesViewController ()

@end

@implementation InstruccionesViewController
@synthesize lbTitle =_lbTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.lbTitle.font = [UIFont fontWithName:@"MINIType v2 Regular" size:18];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setLbTitle:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)closeModal:(UIButton *)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}
@end
