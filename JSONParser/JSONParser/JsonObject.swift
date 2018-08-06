//
//  JsonObject.swift
//  JSONParser
//
//  Created by oingbong on 2018. 8. 6..
//  Copyright © 2018년 JK. All rights reserved.
//

import Foundation

struct JsonObject {
    private var dictionary:[String:Any]
    
    init() {
        self.dictionary = [:]
    }
    
    public mutating func addDictionary(key:String, value:Any) {
        self.dictionary.updateValue(value, forKey: key)
    }
    
    public func count() -> (Int,Int,Int,Int) {
        var string = 0
        var int = 0
        var bool = 0
        var object = 0
        
        for ( _ , value) in self.dictionary {
            let allowCharacterSet = CharacterSet.init(charactersIn: "1234567890")
            if (value as AnyObject).contains("true") || (value as AnyObject).contains("false"){
                bool = bool + 1
            }else if (value as AnyObject).trimmingCharacters(in: allowCharacterSet).isEmpty {
                int = int + 1
            }else if (value as AnyObject).hasPrefix("{") {
                object = object + 1
            }else {
                string = string + 1
            }
        }
        
        return (string, int, bool, object)
    }
    
    
}
