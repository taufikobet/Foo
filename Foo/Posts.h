//
//  Posts.h
//  Foo
//
//  Created by Muhammad Taufik on 11/23/11.
//  Copyright (c) 2011 Beetlebox. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <RestKit/RestKit.h>

@interface Posts : NSManagedObject


@property (nonatomic, retain) NSString *postID;
@property (nonatomic, retain) NSDate *postDate;
@property (nonatomic, retain) NSString *postDescription;
@property (nonatomic, retain) NSString *postDetail;
@property (nonatomic, retain) NSString *postTitle;



@end
