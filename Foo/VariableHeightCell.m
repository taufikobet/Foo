//
//  VariableHeightCell.m
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

#import "VariableHeightCell.h"
#import "DictionaryHelper.h"

@implementation VariableHeightCell

@synthesize info;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) 
    {
		self.backgroundColor = [UIColor whiteColor];
		self.opaque = YES;
    }
    return self;
}

- (void) prepareForReuse {
	[super prepareForReuse];
}

//static UIFont* system14 = nil;
static UIFont* system15 = nil;
//static UIFont* HelveticaNeueCondensedBold = nil;

+ (void)initialize
{
	if(self == [VariableHeightCell class])
	{
		//system14 = [[UIFont systemFontOfSize:16] retain];
        system15 = [[UIFont systemFontOfSize:15] retain];
        //HelveticaNeueCondensedBold = [[UIFont fontWithName:@"Helvetica Neue Condensed Bold" size:16] retain]; 
	}
}

- (void)dealloc {
    [info release];
    
    [super dealloc];
}

- (void) drawContentView:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[[UIColor whiteColor] set];
	CGContextFillRect(context, rect);
	
	NSString* text = [info valueForKey:@"text"];
	
    CGFloat imageInset = 40.0;
    
	CGFloat widthr = rect.size.width - 10;
    
    widthr = widthr - imageInset;
    
	CGSize size = [text sizeWithFont:system15 constrainedToSize:CGSizeMake(widthr, 999999) lineBreakMode:UILineBreakModeTailTruncation];
	
	[[UIColor blackColor] set];
    
	[text drawInRect:CGRectMake(5.0 + imageInset , 5.0, widthr, size.height) withFont:system15 lineBreakMode:UILineBreakModeTailTruncation];
}

- (void) updateCellInfo:(NSDictionary*)_info {
	self.info = _info;
    [self setNeedsDisplay];
}

+ (CGFloat) heightForCellWithInfo:(NSDictionary*)_info inTable:(UITableView *)tableView {
	NSString* text = [_info valueForKey:@"text"];
    
    CGFloat imageInset = 40.0;
    
	CGFloat widthr = tableView.frame.size.width - 10;
    
    widthr = widthr - imageInset;
    
	CGSize size = [text sizeWithFont:system15 constrainedToSize:CGSizeMake(widthr, 999999) lineBreakMode:UILineBreakModeTailTruncation];
	return size.height + 10;
}

@end
