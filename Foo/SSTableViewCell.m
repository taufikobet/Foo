//
//  SSTableViewCell.m
//  SSTableViewCell
//
//  Created by Sam Soffes on 8/16/10.
//  Copyright 2010 Sam Soffes. All rights reserved.
//

#import "SSTableViewCell.h"

@interface SSTableViewCellView : UIView
@end

@implementation SSTableViewCellView

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.opaque = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.contentMode = UIViewContentModeRedraw;
	}
	return self;
}


- (void)drawRect:(CGRect)rect {
	SSTableViewCell *cell = (SSTableViewCell *)[self superview];
	if (cell.highlighted == NO) {
		[super drawRect:rect];
	}
	[cell drawContentView:rect];
}

@end


@implementation SSTableViewCell

@synthesize cellView = _cellView;

#pragma mark UIView

- (void)setNeedsDisplay {
	[super setNeedsDisplay];
	[_cellView setNeedsDisplay];
}


- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	_cellView.frame = [self cellViewFrame];
	[self setNeedsDisplay];
}


#pragma mark UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		self.backgroundView.hidden = YES;
		self.textLabel.hidden = YES;
		self.detailTextLabel.hidden = YES;
		self.imageView.hidden = YES;
		self.contentView.hidden = YES;
		
		_cellView = [[SSTableViewCellView alloc] initWithFrame:CGRectZero];
		[self addSubview:_cellView];
		[_cellView release];
    }
    return self;
}


#pragma mark Custom Drawing

- (void)drawContentView:(CGRect)rect {
	// Subclasses should implement this
}


- (CGRect)cellViewFrame {
	return self.contentView.frame;
}

@end
