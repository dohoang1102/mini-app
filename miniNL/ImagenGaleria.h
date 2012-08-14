//
//  ImagenGaleria.h
//  Mini Colombia
//
//  Created by Juan José Villegas on 6/08/12.
//
//

#import <Foundation/Foundation.h>

@interface ImagenGaleria : NSObject

@property (nonatomic) NSString *nombre;

@property (nonatomic) UIImage *thumbnail;

@property (nonatomic) NSString *imagenURL;

@property (nonatomic) NSString * thumbnailURL;


-(void) descargarImagen;

-(id) initWithNombre:(NSString *) nombre thumbnailImage:(UIImage *) thumbnail andImageURL:(NSString *) imagenURL;

-(id) initWithNombre:(NSString *) nombre thumbnailImageURL:(NSString *) thumbnailURL andImageURL:(NSString *) imagenURL;

@end
