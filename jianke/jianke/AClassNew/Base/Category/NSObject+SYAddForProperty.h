//
//  NSObject+SYAddForProperty.h
//  Tools
//
//  Created by fire on 16/1/14.
//  Copyright © 2016年 fire. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SYAddForProperty)

/** 
 Bind property to a instance With key-value pair.
 
 @aKey:　the key to search the property.
 
 @aValue: the object to bind to the instance.

 eg. [btn addPropertyWithKey:@"customData" value:aPersonModel];
 */
- (void)bindPropertyWithKey:(NSString *)aKey value:(id)aValue;


/**
 Get the object which is bind to a instance With key-value pair.
 
 @aKey:　the key to search the property.
 
 @return: the object to bind to the instance.
 
 eg. PersonModel *aPerson = (PersonModel *)[btn propertyValueForKey:@"custonData"];
 */
- (id)propertyValueForKey:(NSString *)aKey;

/**
 Delete the property which is bind to the instance with the key.
 
 @aKey: the key to search the property.
 */
- (void)removePropertyWithKey:(NSString *)aKey;

/** 
 Delete all properties which are bind to the instance.
 */
- (void)removeAllBindProperty;

/**
 return the object which is bind to the instance.
 
 @return: the object which is bind to the instance.
 
 eg.
     btn.tagObj = @(50);
     NSNumber *myAge = (NSNumber *)btn.tagObj;
 */
- (id)tagObj;

/** 
 Bind the object to the instance.
 
 @aTagObj: the object which had binded to the instance.
 
 eg.
     btn.tagObj = @"good job";
     NSLog(@"%@", btn.tagObj);
 */
- (void)setTagObj:(id)aTagObj;

@end
