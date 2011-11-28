//
//  Tweet.h
//  Foo
//
//  Created by Muhammad Taufik on 11/28/11.
//  Copyright (c) 2011 Beetlebox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Tweet : NSManagedObject

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * id_str;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) User *user;

@end
