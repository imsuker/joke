//
//  JokeViewController.m
//  Joke
//
//  Created by Gukw on 8/1/13.
//  Copyright (c) 2013 iphone. All rights reserved.
//

#import "JokeViewController.h"
#import "AudioViewController.h"
#import "UIImageView+Joke.h"

@interface JokeViewController ()

@end

@implementation JokeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _yFree = 20; //顶部空白
    
    _labelTitle.text = _jokeModel.title;
    [_labelTitle sizeToFit];
    _yFree += _labelTitle.bounds.size.height;
    NSArray *audios = _jokeModel.audios;
    [audios enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        _yFree += 8;
        AudioViewController *audio = [[AudioViewController alloc] initWithNibName:nil bundle:nil];
        audio.urlAudio = obj;
        audio.nameSource = [NSString stringWithFormat:@"/%d_%d.mp3",_jokeModel.jokeId, idx];
        audio.y = _yFree;
        _yFree += audio.heightView;
        NSLog(@"====AudioViewController prepared!!!");
        [self addChildViewController:audio];
        [_scrollView addSubview:audio.view];
    }];
    NSArray *pics = _jokeModel.pics;
    [pics enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        _yFree += 10;
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = [self ResizePicBounds:CGRectMake(30, _yFree, [obj[@"w"] integerValue]/2, [obj[@"h"] integerValue]/2)];
        [_scrollView addSubview:imageView];
        [imageView setImageUrl:obj[@"pic"]];
        _yFree += imageView.bounds.size.height;
        NSString *url = obj[@"url"];
            if(url && ![@"" isEqual:url]){
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPic:)];
            [imageView addGestureRecognizer:tap];
            imageView.userInteractionEnabled = YES;
            imageView.tag = 100;
            imageView.accessibilityLanguage = [NSString stringWithFormat:@"%d", idx];
        }
    }];
//    _yFree += 8;
    
    [_webViewContent loadHTMLString:_jokeModel.content baseURL:nil];
    _webViewContent.frame = [Util adjustFrame:_webViewContent.frame withY:_yFree];
    
    //设置滚动内容的背景
    UIImage *imageScrollViewBackground = [UIImage imageNamed:@"contentbox"];
    _imageViewScrollViewBackground.image = [imageScrollViewBackground resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 10, 10)];
    

}
//图片太大时做特殊处理
- (CGRect)ResizePicBounds:(CGRect)frame{
    NSInteger width = frame.size.width;
    NSInteger height = frame.size.height;
    NSInteger maxHeight = 320 - 30*2;
    if(width > maxHeight){//如果图片的最大宽度
        frame.size.width = maxHeight;
        frame.size.height = height*maxHeight/width;
    }
    return frame;
}
//webview的内容是异步加载，因此在加载成功后重新设定其高度和下面的内容
-(void)reAdjustWebViewAndOther{
    _yFree += _webViewContent.bounds.size.height;
    
    _yFree += 8;
    _labelPassed.text =[NSString stringWithFormat:@"%d路过",_jokeModel.visit + 1];
    _buttonLike.titleLabel.text = [NSString stringWithFormat:@"%d", _jokeModel.collect];
    _buttonLike.frame = [Util adjustFrame:_buttonLike.frame withY:_yFree];
    _labelPassed.frame = [Util adjustFrame:_labelPassed.frame withY:_yFree + 4];
    _yFree += _buttonLike.bounds.size.height;
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, _yFree+10);
    
    NSInteger heightScrollViewBackground = _yFree;
    if(heightScrollViewBackground < self.view.bounds.size.height + 100){
        heightScrollViewBackground = self.view.bounds.size.height + 100;
    }
    _imageViewScrollViewBackground.frame = [Util adjustFrame:_imageViewScrollViewBackground.frame withHeight:heightScrollViewBackground];//背景图片顶部距离10
}
-(void)tapPic:(UIGestureRecognizer *)sender{
    UIImageView *picView = (UIImageView *)[sender.view hitTest:[sender locationInView:sender.view] withEvent:nil];
    if(picView){
        NSLog(@"access:%@",picView.accessibilityLanguage);
        NSInteger index = [picView.accessibilityLanguage integerValue];
        NSString *url = _jokeModel.pics[index][@"url"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    if(webView == _webViewContent){
        [_webViewContent sizeToFit];
        [self reAdjustWebViewAndOther];
    }
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if(webView == _webViewContent){
        NSLog(@"webview load url:%@", request.URL);
        if([request.URL.absoluteString isEqualToString:@"about:blank"]){
            return YES;
        }
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [Util logDealloc:self];
}
@end
