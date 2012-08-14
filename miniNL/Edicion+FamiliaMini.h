//
//  Edicion+FamiliaMini.h
//  miniNL
//
//  Created by German Villegas on 1/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Edicion.h"

@interface Edicion (FamiliaMini)

+(void)edicionForModelo:(Modelo * )modelo 
                andInfo: (NSDictionary *) edicionInfo 
 inManagedObjectContext:(NSManagedObjectContext *) context;

+(void) deleteEdicion:(NSString *)nombre inManagedObjectContext:( NSManagedObjectContext *)context;

+(void) updateEdicion:(NSString *)nombreEdicion 
           forNewInfo: (NSDictionary *) edicionInfo
inManagedObjectContext:(NSManagedObjectContext *) context;

@end
