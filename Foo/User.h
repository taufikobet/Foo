//
//  User.h
//  Foo
//
//  Created by Muhammad Taufik on 11/28/11.
//  Copyright (c) 2011 Beetlebox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tweet;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * id_str;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * screen_name;
@property (nonatomic, retain) NSSet *tweets;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addTweetsObject:(Tweet *)value;
- (void)removeTweetsObject:(Tweet *)value;
- (void)addTweets:(NSSet *)values;
- (void)removeTweets:(NSSet *)values;

@end
