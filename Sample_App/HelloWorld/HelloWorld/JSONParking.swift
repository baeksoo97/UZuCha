//
//  weather.swift
//  HelloWorld
//
//  Created by KWJ on 2018. 5. 28..
//  Copyright © 2018년 KWJ. All rights reserved.
//
import Foundation

struct Google_mark: Decodable {
    let longitude: Double
    let latitude: Double
}

struct JSON_Parking_type: Decodable {
    let google_mark:Google_mark
    
    let building_name:String
    let building_address:String
    let building_image_dir:[String]
    
    let owner_name: String
    let owner_mail_address: String
    let owner_phone_number: String
    
    let price: String
    let availabe_time: String
    let is_favorite: Bool
    
    let owner_comment: String
    
    //let created_at: Date
}

struct JSONParking {
    // keys of JSON
    /*
    let building_name:String
    let building_address:String
    let owner_name:String
 */
    /*
    let longitude:Double
    let latitude:Double
    */
    //let google_mark:Google_mark
    
    // error handlers
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    /*
    init(json: [String: Any]) throws {
        guard let building_name = json["building_name"] as? String else {throw SerializationError.missing("building_name missing")}
        
        guard let building_address = json["building_address"] as? String else {throw SerializationError.missing("building_address missing")}
        
        guard let owner_name = json["owner_name"] as? String else {
            throw SerializationError.missing("owner_name missing")}
        
        //guard let google_mark = json["google_mark"] as? Google_mark else {
        //    throw SerializationError.missing("google_mark missing")}
        
        self.building_name = building_name
        self.building_address = building_address
        self.owner_name = owner_name
        //self.google_mark = google_mark
    }
 */
 
    
    // set as AWS server
    static let basePath = "http://52.78.114.28:8091/"

    // call in main function
    static func getAllParkingsJSON (commands location:String, completion: @escaping ([JSON_Parking_type]) -> ()) {
        
        let inputUrl = basePath + location
        
        guard let url = URL(string: inputUrl) else {
            print("ERROR: CANNOT CREATE URL")
            return
        }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var parkingArray:[JSON_Parking_type] = []
            
            if let data = data {
                
                do {
                    /*
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] {
                        
                        for eachJSON in json {

                            let myStruct = try JSONDecoder().decode(Swifter.self, from: eachJSON)
                            /*
                            if let parking = try? JSONParking(json: eachJSON) {
                                parkingArray.append(parking)
                            }
                            */
                            
                        }
                    }
                    */
                    
                    parkingArray = try JSONDecoder().decode([JSON_Parking_type].self, from: data)
                    
                } catch {
                    print(error.localizedDescription)
                }
                
                completion(parkingArray)
                
            }
            
        }
 
        task.resume()
    }
}

