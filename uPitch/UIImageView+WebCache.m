/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"

@implementation UIImageView (WebCache)


- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}
- (void)setImageWithURL:(NSURL *)url imagesize:(CGSize)size;
{
    [self setImageWithURL:url placeholderImage:nil imagesize:size];
}

- (void)setImageWithURL1:(NSURL *)url placeholderImage:(UIImage *)placeholder imagesize:(CGSize)size;
{
    //UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
   // UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
    self.userInteractionEnabled=NO;
     UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    [activity startAnimating];
    CGFloat a=size.width/2;
    CGFloat b=size.height/2;
    activity.frame=CGRectMake(a-10, b-10, 20, 20);
    //[activity setCenter:self.center];
    [self addSubview:activity];
    [activity release];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    self.image = placeholder;
    //for test
    if (url)
    {
        [manager downloadWithURL:url delegate:self];
    }
    else
    {
        self.userInteractionEnabled=YES;
    }
    UIImage *cachedImage = [manager imageWithURL:url];
    
    if (cachedImage)
    {
        // the image is cached -> remove activityIndicator from view
        for (UIView *v in [self subviews])
        {
            if ([v isKindOfClass:[UIActivityIndicatorView class]])
            {
                [activity removeFromSuperview];
            }
        }
    }
    
}
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder imagesize:(CGSize)size;
{
    //UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
    
     UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
    [activity startAnimating];
    CGFloat a=size.width/2;
    CGFloat b=size.height/2;
    activity.frame=CGRectMake(a, b, 37.5, 37.5);
     [activity setCenter:self.center];
    //[self addSubview:activity];
    [activity release];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    self.image = placeholder;
    //for test
    
    
    
    if (url)
    {
        [manager downloadWithURL:url delegate:self];
    }
    else
    {
        self.userInteractionEnabled=YES;
    }
    
    
    UIImage *cachedImage = [manager imageWithURL:url];
    
    if (cachedImage)
    {
        // the image is cached -> remove activityIndicator from view
        for (UIView *v in [self subviews])
        {
            if ([v isKindOfClass:[UIActivityIndicatorView class]])
            {
                [activity removeFromSuperview];
            }
        }
    }

}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    [activity startAnimating];
    activity.frame=CGRectMake(45, 40, 20, 20);
  //  [activity setCenter:self.center];
    //[self addSubview:activity];
    [activity release];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;
    //for test
    
    

    if (url)
    {
        [manager downloadWithURL:url delegate:self];
    }
    
    
    UIImage *cachedImage = [manager imageWithURL:url];
    
    if (cachedImage)
    {
        // the image is cached -> remove activityIndicator from view
        for (UIView *v in [self subviews])
        {
            if ([v isKindOfClass:[UIActivityIndicatorView class]])
            {
                [activity removeFromSuperview];
            }
        }
    }
}

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    self.image = image;
    
    for (UIView *v in [self subviews])
    {
        if ([v isKindOfClass:[UIActivityIndicatorView class]])
        {
            
            // NSLog(@"-didFinishWithImage-");
            [((UIActivityIndicatorView*)v) stopAnimating];
            [v removeFromSuperview];
        }
    }
    
    self.userInteractionEnabled=YES;
//    [UIView beginAnimations:@"fadeAnimation" context:NULL]; 
//    [UIView setAnimationDuration:0.9];
//    self.alpha = 0;
//    self.image = image;
//    self.alpha=1;
//    //[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES]; 
//    [UIView commitAnimations];
}

@end
