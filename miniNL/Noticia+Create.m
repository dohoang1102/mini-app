//
//  Noticia+Create.m
//  Mini Colombia
//
//  Created by German Villegas on 16/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Noticia+Create.h"

@implementation Noticia (Create)


+(Noticia *)noticiaWithInfo:(NSDictionary *)noticiaInfo
     inManagedObjectContext:(NSManagedObjectContext *)context 
                saveContext:(BOOL) save {
    
    Noticia *noticia = [NSEntityDescription insertNewObjectForEntityForName:@"Noticia" inManagedObjectContext:context];
    
    noticia.titulo = [noticiaInfo valueForKey:@"titulo"];
    noticia.resumen = [noticiaInfo valueForKey:@"resumen"];
    noticia.fecha = [noticiaInfo valueForKey:@"fecha_creacion"];
    noticia.pagina = [noticiaInfo objectForKey:@"pagina"];
    noticia.categoria = [noticiaInfo valueForKey:@"categoria"];
    noticia.paginaURL = [noticiaInfo valueForKey:@"paginaURL"];
    
    
    if (save) {
        noticia.thumbnailURL = [self saveImageWithUrl:[noticiaInfo valueForKey:@"thumbnailURL"] andFileName:noticia.titulo];
        
        NSError *err;
        
        if (![context save:&err]) {
            NSLog(@"%@", err); // an erro occurred in saving, perhaps due to optimistic locking failure
        }
    }
    else {
        noticia.thumbnailURL = [noticia valueForKey:@"thumbnailURL"];
    }
    
    return noticia;
}

#pragma mark - timestamp Instance Methods

+(void)setTimestamp:(NSString *) timestamp{
    
    NSString *path = [self getResolvedDataPath];
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    [data setObject:timestamp forKey:@"NoticiasTimestamp"];
    [data writeToFile:path atomically:YES];
}

+(NSString *) getResolvedDataPath{
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDir = [paths objectAtIndex:0];
    
    NSString *path = [documentsDir stringByAppendingPathComponent:@"data.plist"];
    
    NSFileManager *fileManager= [NSFileManager defaultManager];
    
    if( ! [fileManager fileExistsAtPath:path]){
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
        
        [fileManager copyItemAtPath:bundle toPath:path error:&error];
    }
    
    return path;
    
}

+(NSString*) getTimestamp{
    NSString *path = [self getResolvedDataPath];
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSString *timestamp = [data objectForKey:@"NoticiasTimestamp"];
    
    return timestamp;
}

+(Noticia *)updateNoticiaWithInfo:(NSDictionary *)noticiaInfo inManagedObjectContext:(NSManagedObjectContext *)context{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Noticia"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"categoria" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    request.predicate = [NSPredicate predicateWithFormat:@"categoria=%@",[noticiaInfo valueForKey:@"categoria"] ];
    
    NSError *error = nil;
    NSArray *noticias = [context executeFetchRequest:request error:&error];
    
    if([noticias count] != 1 ){
        
        NSLog(@"No se encontro la noticia. Noticias count= %d", [noticias count]);
        return nil;
        
    }
    else {
        Noticia *noticia = [noticias objectAtIndex:0];
        
        noticia.titulo = [noticiaInfo valueForKey:@"titulo"];
        noticia.resumen = [noticiaInfo valueForKey:@"resumen"];
        noticia.fecha = [noticiaInfo valueForKey:@"fecha_creacion"];
        noticia.pagina = [noticiaInfo valueForKey:@"pagina"];
        noticia.categoria = [noticiaInfo valueForKey:@"categoria"];
        noticia.paginaURL = [noticiaInfo valueForKey:@"paginaURL"];
        
        
        noticia.thumbnailURL = [self saveImageWithUrl:[noticiaInfo valueForKey:@"thumbnailURL"] andFileName:noticia.titulo];
        
        NSError *err;
        
        if (![context save:&err]) {
            NSLog(@"%@", err); // an erro occurred in saving, perhaps due to optimistic locking failure
        }

        
        return noticia;
    }
    
}

-(UIImage *) thumbnailImage{
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.thumbnailURL]];
    return [UIImage imageWithData:imageData];
}

+(NSString *) saveImageWithUrl:(NSString*)url andFileName:(NSString *) fileName{
    
    NSError *error;
    
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    UIImage *image = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *imgDir = [ docDir stringByAppendingPathComponent:@"/noticias/img/" ];
    
    if( ![fm fileExistsAtPath:imgDir] ){
        [fm createDirectoryAtPath:imgDir withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.jpeg", imgDir, fileName];
    
    NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)];
    [data writeToFile:filePath atomically:YES];
    
    return filePath;
}


@end
