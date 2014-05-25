//
//  LandscapeViewController.m
//  ShralpTide2
//
//  Created by Michael Parlee on 7/9/13.
//
//

#import "LandscapeViewController.h"
#import "ShralpTideAppDelegate.h"
#import "ChartViewController.h"
#import "SDTideFactory.h"
#import "NSDate+Day.h"
#import <QuartzCore/QuartzCore.h>

#define appDelegate ((ShralpTideAppDelegate*)[[UIApplication sharedApplication] delegate])


@interface LandscapeViewController ()

@property (nonatomic,assign) BOOL pageControlUsed;
@property (nonatomic,strong) SDTide *tide;
@property (nonatomic,strong) NSDateFormatter *dateFormatter;
@property (nonatomic,strong) NSDateFormatter *timeFormatter;

@end

@implementation LandscapeViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterFullStyle;
    
    self.timeFormatter = [[NSDateFormatter alloc] init];
    self.timeFormatter.timeStyle = NSDateFormatterShortStyle;
}

/**
 * I'm going to have to manage the chart view independently of the root view controller.
 * This means that this class will have to handle drawing the individual views, caching one
 * view forward and one view back (if we're going to do that) and refreshing the views as
 * needed.
 *
 * How can we propagate the signal to refresh all of the tide info? Maybe a fire a notification.
 *
 * I think this is potentially a really great refactoring. :) I should also consider moving to 
 * doxygen docs. I think that will be helpful for any future dev waiding into this mess.
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.heightView.layer.cornerRadius = 5;
    self.heightView.layer.masksToBounds = YES;
    
    _activityView.layer.cornerRadius = 10;
    _activityView.layer.masksToBounds = YES;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    _tide = self.locationMainViewController.tide;
    
    _activityView.hidden = NO;
    _activityIndicator.hidden = NO;
    [_activityIndicator startAnimating];
    
    [self createChartViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Handle Screen Rotation
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    switch (toInterfaceOrientation) {
        case UIDeviceOrientationLandscapeLeft:
            DLog(@"Device rotated to Landscape Left");
            break;
        case UIDeviceOrientationLandscapeRight:
            DLog(@"Device rotated to Landscape Right");
            break;
        case UIDeviceOrientationPortrait:
            DLog(@"Device rotated to Portrait");
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            DLog(@"Device rotated to Portrait upsidedown");
            break;
    }
}

- (void)createChartViews
{
    [self clearChartViews];
    self.locationLabel.text = [self.tide shortLocationName];
    self.dateLabel.text = [self.dateFormatter stringFromDate:[_tide.startTime dateByAddingTimeInterval:30 * 60 * 60 * appDelegate.page]];
    
    self.chartScrollView.pagingEnabled = YES;
	// put 20 back on the height and subtract 20 from width to account for scroll bar at top of landscape
 //   DLog(@"Frame = %0.1f x %0.1f", self.view.frame.size.width, self.view.frame.size.height);
	self.chartScrollView.contentSize = CGSizeMake((self.view.frame.size.width) * appDelegate.daysPref, self.view.frame.size.height);
	self.chartScrollView.showsVerticalScrollIndicator = NO;
	self.chartScrollView.showsVerticalScrollIndicator = NO;
	self.chartScrollView.scrollsToTop = NO;
	self.chartScrollView.directionalLockEnabled = YES;
	self.chartScrollView.delegate = self;
	self.chartScrollView.autoresizingMask = UIViewAutoresizingNone;
    
    self.chartView.frame = CGRectMake(0,0,self.chartScrollView.contentSize.width,self.chartScrollView.frame.size.height);
    self.chartView.datasource = self;
    self.chartView.hoursToPlot = appDelegate.daysPref * 24;
    self.chartView.labelInset = 20;
    self.chartView.delegate = self;
    [self.chartScrollView addSubview:self.chartView];
    self.chartScrollView.contentOffset = CGPointMake(appDelegate.page * self.view.frame.size.width, 0);
}

- (void)clearChartViews
{
    for (UIView* view in [self.chartScrollView subviews]) {
        [view removeFromSuperview];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.chartView animateCursorViewToCurrentTime];
}

- (void)loadChartScrollViewWithPage:(int)page {
    //    if (page < 0) return;
    //    if (page >= appDelegate.daysPref) return;
    
    // okay we need to put the current page into a shared location.
	
    // replace the placeholder if necessary
    //    ChartViewController *controller = self.chartViewControllers[page];
    //    if ((NSNull *)controller == [NSNull null]) {
    //        DLog(@"Initializing new ChartViewController");
    //		controller = [[ChartViewController alloc] initWithNibName:@"ChartView" bundle:nil tide:[self.viewControllers[page] sdTide]];
    //        self.chartViewControllers[page] = controller;
    //    } else {
    //		if (controller.sdTide == nil) {
    //			[controller setSdTide:[self.viewControllers[page] sdTide]];
    //		}
    //	}
    
    //    controller.page = page;
    //
    //    // add the controller's view to the scroll view
    //    if (nil == controller.view.superview) {
    //        CGRect frame = self.chartScrollView.frame;
    //        frame.origin.x = frame.size.width * page;
    //        frame.origin.y = 0;
    //        controller.view.frame = frame;
    //        [self.chartScrollView addSubview:controller.view];
    //    }
	
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    static int lastPageIndex;
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = sender.frame.size.width;
    int pageNumber = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (pageNumber != lastPageIndex) {
        // ** IMPORTANT! I base the date string on 0600 time to avoid funny business with the time DST/ST changes. They occur at 0200.
        self.dateLabel.text = [self.dateFormatter stringFromDate:[_tide.startTime dateByAddingTimeInterval:(6 + (24 * pageNumber)) * 60 * 60]];
        lastPageIndex = pageNumber;
        appDelegate.page = pageNumber;
    }
    // when we scroll to a future tide, hide the current tide level.
    
    [UIView beginAnimations:kCATransition context:nil];
    
    if (self.page == 0) {
        //self.heightLabel.hidden = NO;
        self.heightView.alpha = 1.0;
    } else {
        //self.heightLabel.hidden = YES;
        self.heightView.alpha = 0.0;
    }
    
    [UIView commitAnimations];
}

#pragma mark Interactive Chart View Delegate
- (void)displayHeight:(CGFloat)height atTime:(NSDate*)time withUnitString:(NSString*)units
{
    [UIView beginAnimations:kCATransition context:nil];
    //self.heightLabel.hidden = NO;
    self.heightView.alpha = 1.0;
    self.heightLabel.text = [NSString stringWithFormat:@"%0.2f %@ @ %@", height, units, [self.timeFormatter stringFromDate:time]];
    [UIView commitAnimations];
}

- (void)interactionsEnded
{
    // if we're not on today's graph, hide the current tide level.
    if (self.page != 0) {
        [UIView beginAnimations:kCATransition context:nil];
        //self.heightLabel.hidden = YES;
        self.heightView.alpha = 0.0;
        [UIView commitAnimations];
    }
}

#pragma mark Tide Chart Data source
- (SDTide *)tideDataToChart
{
    return _tide;
}

- (NSDate*)day
{
    return _tide.startTime;
}

- (int)page
{
    CGFloat pageWidth = self.chartScrollView.frame.size.width;
    int page = floor((self.chartScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    return page;
}

#pragma mark Tide Calculation Delegate
- (void)tideCalculationsCompleted:(NSArray*)tides
{
    self.tide = [SDTide tideByCombiningTides:tides];
    DLog(@"Tide calc completed for: %@, %lu days",self.tide.stationName, (unsigned long)[tides count]);
    [self.chartView setNeedsDisplay];
    [self createChartViews];
    
    self.activityView.hidden = YES;
    [self.activityIndicator stopAnimating];
}

@end