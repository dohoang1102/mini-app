//
//  DescargasRootViewController.m
//  miniNL
//
//  Created by German Villegas on 5/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DescargasRootViewController.h"
#import "Wallpaper.h"
#import "Ringtone.h"

@interface DescargasRootViewController ()
//@property (nonatomic) NSArray *wallpapers;
//@property (nonatomic) NSArray *ringtones;
@end

@implementation DescargasRootViewController

//@synthesize wallpapers,ringtones;
@synthesize lbTitulo;

-(NSDictionary *) executeRequest:(NSString *) query{
    
    // NSLog(@"[%@ %@] sent %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), query);
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    
    NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), results);
    
    return results;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.lbTitulo.font = [UIFont fontWithName:@"MINIType v2 Regular" size:18];
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


//-(NSArray *) fetchWallpapers{
//    
//    NSMutableArray *resp = [[NSMutableArray alloc] init];
//    
//    NSArray *wallpapersArray = [[self executeRequest:[NSString stringWithFormat:@"http://minicolombia.herokuapp.com/descargas/darUltimosWallpapers/%d/",NUM_WALLPAPERS]] valueForKey:@"wallpapers"];
//    
//    
//    for (NSDictionary *wallpaper in wallpapersArray){
//        NSString *nombre = [wallpaper valueForKey:@"nombre"];
//        UIImage *thumbnailImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[wallpaper valueForKey:@"thumbnailURL"]]]];
//        NSString *imagenURL = [wallpaper valueForKey:@"imagenURL"];
//        
//        [resp addObject:[[Wallpaper alloc] initWithNombre:nombre thumbnailImage:thumbnailImage andImageURL:imagenURL]];
//        
//        
//    }
//
//    return resp;
//}

//-(NSArray *) fetchRingtones{
//    
//    NSMutableArray *resp = [[NSMutableArray alloc]init];
//    
//    NSArray *ringtones = [[self executeRequest:@"http://minicolombia.herokuapp.com/descargas/darRingtones/"] valueForKey:@"ringtones"];
//    
//    for (NSDictionary *ringtone in ringtones){
//        
//        NSString *nombre = [ringtone valueForKey:@"nombre"];
//        NSString *archivo = [ringtone valueForKey:@"archivoURL"];
//        
//        [resp addObject:[[Ringtone alloc] initWithNombre:nombre andArchivoURL:archivo]];
//
//    }
//    return resp;
//}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    // we'll segue to ANY view controller that has a modelo @property
////    if ([segue.destinationViewController respondsToSelector:@selector(setRingtones:)]) {
////        [segue.destinationViewController performSelector:@selector(setRingtones:) withObject:[self fetchRingtones]];
////    }
//    
//
//}

@end
