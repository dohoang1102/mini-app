//
//  Modelo+FamiliaMini.h
//  miniNL
//
//  Created by German Villegas on 26/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Modelo.h"

#define MODELO @"modelo"
#define MODELOS @"modelos"
#define TIMESTAMP @"timestamp"
#define TIMESTAMP_KEY @"FamiliaTimestamp"
#define HAY_ACTUALIZACIONES @"hayActualizaciones"
#define NOMBRE @"nombre"
#define DESCRIPCION @"descripcion"
#define IMAGEN @"imagen"

@interface Modelo (FamiliaMini)

+(void)setTimestamp:(NSString *) timestamp;

//+(void)saveModelos:(NSArray *)modelos inManagedObjectContext:(NSManagedObjectContext *)context;

+(void)saveModeloWithInfo:(NSDictionary *) modeloInfo
inManagedObjectContext:(NSManagedObjectContext *) context;

+(void)saveModelo:(NSDictionary *) modeloInfo 
    withEdiciones:(NSArray*)edicionesInfo 
        inContext:(NSManagedObjectContext *) context;

+(NSString *) getTimestamp;

+(void)deleteModelo:(NSString *) nombre 
inManagedObjectContext:(NSManagedObjectContext *) context;

+(void)updateModelo:(NSString *) nombre 
      forModeloInfo:(NSDictionary *) modeloInfo
inManagedObjectContext:(NSManagedObjectContext *) context;

+(Modelo *) buscarModeloPorNombre:(NSString *) nombre inManagedObjectContext:(NSManagedObjectContext *) context;

@end
