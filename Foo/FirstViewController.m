//
//  FirstViewController.m
//  Foo
//
//  Created by Muhammad Taufik on 11/22/11.
//  Copyright (c) 2011 Beetlebox. All rights reserved.
//

#import "FirstViewController.h"

#import <RestKit/RestKit.h>

#import "MKInfoPanel.h"

#import "User.h"
#import "Tweet.h"

#import "VariableHeightCell.h"

#import "IconDownloader.h"

@implementation FirstViewController

@synthesize tweets;

@synthesize imageDownloadsInProgress;

@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    
    if (self) {

    }
    
    return self;
}


- (void)populateTableViewCellWithTweets {
    
    NSArray* sortedObjects = [Tweet allObjects];
    
    NSSortDescriptor *dateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:NO];
    NSArray *newSortDescriptor = [NSArray arrayWithObject:dateSortDescriptor];
    
    self.tweets = [sortedObjects sortedArrayUsingDescriptors:newSortDescriptor];
    
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Tweets", @"Tweets");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        //self.tableView.showsVerticalScrollIndicator = NO;
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.separatorColor = [UIColor lightGrayColor];
    
    RKManagedObjectMapping* userMapping = [RKManagedObjectMapping mappingForClass:[User class] ];
    [userMapping mapKeyPath:@"id_str" toAttribute:@"id_str"];
    [userMapping mapKeyPath:@"name" toAttribute:@"name"];
    [userMapping mapKeyPath:@"screen_name" toAttribute:@"screen_name"];
    [userMapping mapKeyPath:@"profile_image_url" toAttribute:@"profile_image_url"];
    [userMapping setPrimaryKeyAttribute:@"id_str"];
    
    RKManagedObjectMapping* tweetMapping = [RKManagedObjectMapping mappingForClass:[Tweet class] ];
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    tweetMapping.dateFormatters = [NSArray arrayWithObject: dateFormatter];
    [tweetMapping mapKeyPath:@"created_at" toAttribute:@"created_at"];
    [tweetMapping mapKeyPath:@"id_str" toAttribute:@"id_str"];
    [tweetMapping mapKeyPath:@"text" toAttribute:@"text"];
    [tweetMapping setPrimaryKeyAttribute:@"id_str"];
    [tweetMapping mapKeyPath:@"user" toRelationship:@"user" withMapping:userMapping];
    
    [[RKObjectManager sharedManager].mappingProvider addObjectMapping:tweetMapping];
    
    [self loadNewTweets];
    
    /*
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
     */
}

- (void)loadNewTweets {
    
    RKObjectMapping* tweetMapping = [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[Tweet class] ];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/1/statuses/public_timeline.json" objectMapping:tweetMapping delegate:self];

}

// ... and grab the data via its delegate...
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    
    [self populateTableViewCellWithTweets];
    
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
    
    [self.tableView reloadData];
    
    //[MKInfoPanel showPanelInWindow:[UIApplication sharedApplication].delegate.window  type:MKInfoPanelTypeInfo title:@"Loaded." subtitle:@"Latest news loaded from internetz." hideAfter:2.0];
    
    /*
     for (id obj in objects) {
        NSLog(@"===============================================================");
        NSLog(@"%@", [obj valueForKeyPath:@"user.screen_name"]);
        NSLog(@"%@", [obj valueForKey:@"text"]);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        NSString *myDateString = [dateFormatter stringFromDate:[obj valueForKey:@"created_at"]];
        NSLog(@"%@", myDateString);
        NSLog(@"%@", [obj valueForKeyPath:@"user.profile_image_url"]);
        NSLog(@"===============================================================");
     } */
    
    /*
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);
	}
     */
    
    // or...
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {


    [MKInfoPanel showPanelInWindow:[UIApplication sharedApplication].delegate.window  type:MKInfoPanelTypeError title:@"INTERNET" subtitle:@"Y U NO AVAILABLE" hideAfter:2.0];

    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];

}

// Pull to refresh
- (void)refreshing {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    [self loadNewTweets];
    
    //NSLog(@"Refresh success.");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSDictionary* obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    //return [VariableHeightCell heightForCellWithInfo:obj inTable:tableView];
    
    NSDictionary* obj = [self.tweets objectAtIndex:indexPath.row];
    
    return [VariableHeightCell heightForCellWithInfo:obj inTable:tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
	//return [sectionInfo numberOfObjects];
    
    int count = [self.tweets count];
    
    if (count == 0)
    {
        return 1;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *PlaceHolderCell = @"PlaceholderCell";
    
    int nodeCount = [self.tweets count];
    
    NSLog(@"%d", nodeCount);
    
    if (nodeCount == 0 && indexPath.row == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceHolderCell];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PlaceHolderCell];
        }
        
        cell.detailTextLabel.text = @"Loading...";
        
        return cell;
    }
    
    VariableHeightCell *cell = (VariableHeightCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[VariableHeightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //Tweet *aTweet = [self.fetchedResultsController objectAtIndexPath:indexPath];
    Tweet *aTweet = [self.tweets objectAtIndex:indexPath.row];
    
    cell.tweet_text = aTweet.text;
    cell.tweet_name = aTweet.user.name;
    
    
    
    if (!aTweet.image) {
        
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
            [self startIconDownload:aTweet forIndexPath:indexPath];
        }
        cell.image = aTweet.image;
    }
    else
    {
        cell.image = aTweet.image;
    }
    
    return cell;
}

/*
- (void)configureCell:(VariableHeightCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    //[cell updateCellInfo:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    [cell updateCellInfo:[self.tweets objectAtIndex:indexPath.row]];
}
*/



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    
    //if (!decelerate)
	//{
        [self loadImagesForOnscreenRows];
    //}
}

/*
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [super scrollViewDidEndDecelerating:scrollView];
    
    [self loadImagesForOnscreenRows];
}
*/

#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(Tweet *)tweet forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil) 
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.tweet = tweet;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];  
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            // Tweet *aTweet = [self.fetchedResultsController objectAtIndexPath:indexPath];
            
            Tweet *aTweet = [self.tweets objectAtIndex:indexPath.row];
            
            if (!aTweet.image) // avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:aTweet forIndexPath:indexPath];
            }
            else {
                [self.imageDownloadsInProgress removeObjectsForKeys:[NSArray arrayWithObject:indexPath ]];
            }
            
        }
    
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        VariableHeightCell *cell = (VariableHeightCell *)[self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        cell.image = iconDownloader.tweet.image;
    }
}

#pragma mark - NSFetchedResultsController things

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest* request = [Tweet fetchRequest];
    NSSortDescriptor* descriptor = [NSSortDescriptor sortDescriptorWithKey:@"created_at" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
    
    NSManagedObjectContext *context = [RKObjectManager sharedManager].objectStore.managedObjectContext;
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:@"dictionaryCache"];
    
    self.fetchedResultsController = aFetchedResultsController;
    self.fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

#pragma mark - Fetched results delegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeUpdate:
            
            
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.imageDownloadsInProgress removeObjectsForKeys:[NSArray arrayWithObject:newIndexPath ]];
            //[self configureCell:(VariableHeightCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            // Reloading the section inserts a new row and ensures that titles are updated appropriately.
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}


@end
