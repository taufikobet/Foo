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

//static UIFont* system14 = nil;
static UIFont* system15 = nil;
static UIFont* bold15 = nil;
static UIColor* selectedColor = nil;
static UIColor* textColor = nil;
//static UIFont* HelveticaNeueCondensedBold = nil;

+ (void)initialize
{
	if(self == [VariableHeightCell class])
	{
		//system14 = [[UIFont systemFontOfSize:16] retain];
        system15 = [[UIFont systemFontOfSize:15.0] retain];
        bold15 = [[UIFont boldSystemFontOfSize:15.0] retain];
        //HelveticaNeueCondensedBold = [[UIFont fontWithName:@"Helvetica Neue Condensed Bold" size:16] retain]; 
	}
}

- (void)dealloc {
    [info release];
    [image release];
    [super dealloc];
}

- (void) drawContentView:(CGRect)rect highlighted:(BOOL)highlighted {
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (self.isSelected) {
        selectedColor = [UIColor blueColor];   
        textColor = [UIColor whiteColor];
    } else {
        selectedColor = [UIColor whiteColor];
        textColor = [UIColor blackColor];
    }
    
    [selectedColor set];
        
	CGContextFillRect(context, rect);

    NSString* name = [info valueForKeyPath:@"user.name"];
	NSString* text = [info valueForKey:@"text"];

	
    CGFloat imageInset = 48.0;
    CGFloat imageHeight = 48.0;
    
	CGFloat widthr = rect.size.width - 10;
    
    widthr = widthr - imageInset;
    
    CGSize name_size = [name sizeWithFont:bold15 constrainedToSize:CGSizeMake(widthr, 999999) lineBreakMode:UILineBreakModeTailTruncation];
	CGSize size = [text sizeWithFont:system15 constrainedToSize:CGSizeMake(widthr, 999999) lineBreakMode:UILineBreakModeWordWrap];

	[textColor set];

    [name drawInRect:CGRectMake(10.0 + imageInset , 2.0, widthr, name_size.height) withFont:bold15 lineBreakMode:UILineBreakModeTailTruncation];
	[text drawInRect:CGRectMake(10.0 + imageInset , 20.0, widthr, size.height + imageHeight) withFont:system15 lineBreakMode:UILineBreakModeWordWrap];
    
    if (self.image) {
		CGRect r = CGRectMake(5.0, 5.0, imageInset, imageInset);
        //UIImage *roundedImage = [UIImage roundedImage:self.image cornerRadius:7.0 resizeTo:CGSizeMake(128.0, 128.0)];
		[self.image drawInRect:r blendMode:kCGBlendModeNormal alpha:1.0];
	}
}

- (void) updateCellInfo:(NSDictionary*)_info {
	self.info = _info;
    NSString *urlString = [self.info valueForKeyPath:@"user.profile_image_url"];
	if (urlString) {
        AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] success:^(UIImage *requestedImage) {
            self.image = [UIImage roundedImage:requestedImage cornerRadius:7.0 resizeTo:CGSizeMake(64.0, 64.0)];
            [self setNeedsDisplay];
        }];
        [operation start];
    }
}

+ (CGFloat) heightForCellWithInfo:(NSDictionary*)_info inTable:(UITableView *)tableView {
	
    NSString* name = [_info valueForKeyPath:@"user.name"];
    NSString* text = [_info valueForKey:@"text"];
    
    CGFloat imageInset = 48.0;
    CGFloat imageHeight = 48.0;
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
