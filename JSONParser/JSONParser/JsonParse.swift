//
//  Parse.swift
//  JSONParser
//
//  Created by oingbong on 2018. 8. 15..
//  Copyright © 2018년 JK. All rights reserved.
//

import Foundation

struct JsonParse:Equatable {
    
    public static func makeObject(to jsonData:String) -> [String:JsonType] {
        
        var elements = jsonData.trimmingCharacters(in: .whitespaces)
        
        elements.removeFirst()
        elements.removeLast()
        
        var jsonObject = [String:JsonType]()
        
        if let regex = try? NSRegularExpression(pattern: Regex.objectPatternSmallObject){
            let string = elements as NSString
            
            let regexMatches = regex.matches(in: elements, options: [], range: NSRange(location: 0, length: string.length)).map {
                string.substring(with: $0.range)
            }
            
            jsonObject = parseObject(to: regexMatches)
        }
        
        return jsonObject
    }
    
    private static func parseObject(to regexMatches:[String]) -> [String:JsonType] {
        var jsonObject = [String:JsonType]()
        
        for regexMatch in regexMatches {
            // key & value parse
            guard var key = parseKey(to: regexMatch) else { break }
            guard var value = parseValue(to: regexMatch) else { break }
            
            // trim Colon(:)
            (key , value) = trimColon(first: key, last: value)
            
            // save [String:JsonType]
            if value.isObject() {
                let object = makeObject(to: value)
                jsonObject.updateValue(JsonType.object(object), forKey: key)
            }else if value.isArray() {
                let array = makeArray(to: value)
                jsonObject.updateValue(JsonType.array(array), forKey: key)
            }else if value.isBool() {
                let bool = makeBool(to: value)
                jsonObject.updateValue(JsonType.bool(bool), forKey: key)
            }else if value.isNumber() {
                let int = makeInt(to: value)
                jsonObject.updateValue(JsonType.int(int), forKey: key)
            }else {
                jsonObject.updateValue(JsonType.string(value), forKey: key)
            }
        }
        
        return jsonObject
    }
    
    public static func makeArray(to jsonData:String) -> [JsonType] {
        
        var elements = jsonData.trimmingCharacters(in: .whitespaces)
        
        elements.removeFirst()
        elements.removeLast()
        
        var jsonArray = [JsonType]()
        
        if let regex = try? NSRegularExpression(pattern: Regex.arrayPatternSmallArray){
            let string = elements as NSString
            
            let regexMatches = regex.matches(in: elements, options: [], range: NSRange(location: 0, length: string.length)).map {
                string.substring(with: $0.range)
            }
            
            jsonArray = parseArray(to: regexMatches)
        }
        
        return jsonArray
    }
    
    private static func parseArray(to regexMatches:[String]) -> [JsonType] {
        var jsonArray = [JsonType]()
        
        for regexMatch in regexMatches {
            if regexMatch.isObject() {
                let object = makeObject(to: regexMatch)
                jsonArray.append(JsonType.object(object))
            }else if regexMatch.isArray() {
                let array = makeArray(to: regexMatch)
                jsonArray.append(JsonType.array(array))
            }else if regexMatch.isBool() {
                let bool = makeBool(to: regexMatch)
                jsonArray.append(JsonType.bool(bool))
            }else if regexMatch.isNumber() {
                let int = makeInt(to: regexMatch)
                jsonArray.append(JsonType.int(int))
            }else {
                jsonArray.append(JsonType.string(regexMatch))
            }
        }
        
        return jsonArray
    }
    
    private static func trimColon(first:String , last:String) -> (String, String) {
        var key = first
        var value = last
        /*
         key,value 앞뒤에 붙은 : 제거
         1. 앞뒤 공백 제거
         2. : 제거
         3. 한번 더 앞뒤 공백 제거
         */
        key = key.trimmingCharacters(in: .whitespacesAndNewlines)
        value = value.trimmingCharacters(in: .whitespacesAndNewlines)
        key.removeLast()
        value.removeFirst()
        key = key.trimmingCharacters(in: .whitespacesAndNewlines)
        value = value.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return (key, value)
    }
    
    private static func parseKey(to regexMatch:String) -> String? {
        if let regexKey = try? NSRegularExpression(pattern: Regex.objectKeyPattern){
            let string = regexMatch as NSString
            let keyRegexMatches = regexKey.matches(in: regexMatch, options: [], range: NSRange(location: 0, length: string.length)).map {
                string.substring(with: $0.range)
            }
            
            if keyRegexMatches.count > 0 {
                return keyRegexMatches[0]
            }
        }

        return nil
    }
    
    private static func parseValue(to regexMatch:String) -> String? {
        if let regexValue = try? NSRegularExpression(pattern: Regex.objectValuePattern){
            let string = regexMatch as NSString
            let valueRegexMatches = regexValue.matches(in: regexMatch, options: [], range: NSRange(location: 0, length: string.length)).map {
                string.substring(with: $0.range)
            }
            
            if valueRegexMatches.count > 0 {
                return valueRegexMatches[0]
            }
        }
        
        return nil
    }
    
    public static func makeBool(to data:String) -> Bool {
        return Bool(data)!
    }
    
    public static func makeInt(to data:String) -> Int {
        return Int(data)!
    }
    
}
