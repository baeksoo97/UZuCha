//
//  weather.swift
//  HelloWorld
//
//  Created by KWJ on 2018. 5. 28..
//  Copyright © 2018년 KWJ. All rights reserved.
//

import Foundation

struct Weather {
    let summary:String
    let icon:String  // image
    let temperature:Double
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(json:[String:Any]) throws {
        guard let summary = json["summary"] as? String else {throw SerializationError.missing("SUMMARY IS MISSING")}
        
        guard let icon = json["icon"] as? String else {throw SerializationError.missing("icon is missing")}
        
        guard let temperature = json["temperatureMax"] as? Double else {
            throw SerializationError.missing("temp is missing")}
        
        self.summary = summary;
        self.icon = icon
        self.temperature = temperature
    }
}
