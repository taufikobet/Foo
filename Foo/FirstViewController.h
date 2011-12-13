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
#import "IconDownloader.h"

@class VariableHeightCell;

@interface FirstViewController : PullRefreshTableViewController <RKObjectLoaderDelegate, NSFetchedResultsControllerDelegate, UIScrollViewDelegate, IconDownloaderDelegate>
{

}

@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void)loadNewTweets;
- (void)populateTableViewCellWithTweets;

- (void)configureCell:(VariableHeightCell *)cell atIndexPath:(NSIndexPath *)indexPath;

- (void)startIconDownload:(Tweet *)tweet forIndexPath:(NSIndexPath *)indexPath;

- (void)loadImagesForOnscreenRows;

@end
