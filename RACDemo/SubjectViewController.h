//
//  SubjectViewController.h
//  RACDemo
//
//  Created by choice on 2020/4/14.
//  Copyright © 2020 choice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>
NS_ASSUME_NONNULL_BEGIN

@interface SubjectViewController : UIViewController
@property (nonatomic, strong) RACSubject *subject;
@end

NS_ASSUME_NONNULL_END
