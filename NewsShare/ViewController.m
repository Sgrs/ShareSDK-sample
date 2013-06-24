//
//  ViewController.m
//  NewsShare
//
//  Created by 赵 峰 on 13-6-19.
//  Copyright (c) 2013年 赵 峰. All rights reserved.
//

#import "ViewController.h"
//#import "AGAppDelegate.h"
#import <AGCommon/UIImage+Common.h>

#define ACTION_SHEET_GET_USER_INFO 200
#define ACTION_SHEET_FOLLOW_USER 201
#define ACTION_SHEET_GET_OTHER_USER_INFO 202
#define ACTION_SHEET_GET_ACCESS_TOKEN 203
#define ACTION_SHEET_PRINT_COPY 306

#define FACEBOOK_SWITCH_TAG 1010

@interface ViewController ()

@end

@implementation ViewController

@synthesize facebookOAuthSwitch, facebookImageView;

- (id)init
{
    self = [super init];
    if (self)
    {
        // Custom initialization
//        _appDelegate = (AGAppDelegate *)[UIApplication sharedApplication].delegate;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if ([ShareSDK hasAuthorizedWithType:ShareTypeFacebook])
    {
        [facebookOAuthSwitch setOn:YES];
    }
    else
    {
        [facebookOAuthSwitch setOn:NO];
    }
    
    [facebookOAuthSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    facebookOAuthSwitch.tag = FACEBOOK_SWITCH_TAG;
    
    UIImage *fbImg = [UIImage imageNamed:[NSString stringWithFormat:@"Icon/sns_icon_10.png"] bundleName:@"Resource"];
    self.facebookImageView.image = fbImg;
    
}

- (void)switchAction:(UISwitch *)sender
{
//    UISwitch *switcher = (UISwitch *)sender;
    
    switch (sender.tag) {
        case FACEBOOK_SWITCH_TAG:
            if ([ShareSDK hasAuthorizedWithType:ShareTypeFacebook])
            {
                 [ShareSDK cancelAuthWithType:ShareTypeFacebook];
            }
            else
            {
                id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                                     allowCallback:YES
                                                                     authViewStyle:SSAuthViewStyleFullScreenPopup
                                                                      viewDelegate:nil
                                                           authManagerViewDelegate:nil];
                [authOptions setPowerByHidden:YES];
                
                [ShareSDK getUserInfoWithType:ShareTypeFacebook
                                  authOptions:authOptions
                                       result:^(BOOL result, id<ISSUserInfo> userInfo, id<ICMErrorInfo> error) {
                                           if (result)
                                           {
//                                               [item setObject:[userInfo nickname] forKey:@"username"];
//                                               [_shareTypeArray writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()] atomically:YES];
                                           }
                                           else
                                           {
                                               [sender setOn:NO];
                                           }
                                           NSLog(@"%d:%@",[error errorCode], [error errorDescription]);
//                                           [_tableView reloadData];
                                       }];
            }
            break;
            
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ButtonHandler

-(IBAction)clickShareButton:(id)sender
{
    
    //the image to share
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"res1" ofType:@"jpg"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"你要分享的内容"
                                       defaultContent:@""
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"分享Demo"
                                                  url:@"http://www.sharesdk.cn"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //定制邮件信息
    [publishContent addMailUnitWithSubject:@"测试 Mail分享"
                                   content:INHERIT_VALUE
                                    isHTML:[NSNumber numberWithBool:YES]
                               attachments:INHERIT_VALUE
                                        to:nil
                                        cc:nil
                                       bcc:nil];
    
    //定制短信信息
    [publishContent addSMSUnitWithContent:@"测试 SMS分享"];
    
    //自定义菜单项
    id<ISSShareActionSheetItem> item1 = [ShareSDK shareActionSheetItemWithTitle:@"自定义项1"
                                                                           icon:[UIImage imageNamed:@"qqicon.png"]
                                                                   clickHandler:^{
                                                                       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                                                           message:@"自定义项1被点击了!"
                                                                                                                          delegate:nil
                                                                                                                 cancelButtonTitle:@"确定"
                                                                                                                 otherButtonTitles:nil];
                                                                       [alertView show];
                                                                       [alertView release];
                                                                   }];
    
    NSArray *shareList = [ShareSDK customShareListWithType:
                          SHARE_TYPE_NUMBER(ShareTypeFacebook),
                          SHARE_TYPE_NUMBER(ShareTypeTwitter),
                          item1,
                          SHARE_TYPE_NUMBER(ShareTypeMail),
                          SHARE_TYPE_NUMBER(ShareTypeSMS),
                          nil];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    [authOptions setPowerByHidden:YES];
    
    
    id<ISSShareOptions> shareOptions = [ShareSDK simpleShareOptionsWithTitle:@"内容分享" shareViewDelegate:nil];
    //弹出分享菜单
    [ShareSDK showShareActionSheet:nil
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:shareOptions
                            result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess)
                                {
//                                    NSLog(@"分享成功");
                                    NSLog(@"寝cお　jかjldふぁ");
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                                
                                if ([ShareSDK hasAuthorizedWithType:ShareTypeFacebook])
                                {
                                    [self.facebookOAuthSwitch setOn:YES];
                                }
                                else
                                {
                                    [self.facebookOAuthSwitch setOn:NO];
                                }
                            }];
    
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag)
    {
        case ACTION_SHEET_GET_USER_INFO:
        {
            ShareType type = 0;
            switch (buttonIndex)
            {
                case 0:
                    type = ShareTypeFacebook;
                    break;
                case 1:
                    type = ShareTypeTwitter;
                    break;

                default:
                    break;
            }
            
            if (type != 0)
            {
                [self showUserInfoWithType:type];
            }
            
            break;
        }
//        case ACTION_SHEET_PRINT_COPY:
//        {
//            switch (buttonIndex)
//            {
//                case 0:
//                    //打印
//                    [self airPrintShareContent];
//                    break;
//                case 1:
//                    //拷贝
//                    [self copyShareContent];
//                    break;
//                default:
//                    break;
//            }
//            break;
//        }
        case ACTION_SHEET_GET_ACCESS_TOKEN:
        {
            ShareType type = 0;
            switch (buttonIndex)
            {
                case 0:
                    type = ShareTypeFacebook;
                    break;
                case 1:
                    type = ShareTypeTwitter;
                    break;

                default:
                    break;
            }
            
            if (type != 0)
            {
                id<ISSCredential> credential = [ShareSDK getCredentialWithType:type];
                
                if ([credential conformsToProtocol:@protocol(ISSOAuth2Credential)])
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                        message:[NSString stringWithFormat:
                                                                                 @"AccessToken = %@",
                                                                                 [(id<ISSOAuth2Credential>)credential accessToken]]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"知道了"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    [alertView release];
                }
                else if ([credential conformsToProtocol:@protocol(ISSOAuthCredential)])
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                        message:[NSString stringWithFormat:
                                                                                 @"OAuthToken = %@\nOAuthSecret = %@",
                                                                                 [(id<ISSOAuthCredential>)credential oauthToken],
                                                                                 [(id<ISSOAuthCredential>)credential oauthTokenSecret]]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"知道了"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    [alertView release];
                }
                else
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                        message:@"此平台尚未授权!"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"知道了"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    [alertView release];
                }
            }
            break;
        }
        default:
            break;
    }
}


- (void)dealloc {
    [self.facebookOAuthSwitch release];
    [self.facebookImageView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setFacebookOAuthSwitch:nil];
    [self setFacebookImageView:nil];
    [super viewDidUnload];
}
@end
