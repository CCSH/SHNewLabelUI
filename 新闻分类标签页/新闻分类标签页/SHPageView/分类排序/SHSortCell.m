//
//  SHSortCell.m
//  新闻分类标签页
//
//  Created by Dvel on 16/4/15.
//  Copyright © 2016年 Dvel. All rights reserved.
//

#import "SHSortCell.h"

@implementation SHSortCell

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		_button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		[_button setBackgroundImage:[UIImage imageNamed:@"channel_sort_circle"] forState:UIControlStateNormal];
		[_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		_button.titleLabel.font = [UIFont systemFontOfSize:13];
		[self addSubview:_button];
	}
	return self;
}


@end
