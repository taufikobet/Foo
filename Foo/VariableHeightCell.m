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
#import "UIImageView+AFNetworking.h"

@implementation VariableHeightCell

@synthesize info;
@synthesize image;

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
    self.image = nil;
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
    [image release];
    [super dealloc];
}

- (void) drawContentView:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[[UIColor whiteColor] set];
	CGContextFillRect(context, rect);
	
	NSString* text = [info valueForKey:@"text"];
	
    CGFloat imageInset = 40.0;
    CGFloat imageHeight = 32.0;
    
	CGFloat widthr = rect.size.width - 10;
    
    widthr = widthr - imageInset;
    
	CGSize size = [text sizeWithFont:system15 constrainedToSize:CGSizeMake(widthr, 999999) lineBreakMode:UILineBreakModeWordWrap];
	
	[[UIColor blackColor] set];
    
	[text drawInRect:CGRectMake(5.0 + imageInset , 5.0, widthr, size.height + imageHeight) withFont:system15 lineBreakMode:UILineBreakModeWordWrap];
    
    if (self.image) {
		CGRect r = CGRectMake(5.0, 8.0, 32.0, 32.0);
		[self.image drawInRect:r];
	}
}

- (void) updateCellInfo:(NSDictionary*)_info {
	self.info = _info;
    NSString *urlString = [self.info valueForKeyPath:@"user.profile_image_url"];
	if (urlString) {
        AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] success:^(UIImage *requestedImage) {
            self.image = requestedImage;
            [self setNeedsDisplay];
        }];
        [operation start];
    }
}

+ (CGFloat) heightForCellWithInfo:(NSDictionary*)_info inTable:(UITableView *)tableView {
	NSString* text = [_info valueForKey:@"text"];
    
    CGFloat imageInset = 40.0;
    CGFloat imageHeight = 40.0;
    
	CGFloat widthr = tableView.frame.size.width - 10;
    
    widthr = widthr - imageInset;
    
	CGSize size = [text sizeWithFont:system15 constrainedToSize:CGSizeMake(widthr, 999999) lineBreakMode:UILineBreakModeWordWrap];
    
    if (size.height < imageHeight) size.height = imageHeight;
    
	return size.height + 10;
}

@end
