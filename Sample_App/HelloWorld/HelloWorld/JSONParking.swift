//
//  weather.swift
//  HelloWorld
//
//  Created by KWJ on 2018. 5. 28..
//  Copyright © 2018년 KWJ. All rights reserved.
//

import Foundation


// d06803c8e6b95cc68c7345a06e1d0082
/*
struct Weather {
    let summary:String
    let icon:String
    let temperature:Double
    
    // errors
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
    
    // basePath = AWS server
    //static let basePath = "http://52.78.114.28:8091/"
    static let basePath = "https://api.darksky.net/forecast/d06803c8e6b95cc68c7345a06e1d0082/"
    
    static func forecast (withLocation location:String, completion: @escaping ([Weather]) -> ()) {
        
        let inputUrl = basePath + location
        guard let url = URL(string: inputUrl) else {
            print("ERROR: CANNOT CREATE URL")
            return
        }
        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            var forecastArray:[Weather] = []
            
            if let data = data {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let dailyForecasts = json["daily"] as? [String:Any] {
                            if let dailyData = dailyForecasts["data"] as? [[String:Any]] {
                                for dataPoint in dailyData {
                                    if let weatherObject = try? Weather(json: dataPoint) {
                                        forecastArray.append(weatherObject)
                                    }
                                }
                            }
                        }
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
                
                completion(forecastArray)
                
            }
        }
        
        task.resume()
    }
}
*/


struct JSONParking {
    // keys of JSON
    let building_name:String
    let building_address:String
    let owner_name:String
    
    // error handlers
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(json: [String: Any]) throws {
        guard let building_name = json["building_name"] as? String else {throw SerializationError.missing("building_name missing")}
        
        guard let building_address = json["building_address"] as? String else {throw SerializationError.missing("building_address missing")}
        
        guard let owner_name = json["owner_name"] as? String else {
            throw SerializationError.missing("owner_name missing")}
        
        self.building_name = building_name
        self.building_address = building_address
        self.owner_name = owner_name
    }
    
    // set as AWS server
    static let basePath = "http://52.78.114.28:8091/"

    // call in main function
    static func getParkingsJSON (commands location:String, completion: @escaping ([JSONParking]) -> ()) {
        
        let inputUrl = basePath + location
        
        guard let url = URL(string: inputUrl) else {
            print("ERROR: CANNOT CREATE URL")
            return
        }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var parkingArray:[JSONParking] = []
            
            if let data = data {
                
                do {
                    
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] {
                        for eachJSON in json {
                            /*
                            if let parking = try? JSONParking(json: eachJSON) {
                                parkingArray.append(parking)
                            }*/
                            print(eachJSON)
                        }
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
                
                completion(parkingArray)
                
            }
        }
        
        task.resume()
    }
}

