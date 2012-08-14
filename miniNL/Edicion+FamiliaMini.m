//
//  Edicion+FamiliaMini.m
//  miniNL
//
//  Created by German Villegas on 1/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Edicion+FamiliaMini.h"

@implementation Edicion (FamiliaMini)

+(void) edicionForModelo:(Modelo *)modelo 
                 andInfo:(NSDictionary *)edicionInfo 
  inManagedObjectContext:(NSManagedObjectContext *)context {
    
    Edicion *edicion = nil;
    
    edicion = [NSEntityDescription insertNewObjectForEntityForName:@"Edicion" inManagedObjectContext:context];
    
    edicion.nombre = [edicionInfo objectForKey:@"nombre"];
    edicion.descripcion = [edicionInfo objectForKey:@"descripcion"];
    edicion.modelo = modelo;
    edicion.thumbnailURL = [self saveImageWithUrl:[edicionInfo objectForKey:@"thumbnail"] andFileName:[NSString stringWithFormat:@"edicion-thumbnail-%@",edicion.nombre]];
    edicion.imagenURL = [self saveImageWithUrl:[edicionInfo objectForKey:@"imagen"] andFileName:[NSString stringWithFormat:@"edicion-imagen-%@",edicion.nombre]];
    edicion.templateColor = [edicionInfo valueForKey:@"template_color"];
    
    BOOL testDrive = [[edicionInfo objectForKey:@"test_drive"] boolValue];
    edicion.testDrive = [NSNumber numberWithBool:testDrive];
    
    NSLog(@"Agrega edicion con nombre %@", edicion.nombre);
 
}

+(void) updateEdicion:(NSString *)nombreEdicion forNewInfo:(NSDictionary *)edicionInfo inManagedObjectContext:(NSManagedObjectContext *)context{
    
    Edicion *edicion = [self darEdicionPorNombre:nombreEdicion inManagedObjectContext:context];
    
    edicion.nombre = [edicionInfo objectForKey:@"nombre"];
    edicion.descripcion = [edicionInfo objectForKey:@"descripcion"];
    edicion.thumbnailURL = [self saveImageWithUrl:[edicionInfo objectForKey:@"thumbnail"] andFileName:[NSString stringWithFormat:@"edicion-thumbnail-%@",edicion.nombre]];
    edicion.imagenURL = [self saveImageWithUrl:[edicionInfo objectForKey:@"imagen"] andFileName:[NSString stringWithFormat:@"edicion-imagen-%@",edicion.nombre]];
    edicion.templateColor = [edicionInfo valueForKey:@"template_color"];
    
    BOOL testDrive = [[edicionInfo objectForKey:@"test_drive"] boolValue];
    edicion.testDrive = [NSNumber numberWithBool:testDrive];
    
    NSError *err;
    
    if (![context save:&err] ) {
        NSLog(@"%@", err);
    }
}

+(void)deleteEdicion:(NSString *)nombre inManagedObjectContext:(NSManagedObjectContext *)context{

    NSError *err;
    Edicion *edicion = [self darEdicionPorNombre:nombre inManagedObjectContext:context];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if ([fm removeItemAtPath:edicion.imagenURL error:&err] != YES || [fm removeItemAtPath:edicion.thumbnailURL error:&err] != YES) {
        NSLog(@"Unable to delete file: %@", [err localizedDescription]);
    }
    else {
        [context deleteObject:edicion];
        
    }

}

+(Edicion *) darEdicionPorNombre:(NSString *) nombre inManagedObjectContext:(NSManagedObjectContext*) context{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Edicion"];
    request.predicate = [NSPredicate predicateWithFormat:@"nombre=%@",nombre];
    NSSortDescriptor *sortDescripctor = [NSSortDescriptor sortDescriptorWithKey:@"nombre" ascending:YES];
    
    request.sortDescriptors = [NSArray arrayWithObject:sortDescripctor];
    
    NSError *err;
    NSArray *ediciones = [context executeFetchRequest:request error:&err];
    
    if([ediciones count] != 1 ){
        NSLog(@"Hubo un error borrando la edicion. Ediciones count= %d", [ediciones count]);
        return nil;
    }
    else {
        Edicion *edicion = [ediciones objectAtIndex:0];
        return edicion;
        
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
