//JSONPARKING.swift

import Foundation

struct Google_mark: Decodable {
    let longitude: Double
    let latitude: Double
}

struct JSON_Parking_type: Decodable {
    let _id:String
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
 
    // set as AWS server
    static let basePath = "http://52.78.114.28:8091/"

    // call in main function
    // get all the lists of parkings in JSON Array form
    static func getAllParkingsJSON (completion: @escaping ([JSON_Parking_type]) -> ()) {
        
        //commands apiURL:String,
        
        let apiURL = "api/parkings"
        let inputUrl = basePath + apiURL
        
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
    
    static func getParkingByID (id: String, completion: @escaping (JSON_Parking_type) -> ()) {
        
        let apiURL = "api/parkings/"
        let inputUrl = basePath + apiURL + id
        
        guard let url = URL(string: inputUrl) else {
            print("ERROR: CANNOT CREATE URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var parking:JSON_Parking_type
            
            if let data = data {
                
                
                
                do {
                    /*
                     if let json = try JSONsSerialization.jsonObject(with: data, options: []) as? [[String:Any]] {
                     
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
                    
                    parking = try JSONDecoder().decode(JSON_Parking_type.self, from: data)
                    completion(parking)
                    
                    
                } catch {
                    print(error.localizedDescription)
                }
                
                
                
                
            }
            
        }
        
        task.resume()
    }
 
}

