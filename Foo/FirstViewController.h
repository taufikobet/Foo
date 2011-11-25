//
//  FirstViewController.h
//  Foo
//
//  Created by Muhammad Taufik on 11/22/11.
//  Copyright (c) 2011 Beetlebox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

@interface FirstViewController : UITableViewController <RKObjectLoaderDelegate>
{

}

@property (nonatomic, strong) NSArray *posts;

-(void)populatePosts;

@end
