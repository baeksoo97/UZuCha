//JSONPARKING.swift

import Foundation

struct Google_mark: Decodable {
    let longitude: Double
    let latitude: Double
}
struct Building: Decodable {
    let building_name:String
    let building_address:String
    let building_image_dir:[String]
}

struct Owner: Decodable {
    let owner_name: String
    let owner_mail_address: String
    let owner_phone_number: String
}

struct Detail: Decodable {
    let capacity: Int
    let floor: Int
    let available_time: String
}

struct JSON_Parking_type: Decodable {
    
    let _id:String
    
    let google_mark:Google_mark
    let building:Building
    let owner:Owner
    let detail:Detail
    
    let is_favorite: Bool
    let price: String
    
    let owner_comment: String
    
    //let created_at: Date
}

struct JSONParking {
 
    // set as AWS server
    static let basePath = "http://52.78.114.28:8091/"
    //static let basePath = "http://127.0.0.1:8091/"

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
                    parkingArray = try JSONDecoder().decode([JSON_Parking_type].self, from: data)
                    
                } catch {
                    print("\n\n")
                    print(error)
                    print("\n\n")
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
                    
                    parking = try JSONDecoder().decode(JSON_Parking_type.self, from: data)
                    completion(parking)
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        task.resume()
    }
    
    static func getImagesByID (id: String, completion: @escaping ([String]) -> ()) {
        
        let apiURL = "api/parkings/"
        let inputUrl = basePath + apiURL + id
        
        guard let url = URL(string: inputUrl) else {
            print("ERROR: CANNOT CREATE URL")
            return
        }
//        var image[]
//        for i in 1...arr.count {
//            var string11
//            string11 += apiURL +arr[i]
//            image[i] = string11
//        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            let input_image_string:[String]
            var result_image_string:[String] = []
            var parking:JSON_Parking_type
            
            if let data = data {
                
                do {
                    
                    parking = try JSONDecoder().decode(JSON_Parking_type.self, from: data)
                    input_image_string = parking.building.building_image_dir
                    
                    for image_path in input_image_string {
                        result_image_string.append(basePath + image_path)
                    }
                    
                    completion(result_image_string)
                    
                } catch {
                    print(error.localizedDescription)
                }
                
                
            }
        }
        
        task.resume()
    }
    
    
    static func toggleFavoriteRequest(id: String) {
        
        let apiURL = "api/parkings/toggleFavorite/"
        let inputUrl = basePath + apiURL + id
        
        guard let url = URL(string: inputUrl) else {
            print("ERROR: CANNOT CREATE URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
        }
        
        task.resume()
    }
 
 
}

