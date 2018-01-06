//
//  XHMessageTableViewCell.m
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMessageTableViewCell.h"
#import "WDConst.h"
#import "SDWebImageDownloader.h"

static const CGFloat kXHLabelPadding = 5.0f;
static const CGFloat kXHTimeStampLabelHeight = 20.0f;

static const CGFloat kXHAvatarPaddingX = 8.0;
static const CGFloat kXHAvatarPaddingY = 7;

static const CGFloat kXHUserNameLabelHeight = 20;

@interface XHMessageTableViewCell ()<XHMessageBubbleDelegate> {
    
}

@property (nonatomic, weak, readwrite) XHMessageBubbleView *messageBubbleView;

@property (nonatomic, weak, readwrite) UIButton *avatarButton;

@property (nonatomic, weak, readwrite) UILabel *userNameLabel;

//@property (nonatomic, weak, readwrite) LKBadgeView *timestampLabel;
@property (nonatomic, weak, readwrite) UILabel *timestampLabel;

/**
 *  是否显示时间轴Label
 */
@property (nonatomic, assign) BOOL displayTimestamp;

/**
 *  1、是否显示Time Line的label
 *
 *  @param message 需要配置的目标消息Model
 */
- (void)configureTimestamp:(BOOL)displayTimestamp atMessage:(id <XHMessageModel>)message;

/**
 *  2、配置头像
 *
 *  @param message 需要配置的目标消息Model
 */
- (void)configAvatarWithMessage:(id <XHMessageModel>)message;

/**
 *  3、配置需要显示什么消息内容，比如语音、文字、视频、图片
 *
 *  @param message 需要配置的目标消息Model
 */
- (void)configureMessageBubbleViewWithMessage:(id <XHMessageModel>)message;

/**
 *  头像按钮，点击事件
 *
 *  @param sender 头像按钮对象
 */
- (void)avatarButtonClicked:(UIButton *)sender;

/**
 *  统一一个方法隐藏MenuController，多处需要调用
 */
- (void)setupNormalMenuController;

/**
 *  点击Cell的手势处理方法，用于隐藏MenuController的
 *
 *  @param tapGestureRecognizer 点击手势对象
 */
- (void)tapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer;

/**
 *  长按Cell的手势处理方法，用于显示MenuController的
 *
 *  @param longPressGestureRecognizer 长按手势对象
 */
- (void)longPressGestureRecognizerHandle:(UILongPressGestureRecognizer *)longPressGestureRecognizer;

/**
 *  单击手势处理方法，用于点击多媒体消息触发方法，比如点击语音需要播放的回调、点击图片需要查看大图的回调
 *
 *  @param tapGestureRecognizer 点击手势对象
 */
- (void)sigleTapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer;

/**
 *  双击手势处理方法，用于双击文本消息，进行放大文本的回调
 *
 *  @param tapGestureRecognizer 双击手势对象
 */
- (void)doubleTapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer;

@end

@implementation XHMessageTableViewCell

- (void)avatarButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectedAvatarOnMessage:atIndexPath:)]) {
        [self.delegate didSelectedAvatarOnMessage:self.messageBubbleView.message atIndexPath:self.indexPath];
    }
}

#pragma mark - Copying Method

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    return [super becomeFirstResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copyed:) || action == @selector(transpond:) || action == @selector(favorites:) || action == @selector(more:));
}

#pragma mark - Menu Actions

- (void)copyed:(id)sender {
    [[UIPasteboard generalPasteboard] setString:self.messageBubbleView.displayTextView.text];
    [self resignFirstResponder];
    DLog(@"Cell was copy");
}

- (void)transpond:(id)sender {
    DLog(@"Cell was transpond");
}

- (void)favorites:(id)sender {
    DLog(@"Cell was favorites");

    if ([self.messageBubbleView.message messageMediaType] == XHBubbleMessageMediaTypePhoto) {
    
        [self savePhoto];
    }
}

- (void)more:(id)sender {
    DLog(@"Cell was more");
}


- (void)savePhoto
{
    NSURL* url = [NSURL URLWithString:self.messageBubbleView.message.originPhotoUrl];
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }];
    
//    [SDImageCache sharedImageCache] 
//    UIImageView* imgView = [[UIImageView alloc] init];
//    [imgView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//    }];
    
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [UIHelper toast:@"保存失败"];
    } else {
        [UIHelper toast:@"保存成功"];
    }
}

#pragma mark - Setters

- (void)configureCellWithMessage:(id <XHMessageModel>)message
               displaysTimestamp:(BOOL)displayTimestamp {
    
    // 1、是否显示Time Line的label
    [self configureTimestamp:displayTimestamp atMessage:message];
    
    // 2、配置头像
    [self configAvatarWithMessage:message];
    
    // 3、配置用户名
    [self configUserNameWithMessage:message];
    
    // 4、配置需要显示什么消息内容，比如语音、文字、视频、图片
    [self configureMessageBubbleViewWithMessage:message];
}

- (void)configureTimestamp:(BOOL)displayTimestamp atMessage:(id <XHMessageModel>)message {
    self.displayTimestamp = displayTimestamp;
    self.timestampLabel.hidden = !self.displayTimestamp;
    if (displayTimestamp) {
        
        WdMessage *wdMsg = (WdMessage *)message;
        
        if (wdMsg.messageMediaType == XHBubbleMessageMediaTypeText) {
            
            NSString *tipStr = [NSString stringWithFormat:@"  %@  ", ((ImTextMessage *)(wdMsg.obj_id)).MsgTip];
            
            self.timestampLabel.text = tipStr;
        }
        
        
//        NSString *dateText = nil;
//        NSString *timeText = nil;
//        
//        NSDate *today = [NSDate date];
//        NSDateComponents *components = [[NSDateComponents alloc] init];
//        [components setDay:-1];
//        NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:today options:0];
//        
//        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:message.timestamp];
//        NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:today];
//        NSDateComponents *yesterdayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:yesterday];
//        
//        if (dateComponents.year == todayComponents.year && dateComponents.month == todayComponents.month && dateComponents.day == todayComponents.day) {
//            dateText = NSLocalizedStringFromTable(@"Today", @"MessageDisplayKitString", @"今天");
//        } else if (dateComponents.year == yesterdayComponents.year && dateComponents.month == yesterdayComponents.month && dateComponents.day == yesterdayComponents.day) {
//            dateText = NSLocalizedStringFromTable(@"Yesterday", @"MessageDisplayKitString", @"昨天");
//        } else {
//            dateText = [NSDateFormatter localizedStringFromDate:message.timestamp dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
//        }
//        timeText = [NSDateFormatter localizedStringFromDate:message.timestamp dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
//        
//        self.timestampLabel.text = [NSString stringWithFormat:@"%@ %@",dateText,timeText];
    }
}

- (void)configAvatarWithMessage:(id <XHMessageModel>)message {
    UIImage *avatarPhoto = message.avatar;
    NSString *avatarURL = message.avatarUrl;
    
    if (avatarPhoto) {
        [self configAvatarWithPhoto:avatarPhoto];
        if (avatarURL) {
            [self configAvatarWithPhotoURLString:avatarURL];
        }
    } else if (avatarURL) {
        [self configAvatarWithPhotoURLString:avatarURL];
    } else {
        UIImage *avatarPhoto = [self getAvatarPlaceholderImage];
        [self configAvatarWithPhoto:avatarPhoto];
    }
    
    // 群主/BD加蓝圈
    WdMessage *msg = (WdMessage *)message;
    if (msg.bIsGroupManagerBD || msg.bIsGroupManagerOwner) {
        self.avatarButton.layer.borderWidth = 1;
        self.avatarButton.layer.borderColor = [UIColor blueColor].CGColor;
    } else {
        self.avatarButton.layer.borderWidth = 0;
    }
}

- (UIImage *)getAvatarPlaceholderImage {
    NSString *avatarPalceholderImageName = [[XHConfigurationHelper appearance].messageTableStyle objectForKey:kXHMessageTableAvatarPalceholderImageNameKey];
    if (!avatarPalceholderImageName) {
        avatarPalceholderImageName = @"avatar";
    }
    return [UIImage imageNamed:avatarPalceholderImageName];
}

- (void)configAvatarWithPhoto:(UIImage *)photo {
    [self.avatarButton setImage:photo forState:UIControlStateNormal];
}

- (void)configAvatarWithPhotoURLString:(NSString *)photoURLString {
    BOOL customLoadAvatarNetworkImage = [[[XHConfigurationHelper appearance].messageTableStyle objectForKey:kXHMessageTableCustomLoadAvatarNetworImageKey] boolValue];
    if (!customLoadAvatarNetworkImage) {
        XHMessageAvatarType avatarType = [[[XHConfigurationHelper appearance].messageTableStyle objectForKey:kXHMessageTableAvatarTypeKey] integerValue];
        self.avatarButton.messageAvatarType = avatarType;
        [self.avatarButton setImageWithURL:[NSURL URLWithString:photoURLString] placeholer:[self getAvatarPlaceholderImage]];
    }
}

- (void)configUserNameWithMessage:(id <XHMessageModel>)message {
    
    WdMessage *msg = (WdMessage *)message;
    
    if (!msg.bShowUserName) {
        self.userNameLabel.hidden = YES;
        return;
    }
    
    self.userNameLabel.hidden = NO;
    if (msg.bIsGroupManagerOwner) {
        
        NSMutableAttributedString *nameStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"★ 雇主-%@", [message sender]]];
        [nameStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, 1)];
        self.userNameLabel.attributedText = nameStr;
        
    } else if (msg.bIsGroupManagerBD) {
        
        NSMutableAttributedString *nameStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"★ 雇主-BD %@", [message sender]]];
        [nameStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, 1)];
        self.userNameLabel.attributedText = nameStr;
        
    } else {
        
        self.userNameLabel.text = [message sender];
    }
}

- (void)configureMessageBubbleViewWithMessage:(id <XHMessageModel>)message {
    XHBubbleMessageMediaType currentMediaType = message.messageMediaType;
    for (UIGestureRecognizer *gesTureRecognizer in self.messageBubbleView.bubbleImageView.gestureRecognizers) {
        [self.messageBubbleView.bubbleImageView removeGestureRecognizer:gesTureRecognizer];
    }
    for (UIGestureRecognizer *gesTureRecognizer in self.messageBubbleView.bubblePhotoImageView.gestureRecognizers) {
        [self.messageBubbleView.bubblePhotoImageView removeGestureRecognizer:gesTureRecognizer];
    }
    switch (currentMediaType) {
        case XHBubbleMessageMediaTypeImgText:       //add

        case XHBubbleMessageMediaTypePhoto:
        case XHBubbleMessageMediaTypeVideo:
        case XHBubbleMessageMediaTypeLocalPosition: {
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sigleTapGestureRecognizerHandle:)];
            [self.messageBubbleView.bubblePhotoImageView addGestureRecognizer:tapGestureRecognizer];
            break;
        }
            //====add
        case XHBubbleMessageMediaTypeJob:
        case XHBubbleMessageMediaTypeEnterprise:
        case XHBubbleMessageMediaTypeSystem:
            //=====add
        case XHBubbleMessageMediaTypeText:
        case XHBubbleMessageMediaTypeVoice:
        case XHBubbleMessageMediaTypeEmotion: {
            UITapGestureRecognizer *tapGestureRecognizer;
            if (currentMediaType == XHBubbleMessageMediaTypeText) {
                tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureRecognizerHandle:)];
            } else {
                tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sigleTapGestureRecognizerHandle:)];
            }
            tapGestureRecognizer.numberOfTapsRequired = (currentMediaType == XHBubbleMessageMediaTypeText ? 2 : 1);
            [self.messageBubbleView.bubbleImageView addGestureRecognizer:tapGestureRecognizer];
            break;
        }
        default:
            break;
    }
    [self.messageBubbleView configureCellWithMessage:message];
}

#pragma mark - Gestures

- (void)setupNormalMenuController {
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    }
}

- (void)tapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self updateMenuControllerVisiable];
}

- (void)updateMenuControllerVisiable {
    [self setupNormalMenuController];
}

- (void)longPressGestureRecognizerHandle:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    if (longPressGestureRecognizer.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder])
        return;
    
    NSArray *popMenuTitles = [[XHConfigurationHelper appearance] popMenuTitles];
    NSMutableArray *menuItems = [[NSMutableArray alloc] init];
    for (int i = 0; i < popMenuTitles.count; i ++) {
        NSString *title = popMenuTitles[i];
        SEL action = nil;
        switch (i) {
            case 0: {
                if ([self.messageBubbleView.message messageMediaType] == XHBubbleMessageMediaTypeText) {
                    action = @selector(copyed:);
                }
                break;
            }
            case 1: {
                action = @selector(transpond:);
                break;
            }
            case 2: {
                action = @selector(favorites:);
                break;
            }
            case 3: {
                action = @selector(more:);
                break;
            }
            default:
                break;
        }
        if (action) {
            UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:title action:action];
            if (item) {
                [menuItems addObject:item];
            }
        }
    }
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:menuItems];
    
    CGRect targetRect = [self convertRect:[self.messageBubbleView bubbleFrame]
                                 fromView:self.messageBubbleView];
    
    [menu setTargetRect:CGRectInset(targetRect, 0.0f, 4.0f) inView:self];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillShowNotification:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:nil];
    [menu setMenuVisible:YES animated:YES];
}

- (void)sigleTapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self setupNormalMenuController];
        if ([self.delegate respondsToSelector:@selector(multiMediaMessageDidSelectedOnMessage:atIndexPath:onMessageTableViewCell:)]) {
            [self.delegate multiMediaMessageDidSelectedOnMessage:self.messageBubbleView.message atIndexPath:self.indexPath onMessageTableViewCell:self];
        }
    }
}

- (void)doubleTapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(didDoubleSelectedOnTextMessage:atIndexPath:)]) {
            [self.delegate didDoubleSelectedOnTextMessage:self.messageBubbleView.message atIndexPath:self.indexPath];
        }
    }
}

#pragma mark - Notifications

- (void)handleMenuWillHideNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
}

- (void)handleMenuWillShowNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillHideNotification:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
}

#pragma mark - Getters

- (XHBubbleMessageType)bubbleMessageType {
    return self.messageBubbleView.message.bubbleMessageType;
}

+ (CGFloat)calculateCellHeightWithMessage:(id <XHMessageModel>)message
                        displaysTimestamp:(BOOL)displayTimestamp {
    
    WdMessage *msg = (WdMessage *)message;
    
    // 第一，是否有时间戳的显示
    CGFloat timestampHeight = displayTimestamp ? (kXHTimeStampLabelHeight + kXHLabelPadding * 2) : 0;
    
    CGFloat userInfoNeedHeight = kXHAvatarPaddingY + kXHAvatarImageSize + kXHAvatarPaddingY + timestampHeight + 5;
    
    CGFloat bubbleMessageHeight = [XHMessageBubbleView calculateCellHeightWithMessage:message] + timestampHeight  + 5;
    
    return MAX(bubbleMessageHeight, userInfoNeedHeight) + (msg.bShowUserName ? kXHUserNameLabelHeight + 10 : 0) + (msg.isHiddenTime ? 0 : 35 );
}

#pragma mark - Life cycle

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.accessoryView = nil;
    
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizerHandle:)];
    [recognizer setMinimumPressDuration:0.4f];
    [self addGestureRecognizer:recognizer];
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerHandle:)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (instancetype)initWithMessage:(id <XHMessageModel>)message
              displaysTimestamp:(BOOL)displayTimestamp
                reuseIdentifier:(NSString *)cellIdentifier {
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    if (self) {

        // 如果初始化成功，那就根据Message类型进行初始化控件，比如配置头像，配置发送和接收的样式
        
        // 1、是否显示Time Line的label
        if (!_timestampLabel) {
//            UIColor *timestampLabelTextColor = [[XHConfigurationHelper appearance].messageTableStyle objectForKey:kXHMessageTableTimestampTextColorKey];
//            if (!timestampLabelTextColor) {
//                timestampLabelTextColor = [UIColor whiteColor];
//            }
//            UIColor *timestampBackgroundColor = [[XHConfigurationHelper appearance].messageTableStyle objectForKey:kXHMessageTableTimestampBackgroundColorKey];
//            if (!timestampBackgroundColor) {
//                timestampBackgroundColor = [UIColor colorWithWhite:0.734 alpha:1.000];
//            }
//            LKBadgeView *timestampLabel = [[LKBadgeView alloc] initWithFrame:CGRectMake(0, kXHLabelPadding, MDK_SCREEN_WIDTH, kXHTimeStampLabelHeight)];
//            timestampLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
//            timestampLabel.badgeColor = timestampBackgroundColor;
//            timestampLabel.textColor = timestampLabelTextColor;
//            timestampLabel.font = [UIFont systemFontOfSize:10.0f];
//            timestampLabel.center = CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) / 2.0, timestampLabel.center.y);
//            [self.contentView addSubview:timestampLabel];
//            [self.contentView bringSubviewToFront:timestampLabel];
//            _timestampLabel = timestampLabel;
            
            
            UILabel *timestampLabel = [[UILabel alloc] init];
            timestampLabel.backgroundColor = MKCOLOR_RGB(212, 212, 212);
            timestampLabel.textColor = [UIColor whiteColor];
            timestampLabel.font = [UIFont systemFontOfSize:13];
            [timestampLabel setCorner];
            [self.contentView addSubview:timestampLabel];
            _timestampLabel = timestampLabel;
            
            WEAKSELF
            [timestampLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(weakSelf.contentView);
                make.top.equalTo(weakSelf.contentView).offset(5);
                make.height.mas_equalTo(@(20));
            }];            
        }
        
        // 2、配置头像
        CGRect avatarButtonFrame;
        switch (message.bubbleMessageType) {
            case XHBubbleMessageTypeReceiving:
                avatarButtonFrame = CGRectMake(kXHAvatarPaddingX,
                                               kXHAvatarPaddingY + (self.displayTimestamp ? (kXHTimeStampLabelHeight + kXHLabelPadding * 2) : 0),
                                               kXHAvatarImageSize,
                                               kXHAvatarImageSize);
                break;
            case XHBubbleMessageTypeSending:
                avatarButtonFrame = CGRectMake(CGRectGetWidth(self.bounds) - kXHAvatarImageSize - kXHAvatarPaddingX,
                                               kXHAvatarPaddingY + (self.displayTimestamp ? (kXHTimeStampLabelHeight + kXHLabelPadding * 2) : 0),
                                               kXHAvatarImageSize,
                                               kXHAvatarImageSize);
                break;
            default:
                break;
        }
        
        UIButton *avatarButton = [[UIButton alloc] initWithFrame:avatarButtonFrame];
        [avatarButton setImage:[self getAvatarPlaceholderImage] forState:UIControlStateNormal];
        [avatarButton addTarget:self action:@selector(avatarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [avatarButton setToCircle];
        avatarButton.layer.borderColor = [UIColor grayColor].CGColor;
        avatarButton.layer.borderWidth = 0.5;
        [self.contentView addSubview:avatarButton];
        self.avatarButton = avatarButton;
        
        if (!_userNameLabel) {
            // 3、配置用户名
            UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.avatarButton.bounds) + 150, kXHUserNameLabelHeight)];
            userNameLabel.textAlignment = NSTextAlignmentLeft;
            userNameLabel.backgroundColor = [UIColor clearColor];
            userNameLabel.font = [UIFont systemFontOfSize:13];
//            userNameLabel.textColor = [UIColor colorWithRed:0.140 green:0.635 blue:0.969 alpha:1.000];
            userNameLabel.textColor = MKCOLOR_RGB(91, 91, 91);
            [self.contentView addSubview:userNameLabel];
            self.userNameLabel = userNameLabel;
        }
        
        // 4、配置需要显示什么消息内容，比如语音、文字、视频、图片
        if (!_messageBubbleView) {
            // bubble container
            XHMessageBubbleView *messageBubbleView = [[XHMessageBubbleView alloc] initWithFrame:CGRectZero message:message];
            messageBubbleView.delegate = self;
            [self.contentView addSubview:messageBubbleView];
            [self.contentView sendSubviewToBack:messageBubbleView];
            self.messageBubbleView = messageBubbleView;
        }
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [self setup];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    WdMessage *msg = (WdMessage *)self.messageBubbleView.message;
    
    // 布局头像
    CGFloat layoutOriginY = kXHAvatarPaddingY + (self.displayTimestamp ? kXHTimeStampLabelHeight : 0) + (msg.bShowUserName ? self.userNameLabel.height + kXHAvatarPaddingY : 0);
    CGRect avatarButtonFrame = self.avatarButton.frame;
    avatarButtonFrame.origin.y = layoutOriginY;
    avatarButtonFrame.origin.x = ([self bubbleMessageType] == XHBubbleMessageTypeReceiving) ? kXHAvatarPaddingX : ((CGRectGetWidth(self.bounds) - kXHAvatarPaddingX - kXHAvatarImageSize));
    self.avatarButton.frame = avatarButtonFrame;
    
    // 布局用户名

    
    // 布局消息内容的View
    CGFloat bubbleX = 0.0f;
    CGFloat offsetX = 0.0f;
    if ([self bubbleMessageType] == XHBubbleMessageTypeReceiving) {
        bubbleX = kXHAvatarImageSize + kXHAvatarPaddingX * 2;
    } else {
        offsetX = kXHAvatarImageSize + kXHAvatarPaddingX * 2;
    }
    CGFloat timeStampLabelNeedHeight = (self.displayTimestamp ? (kXHTimeStampLabelHeight + kXHLabelPadding) : 0);
    
    CGRect bubbleMessageViewFrame = CGRectMake(bubbleX,
                              self.avatarButton.y - 5,
                              CGRectGetWidth(self.contentView.bounds) - bubbleX - offsetX,
                              CGRectGetHeight(self.contentView.bounds) - timeStampLabelNeedHeight);
    self.messageBubbleView.frame = bubbleMessageViewFrame;
    if (!msg.isHiddenTime) {
        self.avatarButton.y += 35;
    }
    
    if (msg.bShowUserName) {
        self.userNameLabel.x = self.avatarButton.x + 8;
        self.userNameLabel.y = self.avatarButton.y - 20;
        
        //        self.userNameLabel.center = CGPointMake(CGRectGetMidX(avatarButtonFrame), CGRectGetMaxY(avatarButtonFrame) + CGRectGetMidY(self.userNameLabel.bounds));
    }
    
//    self.avatarButton.y = bubbleMessageViewFrame.origin.y + 35;
}

- (void)dealloc {
    _avatarButton = nil;
    _timestampLabel = nil;
    _messageBubbleView = nil;
    _indexPath = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - TableViewCell

- (void)prepareForReuse {
    // 这里做清除工作
    [super prepareForReuse];
    self.messageBubbleView.displayTextView.text = nil;
    self.messageBubbleView.displayTextView.attributedText = nil;
    self.messageBubbleView.bubbleImageView.image = nil;
    self.messageBubbleView.emotionImageView.animatedImage = nil;
    self.messageBubbleView.animationVoiceImageView.image = nil;
    self.messageBubbleView.voiceDurationLabel.text = nil;
    self.messageBubbleView.bubblePhotoImageView.messagePhoto = nil;
    self.messageBubbleView.geolocationsLabel.text = nil;
    
    self.userNameLabel.text = nil;
    [self.avatarButton setImage:nil forState:UIControlStateNormal];
    self.timestampLabel.text = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - XHMessageBubbleDelegate
- (void)lookupDetailBtn:(UIButton *)btn click:(id<XHMessageModel>)message
{
    if ([self.delegate respondsToSelector:@selector(xhMessageTableViewCell:didClickLookupDetailBtn:indexPath:message:)]) {
        [self.delegate xhMessageTableViewCell:self didClickLookupDetailBtn:btn indexPath:self.indexPath message:message];
    }    
}

- (void)reportBtn:(UIButton *)btn click:(id<XHMessageModel>)message
{
    if ([self.delegate respondsToSelector:@selector(xhMessageTableViewCell:didClickReportBtn:indexPath:message:)]) {
        [self.delegate xhMessageTableViewCell:self didClickReportBtn:btn indexPath:self.indexPath message:message];
    }
}

@end
