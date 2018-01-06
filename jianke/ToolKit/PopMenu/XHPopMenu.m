//
//  XHPopMenu.m
//  MessageDisplayExample
//
//  Created by dw_iOS on 14-6-7.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHPopMenu.h"
#import "UIView+MKExtension.h"
#import "XHPopMenuItemView.h"
#import "UIHelper.h"
#import "XSJConst.h"

@interface XHPopMenu () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *menuContainerView;

@property (nonatomic, strong) UITableView *menuTableView;
@property (nonatomic, strong) NSMutableArray *menus;

@property (nonatomic, weak) UIView *currentSuperView;
@property (nonatomic, assign) CGPoint targetPoint;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign) CGFloat menuWidth;

@property (nonatomic, assign, getter=isCustomCell) BOOL customCell;

@property (nonatomic, assign, getter=hasAddContainerView) BOOL addContainerView;

@property (nonatomic, assign) NSInteger showCount;

@end

@implementation XHPopMenu

- (void)showMenuAtPoint:(CGPoint)point {
    
    UIWindow *topWindow = [MKUIHelper getCurrentRootViewController].view.window;
    [self showMenuOnView:topWindow atPoint:point];
}

- (void)showMenuOnView:(UIView *)view atPoint:(CGPoint)point {
    self.currentSuperView = view;
    self.targetPoint = point;
    [self showMenu];
}


- (void)showMenuAtPoint:(CGPoint)point withMenuWidth:(CGFloat)width customCell:(BOOL)isCustomCell showCount:(NSInteger)count;{
    self.menuWidth = width;
    self.customCell = isCustomCell;
    self.showCount = count;
    UIWindow *topWindow = [MKUIHelper getCurrentRootViewController].view.window;
    [self showMenuOnView:topWindow atPoint:point];
}

#pragma mark - animation

- (void)showMenu {
    
    if (!self.hasAddContainerView) {
        [self addSubview:self.menuContainerView];
        self.addContainerView = YES;
    }
    
    if (![self.currentSuperView.subviews containsObject:self]) {
        
        CGRect frame = _menuContainerView.frame;
        frame.origin.y = self.targetPoint.y;
        frame.origin.x = self.targetPoint.x;
        _menuContainerView.frame = frame;
        
        self.alpha = 0.0;
        [self.currentSuperView addSubview:self];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [self dissMissPopMenuAnimatedOnMenuSelected:NO];
    }
}

- (void)dissMissPopMenuAnimatedOnMenuSelected:(BOOL)selected {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (selected) {
            if (self.popMenuDidDismissCompled) {
                self.popMenuDidDismissCompled(self.indexPath.row, self.menus[self.indexPath.row]);
            }
        }
        [super removeFromSuperview];
    }];
}

#pragma mark - Propertys

- (UIImageView *)menuContainerView {
    if (!_menuContainerView) {

        _menuContainerView = [[UIImageView alloc] init];
//        _menuContainerView.image = [UIImage imageNamed:@"bg_card_0"];
        _menuContainerView.userInteractionEnabled = YES;
        
        if (self.menuWidth) {
            if (self.showCount) {
                NSInteger count = self.menus.count > self.showCount ? self.showCount : self.menus.count;
                _menuContainerView.frame = CGRectMake(CGRectGetWidth(self.bounds) - self.menuWidth - 6, 1, self.menuWidth, count * (kXHMenuItemViewHeight + kXHSeparatorLineImageViewHeight) + 2 * kXHMenuTableViewSapcing);
            } else {
                _menuContainerView.frame = CGRectMake(CGRectGetWidth(self.bounds) - self.menuWidth - 6, 1, self.menuWidth, self.menus.count * (kXHMenuItemViewHeight + kXHSeparatorLineImageViewHeight) + 2 * kXHMenuTableViewSapcing);
            }
        } else {
            _menuContainerView.frame = CGRectMake(CGRectGetWidth(self.bounds) - kXHMenuTableViewWidth - 6, 1, kXHMenuTableViewWidth, self.menus.count * (kXHMenuItemViewHeight + kXHSeparatorLineImageViewHeight) + 2 * kXHMenuTableViewSapcing);
        }
        
        [_menuContainerView addSubview:self.menuTableView];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_menuContainerView.bounds), CGRectGetWidth(_menuContainerView.bounds), 2)];
        lineView.backgroundColor = [UIColor XSJColor_grayLine];
        [_menuContainerView addSubview:lineView];
    }
    
    return _menuContainerView;
}

- (UITableView *)menuTableView {
    if (!_menuTableView) {
        
        _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_menuContainerView.bounds), CGRectGetHeight(_menuContainerView.bounds)) style:UITableViewStylePlain];
        _menuTableView.backgroundColor = [UIColor XSJColor_grayTinge];
        _menuTableView.separatorColor = [UIColor clearColor];
        _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _menuTableView.delegate = self;
        _menuTableView.dataSource = self;
        _menuTableView.rowHeight = kXHMenuItemViewHeight;
        
        if (!self.showCount) {
            _menuTableView.scrollEnabled = NO;
        }
    }
    return _menuTableView;
}

#pragma mark - Life Cycle

- (void)setup {
    self.frame = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [UIColor clearColor];
}

- (id)initWithMenus:(NSArray *)menus {
    self = [super init];
    if (self) {
        self.menus = [[NSMutableArray alloc] initWithArray:menus];
        [self setup];
    }
    return self;
}

- (instancetype)initWithObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION {
    self = [super init];
    if (self) {
        NSMutableArray *menuItems = [[NSMutableArray alloc] init];
        XHPopMenuItem *eachItem;
        va_list argumentList;
        if (firstObj) {
            [menuItems addObject:firstObj];
            va_start(argumentList, firstObj);
            while((eachItem = va_arg(argumentList, XHPopMenuItem *))) {
                [menuItems addObject:eachItem];
            }
            va_end(argumentList);
        }
        self.menus = menuItems;
        [self setup];
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint localPoint = [touch locationInView:self];
    if (CGRectContainsPoint(self.menuContainerView.frame, localPoint)) {
        [self hitTest:localPoint withEvent:event];
    } else {
        [self dissMissPopMenuAnimatedOnMenuSelected:NO];
    }
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menus.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer = @"cellIdentifer";
    
    
    XHPopMenuItemView *popMenuItemView = (XHPopMenuItemView *)[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!popMenuItemView) {
        popMenuItemView = [[XHPopMenuItemView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    
    if (indexPath.row < self.menus.count) {
        
        popMenuItemView.width = self.menuWidth;
        [popMenuItemView setupPopMenuItem:self.menus[indexPath.row] atIndexPath:indexPath isBottom:(indexPath.row == self.menus.count - 1) isCustom:self.isCustomCell];
    }
    
    popMenuItemView.textLabel.font = [UIFont systemFontOfSize:16];
    popMenuItemView.textLabel.center = popMenuItemView.contentView.center;
    
    return popMenuItemView;
}


#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.indexPath = indexPath;
    [self dissMissPopMenuAnimatedOnMenuSelected:YES];
    if (self.popMenuDidSlectedCompled) {
        self.popMenuDidSlectedCompled(indexPath.row, self.menus[indexPath.row]);
    }
}

#pragma mark - 其他

- (void)makeTabelviewReload{
    [_menuTableView reloadData];
}

@end
