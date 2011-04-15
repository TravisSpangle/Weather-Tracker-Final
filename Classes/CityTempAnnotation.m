//
//  CityTempAnnotation.m
//  Weather
//
//  Created by Travis Spangle on 2/27/11.
//  Copyright 2011 Peak Systems. All rights reserved.
//

#import "CityTempAnnotation.h"
#import "Station.h"

@implementation CityTempAnnotation

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        CGRect frame = self.frame;
        frame.size = CGSizeMake(20.0, 20.0);
		self.backgroundColor = [UIColor clearColor];
        self.frame = frame;
    }
    return self;
}

- (void)setAnnotation:(id <MKAnnotation>)annotation
{
    [super setAnnotation:annotation];
	//recaching for any updated temps
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
	Station *city = (Station *)self.annotation;
    if (city != nil)
    {
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextSetLineWidth(context, 1);
		
		CGMutablePathRef path = CGPathCreateMutable();
		CGPathMoveToPoint(path, NULL, 15.0, 0.5);
		CGPathAddArcToPoint(path, NULL, 19.5, 00.5, 19.5, 5.0, 5.0);
		CGPathAddArcToPoint(path, NULL, 19.5, 19.5, 15.0, 19.5, 5.0);
		CGPathAddArcToPoint(path, NULL, 0.5, 19.5, 10.5, 19.5, 5.0);
		CGPathAddArcToPoint(path, NULL, 0.5, 00.5, 15.0, 0.5, 5.0);
		CGContextAddPath(context, path);
		CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
		CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
		CGContextDrawPath(context, kCGPathFillStroke);
		CGPathRelease(path);
		
		//draw the temperature string and weather graphic
		NSString *temperature = [NSString stringWithFormat:@"%@", city.temperature];
		[[UIColor blackColor] set];
		[temperature drawInRect:CGRectMake(2.0, 2.0, 20.0, 20.0) withFont:[UIFont systemFontOfSize:12.0]];
	}
}

@end
