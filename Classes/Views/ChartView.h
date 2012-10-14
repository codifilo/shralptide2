//
//  ChartView.h
//  ShralpTide
//
//  Created by Michael Parlee on 9/22/08.
//  Copyright 2009 Michael Parlee. All rights reserved.
/*
   This file is part of ShralpTide.

   ShralpTide is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   ShralpTide is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with ShralpTide.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "ChartViewDatasource.h"
#import "SDTideInterval.h"
#import "SDTide.h"
#import "SDTideEvent.h"
#import "CursorView.h"

@interface ChartView : UIView

-(int)currentTimeInMinutes;
-(void)animateCursorViewToCurrentTime;
-(void)animateFirstTouchAtPoint:(CGPoint)touchPoint;

@property (nonatomic, unsafe_unretained) id<ChartViewDatasource> datasource;
@property (nonatomic, strong) IBOutlet UIView *cursorView;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *valueLabel;
@property (nonatomic, strong) IBOutlet UIImageView *sunriseIcon;
@property (nonatomic, strong) IBOutlet UIImageView *sunsetIcon;
@property (nonatomic, strong) IBOutlet UIImageView *moonriseIcon;
@property (nonatomic, strong) IBOutlet UIImageView *moonsetIcon;
@end
