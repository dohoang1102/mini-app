//
//  Evento.m
//  Mini Colombia
//
//  Created by Juan José Villegas on 10/08/12.
//
//

#import "Evento.h"

@implementation Evento

@synthesize titulo = _titulo;

@synthesize subtitulo = _subtitulo;

@synthesize thumbnailURL = _thumbnailURL;

@synthesize contenido = _contenido;
@synthesize eTemplate = _eTemplate;
@synthesize fecha = _fecha;
@synthesize imagenesURL = _imagenesURL;
@synthesize posicion = _posicion;


-(id) initEventoWithInfo:(NSDictionary *)eventoInfo{
    
    self = [self init];
    
    _titulo = [eventoInfo valueForKey:@"titulo"];
    _subtitulo = [eventoInfo valueForKey:@"subtitulo"];
    _thumbnailURL = [eventoInfo valueForKey:@"thumbnailURL"];
    _contenido = [eventoInfo valueForKey:@"contenido"];
    _eTemplate = [eventoInfo valueForKey:@"template"];
    _fecha = [eventoInfo valueForKey:@"fecha"];
    
    _imagenesURL = [eventoInfo objectForKey:@"imagenes"];
    
    _posicion = [eventoInfo valueForKey:@"posicion"];
    
    return self;
}

@end
