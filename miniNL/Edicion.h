//
//  Edicion.h
//  Mini Colombia
//
//  Created by German Villegas on 12/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Modelo;

@interface Edicion : NSManagedObject

@property (nonatomic, retain) NSString * descripcion;
@property (nonatomic, retain) NSString * imagenURL;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSNumber * testDrive;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) NSString * templateColor;
@property (nonatomic, retain) Modelo *modelo;

@end
