//
//  ComunidadEngine.h
//  Mini Colombia
//
//  Created by Juan José Villegas on 6/08/12.
//
//

#import "MKNetworkEngine.h"

@interface ComunidadEngine : MKNetworkEngine

typedef void (^ImageComunidadResponseBlock)(UIImage * imagen);

typedef void (^ArrayComunidadResponseBlock)(NSArray * array);

-(MKNetworkOperation *) descargarImagenConURL:(NSString *) url
                                 onCompletion:(ImageComunidadResponseBlock) completionBlock
                                      onError:(MKNKErrorBlock) errorBlock;

-(MKNetworkOperation *) descargarImagenesGaleria:(ArrayComunidadResponseBlock) completionBlock
                                         onError:(MKNKErrorBlock) errorBlock;

-(MKNetworkOperation *) descargarNuevosEventos:(ArrayComunidadResponseBlock) completionBlock onError:(MKNKErrorBlock) errorBlock;

@end
