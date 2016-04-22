//
//  URLHeaderDefine.h
//  MiaoComic
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 lanou. All rights reserved.
//

#ifndef URLHeaderDefine_h
#define URLHeaderDefine_h


// 首页
#define HOME_NEW @"http://api.kuaikanmanhua.com/v1/daily/comic_lists/"// 首页更新
#define HOME_MORE @"http://api.kuaikanmanhua.com/v1/daily/comic_lists/0"// 加载更多
#define HOME_ATTENTION @"http://api.kuaikanmanhua.com/v1/fav/timeline"// 首页关注

//发现
#define Discovery_CLASSIFY          @"http://api.kuaikanmanhua.com/v1/tag/suggestion"  //分类
#define Discover_CLASSIFYLIST     @"http://api.kuaikanmanhua.com/v1/topics?limit=%@&offset=%@&tag=%@"  //分类列表
#define Discover_fav                   @"http://api.kuaikanmanhua.com/v1/topics/%@/fav"   //关注
#define Discover_Hot_banner         @"http://api.kuaikanmanhua.com/v1/banners"   //热门的轮播
#define Discover_Hot_topic_lists    @"http://api.kuaikanmanhua.com/v1/topic_lists/mixed/new"    //热门列表
















/**发现*/
#define Discovery_CLASSIFY          @"http://api.kuaikanmanhua.com/v1/tag/suggestion"




/**登录*/
#define LOGINURL @"http://api.kuaikanmanhua.com/v1/phone/signin"
/**获取验证码*/
#define GETCODEURL @"http://api.kuaikanmanhua.com/v1/phone/send_code"
/**提交验证码*/
#define SENDURL @"http://api.kuaikanmanhua.com/v1/phone/verify"
/**我的关注*/
#define ATTENTIONURL @"http://api.kuaikanmanhua.com/v1/fav/topics?offset=%@&limit=%@"

#endif /* URLHeaderDefine_h */
