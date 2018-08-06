//
//  OutputView.swift
//  JSONParser
//
//  Created by oingbong on 2018. 8. 2..
//  Copyright © 2018년 JK. All rights reserved.
//

import Foundation

struct OutputView {
    public static func printJson(to json:Json){
        let (string,int,bool,object) = json.count()
        
        let totalCount = string + int + bool + object
        var message = "총 \(totalCount)개의 데이터 중에 "
        if string > 0 {
            message = message + "문자열 \(string)개,"
        }
        if int > 0 {
            message = message + "숫자 \(int)개,"
        }
        if bool > 0 {
            message = message + "부울 \(bool)개,"
        }
        if object > 0 {
            message = message + "객체 \(object)개,"
        }
        message.removeLast() // 마지막 , 는 제거 합니다.
        message = message + "가 포함되어 있습니다."
        print(message)
    }
}
