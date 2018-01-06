//
//  BusMap_VC.m
//  jianke
//
//  Created by xiaomk on 15/11/7.
//  Copyright © 2015年 xianshijian. All rights reserved.
//

#import "BusMap_VC.h"
#import "MANaviRoute.h"
#import "CommonUtility.h"
#import "BusCourseView.h"
#import "BusCourseDetailViewController.h"

const NSString *RoutePlanningViewControllerStartTitle = @"起点";
const NSString *RoutePlanningViewControllerDestinationTitle = @"终点";
const NSInteger RoutePlanningPaddingEdge = 20;

@interface BusMap_VC ()<MAMapViewDelegate, AMapSearchDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnMyLocal;
@property (weak, nonatomic) IBOutlet UILabel *labAddress;
@property (weak, nonatomic) IBOutlet UIView *viewMapBg;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationTopConstraint; /*!< 8/52 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dstLocationTopConstraint;

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;


@property (nonatomic, strong) UIAlertView *locationAlertView;

@property (nonatomic, assign) CGFloat userLongitude;
@property (nonatomic, assign) CGFloat userLatitude;

@property (nonatomic, assign) CGFloat workSpaceLongitude;
@property (nonatomic, assign) CGFloat workSpaceLatitude;


@property (nonatomic, strong) MANaviRoute * naviRoute; /*!< 用于显示当前路线方案. */
@property (nonatomic, strong) AMapRoute *route;
@property (nonatomic) NSInteger currentCourse; /*!< 当前路线方案索引值. */
@property (nonatomic) NSInteger totalCourse; /*!< 路线方案个数. */


@property (nonatomic, weak) BusCourseView *busCourseView;

@end

@implementation BusMap_VC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"公交线路";

    // 初始化 地图
    CGRect bgFrame = self.viewMapBg.frame;
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, bgFrame.size.width, bgFrame.size.height)];
    self.mapView.delegate = self;
    [self.viewMapBg addSubview:self.mapView];
    
    self.mapView.showsUserLocation = YES;
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollowWithHeading];
    self.mapView.showsScale = NO;  //隐藏 比例尺
    
    // 初始化检索对象
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    self.labAddress.text = self.workPlace;
    
    // 对工作地点进行地理编码
    AMapGeocodeSearchRequest *geoRequest = [[AMapGeocodeSearchRequest alloc] init];
    geoRequest.address = self.workPlace;
    if (self.city) {
        geoRequest.city = self.city;
    }
    [self.search AMapGeocodeSearch:geoRequest];
}

/** 定位回调 */
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (updatingLocation) {
        ELog("latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        
        self.mapView.showsUserLocation = NO;
        
        self.userLatitude = userLocation.coordinate.latitude;
        self.userLongitude = userLocation.coordinate.longitude;
        
        AMapReGeocodeSearchRequest* regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
        regeoRequest.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
        regeoRequest.radius = 100;
        regeoRequest.requireExtension = YES;
        
        // 发起逆地理编码
        [self.search AMapReGoecodeSearch:regeoRequest];
        [self searchBus];
    }
}


/** 反地理编码回调 */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil) {
        [self.btnMyLocal setTitle:response.regeocode.formattedAddress forState:UIControlStateNormal];
    }
}

/** 地理编码回调 */
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if ([request.address isEqualToString:self.workPlace]) { // 工作地点
        
        AMapGeocode *geocode = response.geocodes.firstObject;
        self.workSpaceLatitude = geocode.location.latitude;
        self.workSpaceLongitude = geocode.location.longitude;
        
    } else { // 用户位置
        
        AMapGeocode *geocode = response.geocodes.firstObject;
        self.userLatitude = geocode.location.latitude;
        self.userLongitude = geocode.location.longitude;
    }
    
    [self searchBus];
}

/** 路径规划回调 */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    
    if(!response.route)
    {
        return;
    }
    
    // 更新方案显示
    self.route = response.route;
    self.totalCourse = self.route.transits.count;

    
    DLog(@"====规划信息条目: %ld", (long)response.count);

    
    [self presentCourseWithIndex:0];

    if (!response.route.transits.count) {
        return;
    }
    
    // 显示公交详情
    if (self.busCourseView) {
        [self.busCourseView removeFromSuperview];
    }
    
    BusCourseView *busCourseView = [[BusCourseView alloc] initWithItems:self.route.transits itemClick:^(NSIndexPath *indexPath) {
        
        NSMutableArray *stepArray = [NSMutableArray array];
        
        // 更新路线
        [self clear];
        [self presentCourseWithIndex:indexPath.row];
        
        // 跳转到详情页面
        AMapTransit *transit = self.route.transits[indexPath.row];
        
        for (AMapSegment *segment in transit.segments) {
        
            if (segment.walking && segment.walking.steps.count) {
                
                for (AMapStep *step in segment.walking.steps) {
                    
                    [stepArray addObject:step.instruction];
                }
            }
            
            if (segment.buslines && segment.buslines.count) {
                
                AMapBusLine *busLine = segment.buslines.firstObject;
                
                NSString *busStep = [NSString stringWithFormat:@"乘坐%@公交车, %@上车,途经%lu个站点于%@下车", busLine.name, busLine.departureStop.name, (unsigned long)busLine.viaBusStops.count, busLine.arrivalStop.name];
                
                [stepArray addObject:busStep];
            }
        }        
        
        
        BusCourseDetailViewController *vc = [[BusCourseDetailViewController alloc] init];
        vc.stepArray = stepArray;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    self.busCourseView = busCourseView;
    [self.view addSubview:busCourseView];
}

/** 搜索公交线路 */
- (void)searchBus
{
    if (self.workSpaceLatitude == 0 || self.userLatitude == 0) {
        return;
    }
    
    [self clear];
    
    AMapTransitRouteSearchRequest *request = [[AMapTransitRouteSearchRequest alloc] init];
    request.requireExtension = YES;

    if (self.city) {
        request.city = self.city;
    }
    
    if (self.locationTopConstraint.constant == 8) { // 正向
        
        request.origin = [AMapGeoPoint locationWithLatitude:self.userLatitude longitude:self.userLongitude];
        request.destination = [AMapGeoPoint locationWithLatitude:self.workSpaceLatitude longitude:self.workSpaceLongitude];
        
    } else { // 反向
        
        request.origin = [AMapGeoPoint locationWithLatitude:self.workSpaceLatitude longitude:self.workSpaceLongitude];
        request.destination = [AMapGeoPoint locationWithLatitude:self.userLatitude longitude:self.userLongitude];
    }
    
    // 移除大头针
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    // 添加大头针
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.title = @"起点";
    startAnnotation.coordinate = CLLocationCoordinate2DMake(request.origin.latitude, request.origin.longitude);
    [self.mapView addAnnotation:startAnnotation];
    
    MAPointAnnotation *endAnnotation = [[MAPointAnnotation alloc] init];
    endAnnotation.title = @"终点";
    endAnnotation.coordinate = CLLocationCoordinate2DMake(request.destination.latitude, request.destination.longitude);
    [self.mapView addAnnotation:endAnnotation];
    
    [self.search AMapTransitRouteSearch:request];
}


/* 展示当前路线方案. */
- (void)presentCourseWithIndex:(NSInteger)index
{
    if (!self.route.transits || !self.route.transits.count) {
        [UIHelper toast:@"对不起,没有搜索到相关公交线路"];
        return;
    }
    
    self.naviRoute = [MANaviRoute naviRouteForTransit:self.route.transits[index]];
    
    [self.naviRoute addToMapView:self.mapView];
    
    /* 缩放地图使其适应polylines的展示. */
    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
                        edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge)
                           animated:YES];
    
}


/* 进入详情页面. */
- (void)detailAction
{
    if (self.route == nil)
    {
        return;
    }
    
    // 进入详情页面.....
}


/* 清空地图上已有的路线. */
- (void)clear
{
    [self.naviRoute removeFromMapView];
}


#pragma mark - MAMapViewDelegate

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineView *polylineRenderer = [[MAPolylineView alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        
        polylineRenderer.lineWidth   = 4;
        polylineRenderer.strokeColor = [UIColor blueColor];
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineView *polylineRenderer = [[MAPolylineView alloc] initWithPolyline:naviPolyline.polyline];
        
        polylineRenderer.lineWidth = 4;
        polylineRenderer.strokeColor = [UIColor greenColor];
        
        if (naviPolyline.type == MANaviAnnotationTypeWalking)
        {
            polylineRenderer.strokeColor = [UIColor greenColor];
        }
        else
        {
            polylineRenderer.strokeColor = self.naviRoute.routeColor;
        }
        
        return polylineRenderer;
    }
    
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *routePlanningCellIdentifier = @"RoutePlanningCellIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:routePlanningCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:routePlanningCellIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        
        if ([annotation isKindOfClass:[MANaviAnnotation class]])
        {
            switch (((MANaviAnnotation*)annotation).type)
            {
                case MANaviAnnotationTypeBus:
                    poiAnnotationView.image = [UIImage imageNamed:@"gd_bus"];
                    break;
                    
                case MANaviAnnotationTypeDrive:
                    poiAnnotationView.image = [UIImage imageNamed:@"gd_car"];
                    break;
                    
                case MANaviAnnotationTypeWalking:
                    poiAnnotationView.image = [UIImage imageNamed:@"gd_man"];
                    break;
                    
                default:
                    break;
            }
            
        } else {
            
            /* 起点. */
            if ([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerStartTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"gd_startPoint"];
            }
            /* 终点. */
            else if([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerDestinationTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"gd_endPoint"];
            }
        }
        
        
        return poiAnnotationView;
    }
    
    return nil;
}


#pragma mark - 按钮点击
- (IBAction)btnSwitchAddOnclick:(UIButton *)sender
{
    if (self.locationTopConstraint.constant == 8) {
        self.locationTopConstraint.constant = 56;
        self.dstLocationTopConstraint.constant = 8;
        
    } else {
        self.locationTopConstraint.constant = 8;
        self.dstLocationTopConstraint.constant = 56;

    }
    
    [self searchBus];
}


/** 我的位置点击 */
- (IBAction)myLocationClick:(UIButton *)sender
{
    NSString *title = self.locationTopConstraint.constant == 8 ? @"请输入起点" : @"请输入终点";
    
    self.locationAlertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    self.locationAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *locationTextField = [self.locationAlertView textFieldAtIndex:0];
    locationTextField.text = self.btnMyLocal.currentTitle;
    [self.locationAlertView show];
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        UITextField *locationField = [alertView textFieldAtIndex:0];
        if (locationField.text.length < 2) {
            
            [UserData delayTask:0.3 onTimeEnd:^{
                
                [UIHelper toast:@"请输入正确的位置"];
            }];
            
            [alertView show];
 
        } else {
            
            [self.btnMyLocal setTitle:locationField.text forState:UIControlStateNormal];
            
            // 地理编码
            self.userLongitude = 0;
            self.userLatitude = 0;
            AMapGeocodeSearchRequest *geoRequest = [[AMapGeocodeSearchRequest alloc] init];
            geoRequest.address = locationField.text;
            if (!self.city) {
                geoRequest.city = self.city;
            }
            [self.search AMapGeocodeSearch:geoRequest];
        }
    }
}

- (void)dealloc{
    ELog(@"内存被释放了~~~");
    self.mapView.delegate = nil;
}

@end
