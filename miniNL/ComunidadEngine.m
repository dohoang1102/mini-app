//
//  ComunidadEngine.m
//  Mini Colombia
//
//  Created by Juan José Villegas on 6/08/12.
//
//

#import "ComunidadEngine.h"
#import "ImagenGaleria.h"
#import "Evento.h"

@implementation ComunidadEngine

-(MKNetworkOperation *) descargarImagenConURL:(NSString *)url
                                 onCompletion:(ImageComunidadResponseBlock)completionBlock
                                      onError:(MKNKErrorBlock)errorBlock{
    
    MKNetworkOperation *op = [self operationWithURLString:url params:nil httpMethod:@"GET"];
    
    [op onCompletion:^(MKNetworkOperation * completedOperation){
        
        UIImage * image = [completedOperation responseImage];
        
        completionBlock(image);
        
    }onError:^(NSError *error){
        errorBlock(error);
        
        NSLog(@"Hizo emptyCache en comunidadEngine");
        
        [self emptyCache];
    }];
    
    [self enqueueOperation:op];
    
    return op;
}

-(MKNetworkOperation *) descargarImagenesGaleria:(ArrayComunidadResponseBlock)completionBlock
                                         onError:(MKNKErrorBlock)errorBlock{
    
    MKNetworkOperation *op = [self operationWithPath:@"comunidad/darUltimasImagenes/" params:nil httpMethod:@"GET"];
    
    
    [op onCompletion:^(MKNetworkOperation * completedOperation){
        
        
        NSMutableArray *resp = [[NSMutableArray alloc] init];
        
        NSArray *imagenesArray = [[completedOperation responseJSON] valueForKey:@"imagenes"];
        
        for (NSDictionary *imagen in imagenesArray){
            

            NSString *nombre = [imagen valueForKey:@"nombre"];
            NSString *imagenURL = [imagen valueForKey:@"imagenURL"];
            

            
            NSString * thumbnailURL = [imagen valueForKey:@"thumbnailURL"];

            
            [resp addObject:[[ImagenGaleria alloc] initWithNombre:nombre thumbnailImageURL:thumbnailURL andImageURL:imagenURL]];
            
        }
        
        completionBlock(resp);
   
    }onError:^(NSError *error){
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
    
    return op;
}

-(MKNetworkOperation *) descargarNuevosEventos:(ArrayComunidadResponseBlock)completionBlock onError:(MKNKErrorBlock)errorBlock{
    
    MKNetworkOperation * op = [self operationWithPath:@"comunidad/darNuevosEventos"];
    
    [op onCompletion:^(MKNetworkOperation * completedOperation){
        
        NSMutableArray * eventos = [[NSMutableArray alloc]init];
        
        NSArray * eventosInfoArray = [[completedOperation responseJSON] valueForKey:@"eventos"];
        
        for (NSDictionary * eventoInfo in eventosInfoArray) {
            
            [eventos addObject:[[Evento alloc] initEventoWithInfo:eventoInfo]];
        }
        
        completionBlock(eventos);
    }onError:^(NSError * error){
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
    
    return op;
    
}

@end
