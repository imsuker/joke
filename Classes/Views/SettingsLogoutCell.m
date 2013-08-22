//
//  SettingsLogoutCell.m
//  Joke
//
//  Created by cao on 13-8-21.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#import "SettingsLogoutCell.h"

@implementation SettingsLogoutCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.textAlignment = UITextAlignmentCenter;
        self.textLabel.textColor = JD_FONT_COLOR_fff;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{

    // Configure the view for the selected state
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    if(highlighted == YES){
        UIImage *bgImage1 = [Util adjustImage:[UIImage imageNamed:@"logout-onpress"]];
        UIImageView *bgView1 = [[UIImageView alloc] initWithFrame:self.backgroundView.bounds];
        self.backgroundView = bgView1;
        bgView1.image = bgImage1;
        self.backgroundColor = [UIColor clearColor];
    }else{
        [super setHighlighted:highlighted animated:animated];
        UIImage *bgImage = [Util adjustImage:[UIImage imageNamed:@"logout"]];
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.backgroundView.bounds];
        self.backgroundView = bgView;
        bgView.image = bgImage;
    }
}
@end
