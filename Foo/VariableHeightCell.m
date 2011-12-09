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
#import "UIImage+FTAdditions.h"

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

static UIFont* system15 = nil;
static UIFont* bold15 = nil;
static CGFloat imageInset = 48.0;
static CGFloat imageHeight = 48.0;

+ (void)initialize
{
	if(self == [VariableHeightCell class])
	{
        system15 = [[UIFont systemFontOfSize:15.0] retain];
        bold15 = [[UIFont boldSystemFontOfSize:15.0] retain];
	}
}

- (void)dealloc {
    [info release];
    [image release];
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:YES];
    [self setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:YES];
    [self setNeedsDisplay];
}

- (void)drawCellBackground:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorRef notQuiteWhiteColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 
                                                     blue:245.0/255.0 alpha:1.0].CGColor;
    CGColorRef lightGrayColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 
                                                 blue:235.0/255.0 alpha:1.0].CGColor;
    
    drawLinearGradient(context, rect, notQuiteWhiteColor, lightGrayColor);
}

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef  endColor)
{    
    NSArray *colors = [NSArray arrayWithObjects:(id)startColor, (id)endColor, nil];
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextDrawLinearGradient(context, GetCellBackgroundGradient((CFArrayRef)colors), startPoint, endPoint, 0);
    CGContextRestoreGState(context);

}

static CGGradientRef GetCellBackgroundGradient(CFArrayRef colors)
{
    static CGGradientRef gradient = NULL ;
    if ( !gradient )
    {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat locations[] = { 0.0, 1.0 };
        
        gradient = CGGradientCreateWithColors(colorSpace, colors, locations);
        
        CGColorSpaceRelease(colorSpace);
    }
    
    return gradient;
}


- (void) drawContentView:(CGRect)rect highlighted:(BOOL)highlighted {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (highlighted || [self isSelected]) {
        [[UIColor blueColor] set];
        CGContextFillRect(context, rect);
    }
	
    

    
    if (!(highlighted || [self isSelected])) {
        [self drawCellBackground:rect];
    }
    
    NSString* name = [info valueForKeyPath:@"user.name"];
	NSString* text = [info valueForKey:@"text"];

    CGFloat widthr = rect.size.width - 10;
    widthr = widthr - imageInset;
    
    CGSize name_size = [name sizeWithFont:bold15 constrainedToSize:CGSizeMake(widthr, 999999) lineBreakMode:UILineBreakModeTailTruncation];
	CGSize size = [text sizeWithFont:system15 constrainedToSize:CGSizeMake(widthr, 999999) lineBreakMode:UILineBreakModeWordWrap];

	if (highlighted || [self isSelected]) [[UIColor whiteColor] set];
    if (!(highlighted || [self isSelected])) [[UIColor blackColor] set];

    [name drawInRect:CGRectMake(10.0 + imageInset , 2.0, widthr, name_size.height) withFont:bold15 lineBreakMode:UILineBreakModeTailTruncation];
	[text drawInRect:CGRectMake(10.0 + imageInset , 20.0, widthr, size.height + imageHeight) withFont:system15 lineBreakMode:UILineBreakModeWordWrap];
    
    if (self.image) {
		[self.image drawAtPoint:CGPointMake(5.0, 5.0)];
	}
    

}

- (void) updateCellInfo:(NSDictionary*)_info {
	self.info = _info;
    NSString *urlString = [self.info valueForKeyPath:@"user.profile_image_url"];
	if (urlString) {
        if (!self.image) {
            AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] success:^(UIImage *requestedImage) {
                self.image = [UIImage roundedImage:requestedImage cornerRadius:6.0 resizeTo:CGSizeMake(48.0, 48.0)];
                [self setNeedsDisplay];
            }];
            [operation start];
        }
    }
}

- (UIImage*) roundCorneredImage: (UIImage*) orig radius:(CGFloat) r {
    UIGraphicsBeginImageContextWithOptions(orig.size, NO, 0);
    [[UIBezierPath bezierPathWithRoundedRect:(CGRect){CGPointZero, orig.size} 
                                cornerRadius:r] addClip];
    [orig drawInRect:(CGRect){CGPointZero, orig.size}];
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+ (CGFloat) heightForCellWithInfo:(NSDictionary*)_info inTable:(UITableView *)tableView {
	
    NSString* name = [_info valueForKeyPath:@"user.name"];
    NSString* text = [_info valueForKey:@"text"];
    
    CGFloat imagePadding = 12.0;
    
	CGFloat widthr = tableView.frame.size.width - 10;
    
    widthr = widthr - imageInset;

    CGSize name_size = [name sizeWithFont:bold15 constrainedToSize:CGSizeMake(widthr, 999999) lineBreakMode:UILineBreakModeTailTruncation];
	CGSize size = [text sizeWithFont:system15 constrainedToSize:CGSizeMake(widthr, 999999) lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat totalHeight = size.height + name_size.height + 5.0;
    
    CGFloat imagePaddingAndHeight = imagePadding + imageHeight;
    
    if (totalHeight < imagePaddingAndHeight ) totalHeight = imagePaddingAndHeight;
    
    return totalHeight;
    
}

@end
