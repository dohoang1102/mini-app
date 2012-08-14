//
//  ComunidadRootViewController.m
//  Mini Colombia
//
//  Created by Juan José Villegas on 6/08/12.
//
//

#import "ComunidadRootViewController.h"

@interface ComunidadRootViewController ()

@end

@implementation ComunidadRootViewController
@synthesize lbTitulo;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.lbTitulo.font = [UIFont fontWithName:@"MINIType v2 Regular" size:18];
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

@end
