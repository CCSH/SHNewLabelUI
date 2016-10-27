//
//  SHChannelLabel.m
//  新闻分类标签页
//
//  Created by Dvel on 16/4/7.
//  Copyright © 2016年 Dvel. All rights reserved.
//

#import "SHChannelLabel.h"

@implementation SHChannelLabel

+ (instancetype)channelLabelWithTitle:(NSString *)title
{
	SHChannelLabel *label = [self new];
	label.text = title;
	label.textAlignment = NSTextAlignmentCenter;
	label.font = [UIFont systemFontOfSize:18];
	[label sizeToFit];
	label.userInteractionEnabled = YES;
	return label;
}

- (CGFloat)textWidth
{
	return [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}].width + 8; // +8，要不太窄
}


- (void)setScale:(CGFloat)scale
{
	_scale = scale;

	self.textColor = [UIColor colorWithRed:scale*0.176 green:scale*0.722 blue:scale*0.945 alpha:1];
}



- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %p> %@", self.class, self, self.text];
}

@end
