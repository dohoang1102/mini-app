//
//  Vitrina.h
//  Mini Colombia
//
//  Created by Juan José Villegas on 7/08/12.
//
//

#import <Foundation/Foundation.h>

@interface Vitrina : NSObject

@property (nonatomic) NSString * nombre;

@property (nonatomic) NSString * nombreCorto;

@property (nonatomic) NSString * infoVitrina;

@property (nonatomic) NSString * infoEmpleado;

@property (nonatomic) NSString * imgEmpleado;

@property (nonatomic) NSString * imgVitrina;

//-(id) initVitrinaWithNombre:(NSString * )nombre nombreCorto: (NSString *) nomCorto withVitrinaInfo:(NSString *) vitrinaInfo nombreImagenVitrina:(NSString *) imagenVitrina nombreImagenEmpleado:(NSString *) imagenEmpleado

-(id) initVitrinaWithInfo:(NSDictionary *) vitrinaInfo;

+(NSArray *) vitrinas;



@end
