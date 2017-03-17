//
//  ZEEnumConstant.h
//  NewCentury
//
//  Created by Stenson on 16/1/20.
//  Copyright © 2016年 Stenson. All rights reserved.
//

#ifndef ZEEnumConstant_h
#define ZEEnumConstant_h

typedef enum : NSUInteger {
    CHANGE_PERSONALMSG_NICKNAME,
    CHANGE_PERSONALMSG_ADVICE,
} CHANGE_PERSONALMSG_TYPE;


typedef enum:NSInteger{
    QUESTION_LIST_NEW,          // 推荐列表
    QUESTION_LIST_TYPE,         // 问题分类
    QUESTION_LIST_MY_QUESTION,  // 我的问题列表
    QUESTION_LIST_MY_ANSWER,    // 我的回答
    QUESTION_LIST_EXPERT,       // 专家解答
    QUESTION_LIST_CASE,         // 经典案例列表
    QUESTION_LIST_RECOMMAND,    // 推荐列表
}QUESTION_LIST;

typedef enum : NSUInteger {
    ENTER_GROUP_TYPE_DEFAULT,
    ENTER_GROUP_TYPE_SETTING,
    ENTER_GROUP_TYPE_TABBAR,
    ENTER_GROUP_TYPE_CHANGE,
} ENTER_GROUP_TYPE;

typedef enum : NSUInteger {
    ENTER_CASE_TYPE_DEFAULT,
    ENTER_CASE_TYPE_SETTING,
} ENTER_CASE_TYPE;

typedef enum : NSUInteger {
    ENTER_TEAM_CREATE, // 创建团队
    ENTER_TEAM_DETAIL, // 团队详情
} ENTER_TEAM;   // 进入团队详情页面

typedef enum : NSUInteger {
    ENTER_TEAM_SEARCH_COMMON, // 所有问题展示
    ENTER_TEAM_SEARCH_ONLYYOU, // 我来挑战问题展示
    ENTER_TEAM_SEARCH_MYQUESTION, // 我的问题列表展示
} ENTER_TEAM_SEARCH;   // 进入团队问题搜索页面


typedef enum : NSUInteger {
    ENTER_SETTING_TYPE_PERSONAL,
    ENTER_SETTING_TYPE_SETTING,
} ENTER_SETTING_TYPE;

typedef enum : NSUInteger{
    HOME_CONTENT_RECOMMAND = 0,
    HOME_CONTENT_NEWEST,
    HOME_CONTENT_BOUNS
}HOME_CONTENT;


#endif /* ZEEnumConstant_h */
