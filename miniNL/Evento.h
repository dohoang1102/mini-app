//
//  Evento.h
//  Mini Colombia
//
//  Created by Juan José Villegas on 10/08/12.
//
//

#import <Foundation/Foundation.h>

@interface Evento : NSObject

@property (nonatomic) NSString * titulo;

@property (nonatomic) NSString * subtitulo;

@property (nonatomic) NSString * thumbnailURL;

@property (nonatomic) NSString * contenido;

@property (nonatomic) NSString * eTemplate;

@property (nonatomic) NSString * fecha;

@property (nonatomic) NSArray * imagenesURL;

@property (nonatomic) NSString * posicion;

-(id) initEventoWithInfo:(NSDictionary *) eventoInfo;

@end
