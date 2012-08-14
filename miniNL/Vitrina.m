//
//  Vitrina.m
//  Mini Colombia
//
//  Created by Juan José Villegas on 7/08/12.
//
//

#import "Vitrina.h"

@implementation Vitrina

@synthesize nombre = _nombre;
@synthesize nombreCorto = _nombreCorto;
@synthesize infoVitrina = _infoVitrina;
@synthesize infoEmpleado = _infoEmpleado;
@synthesize imgEmpleado = _imgEmpleado;
@synthesize imgVitrina = _imgVitrina;


-(id) initVitrinaWithInfo:(NSDictionary *)vitrinaInfo{

    self = [self init];
    
    self.nombre = [vitrinaInfo valueForKey:@"nombre"];
    self.nombreCorto = [vitrinaInfo valueForKey:@"nombreCorto"];
    self.infoVitrina = [vitrinaInfo valueForKey:@"vitrinaInfo"];
    self.imgVitrina = [vitrinaInfo valueForKey:@"nombreImagenVitrina"];
    self.imgEmpleado = [vitrinaInfo valueForKey:@"nombreImagenEmpleado"];
    self.infoEmpleado = [vitrinaInfo valueForKey:@"empleadoInfo"];
    
    return self;
}


+(NSArray *) vitrinas{
    
    NSMutableArray * vitrinas = [[NSMutableArray alloc]init];
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
    
    NSArray * vitrinasArray = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"Vitrinas"];
    
//    NSArray * vitrinasArray = [NSArray arrayWithContentsOfFile:path];
    
    for (NSDictionary * vitrinaInfo in vitrinasArray) {
        
        [vitrinas addObject:[[Vitrina alloc] initVitrinaWithInfo:vitrinaInfo]];
    }
    
    return vitrinas;
}

@end
