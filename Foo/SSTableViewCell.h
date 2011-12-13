//
//  SSTableViewCell.h
//  SSTableViewCell
//
//  Created by Sam Soffes on 8/16/10.
//  Copyright 2010 Sam Soffes. All rights reserved.
//
//  Based on ABTableViewCell by Loren Brichter
//

@interface SSTableViewCell : UITableViewCell {
	
@protected

	UIView *_cellView;
}

@property (nonatomic, retain, readonly) UIView *cellView;

- (void)drawContentView:(CGRect)rect;
- (CGRect)cellViewFrame;

@end
