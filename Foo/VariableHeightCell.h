//
//  VariableHeightCell.h
//  IOSBoilerplate
//
//  Copyright (c) 2011 Alberto Gimeno Brieba
//  
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//  

#import "ABTableViewCell.h"

@interface VariableHeightCell : ABTableViewCell

@property (nonatomic, retain) NSDictionary* info;

@property (nonatomic, copy) UIImage* image;
@property (nonatomic, copy) NSString* tweet_name;
@property (nonatomic, copy) NSString* tweet_text;

- (void) updateCellInfo:(NSDictionary*)_info;
+ (CGFloat) heightForCellWithInfo:(NSDictionary*)_info inTable:(UITableView *)tableView;

- (UIImage*) roundCorneredImage: (UIImage*) orig radius:(CGFloat) r;

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef  endColor);
static CGGradientRef GetCellBackgroundGradient(CFArrayRef colors);

@end
