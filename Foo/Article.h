//
//  Article.h
//  Foo
//
//  Created by Muhammad Taufik on 11/24/11.
//  Copyright (c) 2011 Beetlebox. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Author;

@interface Article : NSObject

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* body;
@property (nonatomic, retain) Author* author;
@property (nonatomic, retain) NSDate*   publicationDate;

@end
