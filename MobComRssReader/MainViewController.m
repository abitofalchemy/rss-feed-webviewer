//
//  MainViewController.m
//  MobComRssReader
//
//  Created by Salvador Aguinaga on 9/12/12.
//  Copyright (c) 2012 Salvador Aguinaga. All rights reserved.
//

#import "MainViewController.h"
//  Add the following two imports
#import "KMXMLParser.h"
#import "WebViewController.h"

#define SCHURZ_RSS_FEED false

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize parseResults = _parseResults;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    /*  Sample RSS Feeds to play with:
        http://www.wsbt.com/news/regional/rss2.0.xml
        http://www.southbendtribune.com/external_rss2.0.xml
        http://feeds.nytimes.com/nyt/rss/Technology
        http://www.southbendtribune.com/ws/content/collection/?collection=sbt_sports_photogalleries&key=d3IwcUN6Ym9NVEV0MWkzcEJsVEU2UFp3bWxmbVRzWFBxbVNyc0pjd1BOWjk4alBLSEpOdHRJVlhXK1dscWhvZg&version=1.0&limit=20
        
        // Use the line below if you want to work offline
        KMXMLParser *parser = [[KMXMLParser alloc]  initWithURL:@"file:///Users/sal/Documents/Tutorials/RSS/rss2.0.xml" delegate:nil];
    */
    
    KMXMLParser *parser;
    if (SCHURZ_RSS_FEED) {
        //Sets the navigation bar title
        self.title = @"News: Schurz";
        
        parser = [[KMXMLParser alloc]  initWithURL:@"http://www.southbendtribune.com/ws/content/collection/?collection=sbt_sports_photogalleries&key=d3IwcUN6Ym9NVEV0MWkzcEJsVEU2UFp3bWxmbVRzWFBxbVNyc0pjd1BOWjk4alBLSEpOdHRJVlhXK1dscWhvZg&version=1.0&limit=20" delegate:nil];
    }else{
        //Sets the navigation bar title
        self.title = @"News: National - NYTimes";
        
        parser = [[KMXMLParser alloc]  initWithURL:@"http://feeds.nytimes.com/nyt/rss/Technology" delegate:nil];
    }
    _parseResults = [parser posts];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return  self.parseResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    // Check if cells is nil, if it is create a new instace of it
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // configure the cell: each row will have the tile of the news feed
    cell.textLabel.text = [[self.parseResults objectAtIndex:indexPath.row] objectForKey:@"title"];
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    WebViewController *vc = [[WebViewController alloc] init];

    // Use the following code when one has to trim the parsed link or url
    NSString *urlLink = [[self.parseResults objectAtIndex:indexPath.row]  objectForKey:@"link"];
    NSString* webStringURL = [urlLink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSScanner *scanner = [NSScanner scannerWithString:webStringURL];
    [scanner scanUpToString:@"%" intoString:nil]; // Scan all characters before #
    NSInteger right;
    right = [scanner scanLocation];
    
    if (SCHURZ_RSS_FEED) {
        // Use this for Schurz feeds
        vc.url = [NSURL URLWithString:[webStringURL substringWithRange:NSMakeRange(0, right)]];
    }else {
        // Use this for standard web-site RSS feeds
        vc.url = [NSURL URLWithString:[[self.parseResults objectAtIndex:indexPath.row]  objectForKey:@"link"]];
    
    }
    //  Verify the link you are passing to the webview
    NSLog(@"link:%@",urlLink);
    [self.navigationController pushViewController:vc animated:YES];
}

@end
