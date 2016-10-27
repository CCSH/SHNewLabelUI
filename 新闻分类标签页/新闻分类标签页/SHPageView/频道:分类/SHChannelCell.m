//
//  SHChannelCell.m
//  新闻分类标签页
//
//  Created by Dvel on 16/4/7.
//  Copyright © 2016年 Dvel. All rights reserved.
//

#import "SHChannelCell.h"

#import "UIView+Extension.h"

@implementation SHChannelCell

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {

	}
	return self;
}

- (void)setUrlString:(NSString *)urlString
{
	_urlString = urlString;
	
    NSLog(@"%@",urlString);
}

@end
