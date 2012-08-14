//
//  NoticiasEngine.m
//  Mini Colombia
//
//  Created by Juan José Villegas on 27/07/12.
//
//

#import "NoticiasEngine.h"
#import "Noticia.h"

@implementation NoticiasEngine

-(MKNetworkOperation *) noticiaWithURL:(NSString *)path
                          onCompletion:(HTMLResponseBlock)completionBlock
                               onError:(MKNKErrorBlock)errorBlock {
    
    MKNetworkOperation * op = [self operationWithURLString:path params:nil httpMethod:@"GET"];
    
    [op onCompletion:^(MKNetworkOperation * completedOperation){
        NSString *valueString = [completedOperation responseString];
//        DLog(@"%@", valueString);
        
        if([completedOperation isCachedResponse]) {
            NSLog(@"Data from cache %@", [completedOperation responseString]);
        }
        else {
            DLog(@"Data from server %@", [completedOperation responseString]);
        }
        
        completionBlock(valueString);
        
    }onError:^(NSError * error){
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
    
    return op;
}

-(MKNetworkOperation *) darNoticiasPorCategoria:(NSString *)categoria
                         inManagedObjectContext:(NSManagedObjectContext *)context
                                   onCompletion:(ArrayResponseBlock)completionBlock
                                        onError:(MKNKErrorBlock)errorBlock{
    int categoriaId;
    
    if ([categoria isEqualToString:@"Noticia Internacional."]) {
        categoriaId = 1;
    }
    else if ([categoria isEqualToString:@"Noticia Nacional."]){
        categoriaId = 2;
    }
    else if ([categoria isEqualToString:@"Promocion."]){
        categoriaId = 3;
    }
    else if ([categoria isEqualToString:@"Novedad."]){
        categoriaId = 4;
    }
    
    MKNetworkOperation * op = [self operationWithPath:[NSString stringWithFormat:@"noticias/darNoticiasPorCategoria/%i/", categoriaId] params:nil httpMethod:@"GET"];
    
    [op onCompletion:^(MKNetworkOperation * completedOperation){
        NSDictionary * resp = [completedOperation responseJSON];
        
        NSArray * noticias = [resp valueForKey:@"noticias"];
        
        NSLog(@"noticias info es lo sigueiten : %@", resp);
        
        NSMutableArray * noticiasArray = [NSMutableArray array];
        
        for (NSDictionary  * noticiaInfo in noticias) {
            NSEntityDescription * entity = [NSEntityDescription entityForName:@"Noticia" inManagedObjectContext:context];
            
            Noticia *noticia = [[Noticia alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
            
            noticia.titulo = [noticiaInfo valueForKey:@"titulo"];
            noticia.resumen = [noticiaInfo valueForKey:@"resumen"];
            noticia.fecha = [noticiaInfo valueForKey:@"fecha_creacion"];
            noticia.pagina = [noticiaInfo objectForKey:@"pagina"];
            noticia.categoria = [noticiaInfo valueForKey:@"categoria"];
            noticia.paginaURL = [noticiaInfo valueForKey:@"paginaURL"];
            noticia.thumbnailURL = [noticiaInfo valueForKey:@"thumbnailURL"];
            
            [noticiasArray addObject:noticia];
        }
        
        completionBlock(noticiasArray);
        
    }onError:^(NSError * error){
        NSLog(@"hubo un error en el request de dar las noticias");
        
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
    
    return op;

    
    
}



-(MKNetworkOperation *) downloadFromURL:(NSString *)url{
    
    MKNetworkOperation *op = [self operationWithURLString:url];
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    [op addDownloadStream:[NSOutputStream outputStreamToFileAtPath:docDir append:YES]];
    
    return op;
}
     
-(NSString *) cacheDirectoryName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"NoticiasCache"];
    return cacheDirectoryName;
}

@end
