//
//  DTCustomColoredAccessory.h
//  NordicSemiDemo
//
//  Created by Ransom Weaver on 12/1/11.
//

#import <UIKit/UIKit.h>

@interface DTCustomColoredAccessory : UIControl
{
	UIColor *_accessoryColor;
	UIColor *_highlightedColor;
}

@property (nonatomic, retain) UIColor *accessoryColor;
@property (nonatomic, retain) UIColor *highlightedColor;

+ (DTCustomColoredAccessory *)accessoryWithColor:(UIColor *)color;

@end