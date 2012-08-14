//
//  Modelo.h
//  Mini Colombia
//
//  Created by German Villegas on 12/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Edicion;

@interface Modelo : NSManagedObject

@property (nonatomic, retain) NSString * descripcion;
@property (nonatomic, retain) NSString * imagenURL;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) NSSet *ediciones;
@end

@interface Modelo (CoreDataGeneratedAccessors)

- (void)addEdicionesObject:(Edicion *)value;
- (void)removeEdicionesObject:(Edicion *)value;
- (void)addEdiciones:(NSSet *)values;
- (void)removeEdiciones:(NSSet *)values;

@end
