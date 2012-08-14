//
//  VitrinasMenuViewController.m
//  Mini Colombia
//
//  Created by Juan José Villegas on 7/08/12.
//
//

#import "VitrinasMenuViewController.h"
#import "VitrinaCell.h"
#import "Vitrina.h"


@interface VitrinasMenuViewController ()
@property (strong, nonatomic) NSArray * vitrinas;
@end

@implementation VitrinasMenuViewController

@synthesize lbTitulo = _lbTitulo;
@synthesize ciudadesTableView = _ciudadesTableView;
@synthesize vitrinas = _vitrinas;

#pragma mark - View life Cycle

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [_ciudadesTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.lbTitulo.font = [UIFont fontWithName:@"MINIType v2 Regular" size:18];
    
    _vitrinas = [Vitrina vitrinas];
    [_ciudadesTableView reloadData];
//    self.lbCiudad.text = [NSString stringWithFormat:@"  %@", self.edicion.nombre];

	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setCiudadesTableView:nil];
    [super viewDidUnload];
    [self setLbTitulo:nil];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSIndexPath *indexPath = [_ciudadesTableView indexPathForCell:(UITableViewCell *)sender];
    
    
    Vitrina *vitrina = [_vitrinas objectAtIndex:indexPath.row];
    

    if ([segue.destinationViewController respondsToSelector:@selector(setVitrina:)]) {
        
        [segue.destinationViewController performSelector:@selector(setVitrina:) withObject:vitrina];
    }
    
}

#pragma mark - Table Management

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"VitrinaCell";
    
    VitrinaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Vitrina * vitrina = [ _vitrinas objectAtIndex:indexPath.row];
    
    cell.lbCiudad.text = vitrina.nombreCorto;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _vitrinas.count;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//}

- (IBAction)pushVitrinaDetail:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"VitrinaDetailPush" sender:self];
    
}
@end
