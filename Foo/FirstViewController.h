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

#import "TimeScroller.h"

@class VariableHeightCell;

@interface FirstViewController : UITableViewController <RKObjectLoaderDelegate, NSFetchedResultsControllerDelegate, UIScrollViewDelegate, IconDownloaderDelegate, TimeScrollerDelegate>
{
    TimeScroller *_timeScroller;
}

@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void)loadNewTweets;

- (void)populateTableViewCellWithTweets;

- (void)startIconDownload:(Tweet *)tweet forIndexPath:(NSIndexPath *)indexPath;

- (void)loadImagesForOnscreenRows;

- (void)refreshing;

@end
