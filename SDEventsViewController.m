//
//  SDEventsViewController.m
//  ShralpTide2
//
//  Created by Michael Parlee on 9/23/13.
//
//

#import "SDEventsViewController.h"
#import "SDTideEvent.h"
#import "SDTideEventCell.h"
#import "SDTideFactory.h"

@interface SDEventsViewController ()

@end

@implementation SDEventsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dateLabel.adjustsFontSizeToFitWidth = YES;
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.formatterBehavior = NSDateFormatterBehaviorDefault;
    formatter.dateStyle = NSDateFormatterFullStyle;
    self.dateLabel.text = [formatter stringFromDate:(self.tide).startTime];
    
    _chartView.height = 40;
    _chartView.datasource = self;
    _chartView.hoursToPlot = 24;
    _chartView.frame = CGRectMake(0, 0, _chartScrollView.frame.size.width, _chartView.frame.size.height);
    
    //DLog(@"Setting content width to %f",_chartView.frame.size.width);
    _chartScrollView.contentSize = _chartView.frame.size;
    [_chartScrollView addSubview:_chartView];
}

- (void)redrawChart
{
    [_chartView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table View Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.bounds.size.height / 4;
}

#pragma mark Table View Data Source methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDate *date = (self.tide).startTime;
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSUInteger preservedComponents = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
    date = [calendar dateFromComponents:[calendar components:preservedComponents fromDate:date]];
    date = [date dateByAddingTimeInterval:1440 * 60]; // add one day to get midnight tonight
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventTime < %@", date];
    NSArray *todaysEvents = [self.tide.events filteredArrayUsingPredicate:predicate];
    return todaysEvents.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //DLog(@"Cell for Row at Index Path %ld", (long)indexPath.row);
    static NSString* reuseId = @"eventCell";
    SDTideEvent *event = (SDTideEvent*)self.tide.events[indexPath.row];
    SDTideEventCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    cell.timeLabel.text = event.eventTimeNativeFormat;
    cell.heightLabel.text = [NSString stringWithFormat:@"%1.2f%@",event.eventHeight,self.tide.unitShort];
    cell.typeLabel.text = event.eventTypeDescription;
    return cell;
}

#pragma mark ChartViewDatasource Methods
-(SDTide *)tideDataToChart
{
    return _tide;
}

-(NSDate*)day
{
    return _tide.startTime;
}

-(int)page
{
    return 0;
}
@end
