//
//  Modelo+FamiliaMini.m
//  miniNL
//
//  Created by German Villegas on 26/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Modelo+FamiliaMini.h"
#import "Edicion+FamiliaMini.h"

@implementation Modelo (FamiliaMini)


+(void)setTimestamp:(NSString *) timestamp{
    
    NSString *path = [self getResolvedDataPath];
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    [data setObject:timestamp forKey:TIMESTAMP_KEY];
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
    NSString *timestamp = [data objectForKey:TIMESTAMP_KEY];
    
    return timestamp;
}

+(void)updateModelo:(NSString *)nombre forModeloInfo:(NSDictionary *)modeloInfo inManagedObjectContext:(NSManagedObjectContext *)context{
    
    Modelo *modelo = [self buscarModeloPorNombre:nombre inManagedObjectContext:context];
    
    modelo.nombre = [modeloInfo objectForKey:NOMBRE];
    modelo.descripcion = [modeloInfo objectForKey:DESCRIPCION];
    modelo.imagenURL = [self saveImageWithUrl:[modeloInfo objectForKey:IMAGEN] andFileName:[NSString stringWithFormat:@"modelo-imagen-%@", [modeloInfo objectForKey:NOMBRE]]];
    modelo.thumbnailURL = [self saveImageWithUrl:[modeloInfo valueForKey:@"thumbnail"] andFileName:[NSString stringWithFormat:@"modelo-thumbnail-%@", [modeloInfo valueForKey:NOMBRE]]];
    
    NSError *err;
    
    if (![context save:&err]) {
        NSLog(@"%@", err); // an erro occurred in saving, perhaps due to optimistic locking failure
    }

}


+(void)saveModeloWithInfo:(NSDictionary *)modeloInfo inManagedObjectContext:(NSManagedObjectContext *)context{
    
    
    Modelo *modelo = nil;

    
    modelo = [NSEntityDescription insertNewObjectForEntityForName:@"Modelo" inManagedObjectContext:context];
    modelo.nombre = [modeloInfo objectForKey:NOMBRE];
    modelo.descripcion = [modeloInfo objectForKey:DESCRIPCION];
    modelo.imagenURL = [self saveImageWithUrl:[modeloInfo objectForKey:IMAGEN] andFileName:[NSString stringWithFormat:@"modelo-%@", [modeloInfo objectForKey:NOMBRE]]];
    modelo.thumbnailURL = [self saveImageWithUrl:[modeloInfo valueForKey:@"thumbnail"] andFileName:[NSString stringWithFormat:@"modelo-thumbnail-%@", [modeloInfo valueForKey:NOMBRE]]];

    NSLog(@"Agrega modelo con nombre %@", modelo.nombre);
}

+(void)saveModelo:(NSDictionary *)modeloInfo 
    withEdiciones:(NSArray *)edicionesInfo 
        inContext:(NSManagedObjectContext *)context{
    
    Modelo *modelo = nil;

    modelo = [NSEntityDescription insertNewObjectForEntityForName:@"Modelo" inManagedObjectContext:context];
    
    modelo.nombre = [modeloInfo objectForKey:NOMBRE];
    modelo.descripcion = [modeloInfo objectForKey:DESCRIPCION];
    modelo.imagenURL = [self saveImageWithUrl:[modeloInfo objectForKey:IMAGEN] andFileName:[NSString stringWithFormat:@"modelo-%@", [modeloInfo objectForKey:NOMBRE]]];
    modelo.thumbnailURL = [self saveImageWithUrl:[modeloInfo valueForKey:@"thumbnail"] andFileName:[NSString stringWithFormat:@"modelo-thumbnail-%@", [modeloInfo valueForKey:NOMBRE]]];
    
    for (NSDictionary *edicionInfo in edicionesInfo) {
        [Edicion edicionForModelo:modelo andInfo:edicionInfo inManagedObjectContext:context];
    }
    
    NSLog(@"Agrega modelo con nombre %@", modelo.nombre);

    
    
}

+(void)deleteModelo:(NSString *)nombre inManagedObjectContext: (NSManagedObjectContext *)context{

    NSError *error = nil;

    Modelo *modelo = [self buscarModeloPorNombre:nombre inManagedObjectContext:context];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    // Attempt to delete the file at filePath2
    if ( modelo == nil || [fm removeItemAtPath:modelo.imagenURL error:&error] != YES || [fm removeItemAtPath:modelo.thumbnailURL error:&error] != YES)
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
    else {
        [context deleteObject:modelo];
    }
        
}

+(Modelo *) buscarModeloPorNombre:(NSString *) nombre inManagedObjectContext:(NSManagedObjectContext *) context{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Modelo"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"nombre" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        
    request.predicate = [NSPredicate predicateWithFormat:@"nombre=%@",nombre];
    
    NSError *error = nil;
    NSArray *modelos = [context executeFetchRequest:request error:&error];
    
    if([modelos count] != 1 ){
        
        NSLog(@"No se encontro el modelo. Modelos count= %d", [modelos count]);
        return nil;
        
    }
    else {
        return [modelos objectAtIndex:0];
    }

}

+(NSString *) saveImageWithUrl:(NSString*)url andFileName:(NSString *) fileName{
    
    NSError *error;
    
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    UIImage *image = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *imgDir = [ docDir stringByAppendingPathComponent:@"/familiaMini/img/" ];
    
    if( ![fm fileExistsAtPath:imgDir] ){
        [fm createDirectoryAtPath:imgDir withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.jpeg", imgDir, fileName];
    
    NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)];
    [data writeToFile:filePath atomically:YES];
    
    return filePath;
}

@end
