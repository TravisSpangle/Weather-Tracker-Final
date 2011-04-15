//
//  StationCell.m
//  WeatherTracker
//
//  Created by Travis Spangle on 1/29/11.
//  Copyright 2011 Peak Systems. All rights reserved.
//

#import "StationCell.h"
#import "Station.h"

@implementation StationCell

- (id)initWithStyle:(UITableViewCellStyle)style 
	reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		weatherLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		temperatureLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		
		weatherLabel.textColor = [UIColor grayColor];
		
		[[self contentView] addSubview:nameLabel];
		[[self contentView] addSubview:weatherLabel];
		[[self contentView] addSubview:temperatureLabel];
		
		[nameLabel release];
		[weatherLabel release];
		[temperatureLabel release];
					
    }
    return self;
}

- (void)layoutSubviews {

	[super layoutSubviews];
	
	float inset = 4;
	CGRect bounds = [[self contentView] bounds];
	float firstRowHeight = (bounds.size.height / 2);
	float secondRowHeight = (bounds.size.height / 2);
	float tempWidth = 75;
	float detailWidth = bounds.size.width - tempWidth;
	
	CGRect innerFrame = CGRectMake(inset, inset, detailWidth, firstRowHeight - inset);
	[nameLabel setFrame:innerFrame];
	
	innerFrame.origin.y += (firstRowHeight - inset);
	innerFrame.size.height = secondRowHeight;
	[weatherLabel setFrame:innerFrame];
	
	innerFrame.size.width = tempWidth;
	innerFrame.size.height = firstRowHeight - inset;
	innerFrame.origin.x += detailWidth;
	[temperatureLabel setFrame:innerFrame];
}

-(void) setStation:(Station *)station {

	[nameLabel setText:[[station valueForKey:@"name"] description]];
	[weatherLabel setText:[[station valueForKey:@"weather"] description]];
	[temperatureLabel setText:[NSString stringWithFormat:@"%@°",[station valueForKey:@"temperature"]]];

}

@end
