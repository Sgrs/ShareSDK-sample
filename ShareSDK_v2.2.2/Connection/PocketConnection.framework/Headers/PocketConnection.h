//
//  Created by ShareSDK.cn on 13-1-14.
//  官网地址:http://www.ShareSDK.cn
//  技术支持邮箱:support@sharesdk.cn
//  官方微信:ShareSDK   （如果发布新版本的话，我们将会第一时间通过微信将版本更新内容推送给您。如果使用过程中有任何问题，也可以通过微信与我们取得联系，我们将会在24小时内给予回复）
//  商务QQ:4006852216
//  Copyright (c) 2013年 ShareSDK.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDKCoreService/ShareSDKCoreService.h>
#import "ISSPocketApp.h"
#import "SSPocketCredential.h"

@interface PocketConnection : NSObject

/**
 *	@brief	注册应用,同一个AppKey只需要注册一次。
 *
 *  @param  account 授权帐号，使用ShareSDK注册的应用Key换取。
 *	@param 	consumerKey 	消费者Key
 *	@param 	redirectUri 	回调地址
 *
 *	@return	应用对象,返回nil则表示应用注册失败。
 */
+ (id<ISSPocketApp>)registerApp:(id<ISSCAccount>)account
                    consumerKey:(NSString *)consumerKey
                    redirectUri:(NSString *)redirectUri;

/**
 *	@brief	注销应用
 *
 *	@param 	app 	应用对象
 *
 *	@return	YES表示注销成功，NO表示注销失败
 */
+ (BOOL)unregisterApp:(id<ISSPocketApp>)app;


/**
 *	@brief	取的已注册新浪应用
 *
 *	@param 	appKey 	消费者Key
 *
 *	@return	应用对象，返回nil则表示应用尚未注册
 */
+ (id<ISSPocketApp>)getApp:(NSString *)consumerKey;

/**
 *	@brief	创建授权凭证
 *
 *	@param 	sourceData 	源数据
 *
 *	@return	授权凭证
 */
+ (SSPocketCredential *)credentialWithData:(NSDictionary *)sourceData;

/**
 *	@brief	创建授权凭证
 *
 *	@param 	credentialData 	授权数据
 *
 *	@return	授权凭证
 */
+ (SSPocketCredential *)credentialWithCredentialData:(NSDictionary *)credentialData;

/**
 *	@brief	根据新浪微博错误码返回错误描述
 *
 *	@param 	code 	错误码
 *
 *	@return	错误描述
 */
+ (NSString *)getErrorDescriptionWithCode:(NSInteger)code;

@end
