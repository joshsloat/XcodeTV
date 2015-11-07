//
//  BaseModel.m
//  XcodeTV
//
//  Created by Josh Sloat on 11/6/15.
//  Copyright © 2015 Articulate. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

#pragma mark - Overrides

// Automatically handle underscore_case to camelCase
//  http://www.jsonmodel.com/docs/Classes/JSONKeyMapper.html
+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *userToModelMap = [[self class] JSONtoModelMapOverrides];
    NSMutableDictionary *userToJSONMap  = [NSMutableDictionary dictionaryWithCapacity:userToModelMap.count];
    
    for (NSString *key in userToModelMap)
    {
        userToJSONMap[userToModelMap[key]] = key;
    }

    JSONModelKeyMapBlock toModel = ^ NSString *(NSString *keyName)
    {        
        if ([userToModelMap valueForKeyPath:keyName])
        {
            return [userToModelMap valueForKeyPath:keyName];
        }
        
        //bail early if no transformation required
        if ([keyName rangeOfString:@"_"].location == NSNotFound)
        {
            return keyName;
        }
        
        NSString *camelCase = [keyName capitalizedString];
        camelCase = [camelCase stringByReplacingOccurrencesOfString:@"_" withString:@""];
        camelCase = [camelCase stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[camelCase substringToIndex:1] lowercaseString] ];
        
        return camelCase;
    };
    
    JSONModelKeyMapBlock toJSON = ^ NSString *(NSString *keyName)
    {        
        if ([userToJSONMap valueForKeyPath:keyName])
        {
            return [userToJSONMap valueForKeyPath:keyName];
        }
        
        NSMutableString *result = [NSMutableString stringWithString:keyName];
//        NSRange uppercaseCharacterRange = [result rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]];
//        
//        while (uppercaseCharacterRange.location != NSNotFound)
//        {
//            NSString *lowercaseCharacters = [[result substringWithRange:uppercaseCharacterRange] lowercaseString];
//            [result replaceCharactersInRange:uppercaseCharacterRange
//                                  withString:[NSString stringWithFormat:@"_%@", lowercaseCharacters]];
//            uppercaseCharacterRange = [result rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]];
//        }
        
        return result;
    };
    
    return [[JSONKeyMapper alloc] initWithJSONToModelBlock:toModel
                                 modelToJSONBlock:toJSON];
}

#pragma mark - Helper Methods

+ (NSDictionary *)JSONtoModelMapOverrides
{
    // derived models can implement this to override any mappings of JSON names to property names
    return nil;
}

@end
