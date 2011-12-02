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
#import "PullRefreshTableViewController.h"

@class VariableHeightCell;

@interface FirstViewController : PullRefreshTableViewController <RKObjectLoaderDelegate, NSFetchedResultsControllerDelegate>
{

}

@property (nonatomic, strong) NSArray *tweets;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void)loadNewTweets;
- (void)populateTableViewCellWithTweets;

- (void)configureCell:(VariableHeightCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
