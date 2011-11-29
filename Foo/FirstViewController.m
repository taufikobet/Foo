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

@implementation FirstViewController

@synthesize tweets;

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
        self.tableView.showsVerticalScrollIndicator = NO;
        [self populateTableViewCellWithTweets];
        
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

    RKManagedObjectMapping* userMapping = [RKManagedObjectMapping mappingForClass:[User class] ];
    [userMapping mapKeyPath:@"id_str" toAttribute:@"id_str"];
    [userMapping mapKeyPath:@"name" toAttribute:@"name"];
    [userMapping mapKeyPath:@"screen_name" toAttribute:@"screen_name"];
    [userMapping mapKeyPath:@"profile_image_url" toAttribute:@"profile_image_url"];
    [userMapping setPrimaryKeyAttribute:@"id_str"];
    
    RKManagedObjectMapping* tweetMapping = [RKManagedObjectMapping mappingForClass:[Tweet class] ];
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"EEE MMM dd kk:mm:ss ZZZZ yyyy"];
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
}

- (void)loadNewTweets {
    
    RKObjectMapping* tweetMapping = [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[Tweet class] ];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/statuses/user_timeline/taufik_obet.json" objectMapping:tweetMapping delegate:self];

}

// ... and grab the data via its delegate...
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    
    [self populateTableViewCellWithTweets];
    
    [self.tableView reloadData];
    
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
    
    //[MKInfoPanel showPanelInWindow:[UIApplication sharedApplication].delegate.window  type:MKInfoPanelTypeInfo title:@"Loaded." subtitle:@"Latest news loaded from internetz." hideAfter:2.0];
    
    
     for (id obj in objects) {
         NSLog(@"%@", [obj valueForKey:@"text"]);
         NSLog(@"%@", [[obj valueForKey:@"created_at"] description]);
         NSLog(@"%@", [obj valueForKeyPath:@"user.screen_name"]);
         NSLog(@"%@", [obj valueForKeyPath:@"user.profile_image_url"]);
     }
     

}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {


    [MKInfoPanel showPanelInWindow:[UIApplication sharedApplication].delegate.window  type:MKInfoPanelTypeError title:@"INTERNET" subtitle:@"Y U NO AVAILABLE" hideAfter:2.0];

    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];

}

// Pull to refresh
- (void)refresh {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    [self loadNewTweets];
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
    return [self.tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    VariableHeightCell *cell = (VariableHeightCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[VariableHeightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //cell.textLabel.text = [[self.tweets objectAtIndex:indexPath.row] valueForKeyPath:@"user.screen_name"];
    //cell.detailTextLabel.text = [[self.tweets objectAtIndex:indexPath.row] valueForKey:@"text"];
    
    NSDictionary* obj = [self.tweets objectAtIndex:indexPath.row];
    [cell updateCellInfo:obj];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
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

@end
