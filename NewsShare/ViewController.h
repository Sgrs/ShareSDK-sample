//
//  ViewController.h
//  NewsShare
//
//  Created by 赵 峰 on 13-6-19.
//  Copyright (c) 2013年 赵 峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>

@class AGAppDelegate;

@interface ViewController : UIViewController<UIActionSheetDelegate>
{
    
@private
    AGAppDelegate *_appDelegate;
}
@property (retain, nonatomic) IBOutlet UISwitch *facebookOAuthSwitch;
@property (retain, nonatomic) IBOutlet UIImageView *facebookImageView;


-(IBAction)clickShareButton:(id)sender;

@end
