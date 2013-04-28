//
//  Event.h
//  Blastt
//
//  Created by Raj Kandathi on 12/11/12.
//  Copyright (c) 2012 Raj K. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *startDateAndTime;
@property(nonatomic, copy) NSString *endDateAndTime;
@property(nonatomic, copy) NSString *place;
@property(nonatomic, assign) BOOL publicStatus;
@property(nonatomic, strong) NSData *imageData;

@end
