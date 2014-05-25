//
//  DailySummaryViewController.h
//  ShralpTide2
//
//  Created by Michael Parlee on 7/20/13.
//
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "ChartScrollView.h"
#import "LandscapeViewController.h"
#import "SDTide.h"

/**
 * This is now our root view controller it contains two subcontrollers and a view to display the page controller
 * and list view button... oh... I guess the add location feature now belongs under the favorites list.
 */
@interface PortraitViewController : UIViewController <ADBannerViewDelegate>

@property (nonatomic, weak) IBOutlet UIButton* listViewButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bannerAdTop;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *listButtonBottom;

@end