//
//  defines.h
//  Joke
//
//  Created by cao on 13-8-8.
//  Copyright (c) 2013年 iphone. All rights reserved.
//

#ifndef Joke_defines_h
#define Joke_defines_h



/*
 全局内容字体:#000000
 软件背景颜色：#e6ebf0
 顶部导航字体颜色：#ffffff
 【输入框】内提示字体颜色：#999999  输入的内容字体颜色：#000000
 【灰色】#999999  路过，喜欢，翻页不可点时的字体颜色，及其他
 【提示红色色值】#ff0000
 【购买按钮】字体颜色：#a14400
 */ 
//字体  JD=Joke define
// http://www.touch-code-magazine.com/web-color-to-uicolor-convertor/
#define JD_FONT_COLOR_000 [UIColor colorWithRed:0 green:0 blue:0 alpha:1] /*#000000*/
#define JD_FONT_COLOR_e6ebf0 [UIColor colorWithRed:0.902 green:0.922 blue:0.941 alpha:1] /*#e6ebf0*/
#define JD_FONT_COLOR_fff [UIColor colorWithRed:1 green:1 blue:1 alpha:1] /*#ffffff*/
#define JD_FONT_COLOR_999 [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] /*#999999*/
#define JD_FONT_COLOR_ff0000 [UIColor colorWithRed:1 green:0 blue:0 alpha:1] /*#ff0000*/
#define JD_FONT_COLOR_a14400 [UIColor colorWithRed:0.631 green:0.267 blue:0 alpha:1] /*#a14400*/

/**
 *
 *  notification
 */

#define JD_NOTIFICATION_RELOADUSER @"jd_notification_reloaduer"
/**
 * 文案
 */
#define JD_WORD_NOVIP @"注册成为VIP才能使用收藏"
#define JD_WORD_BADNETWORK @"您的网络好像有问题~"
#define JD_WORD_BADINPUT @"输入有误~"

#define JD_WORD_SUPPORT_MESSAGE @"喜欢就支持一下我们吧~"
#define JD_WORD_SUPPORT_REFUSE @"残忍地拒绝"
#define JD_WORD_SUPPORT_GO @"支持"

/**
 *
 */
#define JD_CONFIG_APPLE_ID @"697940572"
//#define JD_CONFIG_APPLE_ID @"533055152"   //明星衣橱




#endif
