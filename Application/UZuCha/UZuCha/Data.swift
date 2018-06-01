//
//  Data.swift
//  UZuCha
//
//  Created by 수영백 on 2018. 5. 24..
//  Copyright © 2018년 KWJ. All rights reserved.
//

import Foundation
import UIKit


class Park{
    let id : String
    let building : BuildingStr
    let owner : OwnerStr
    let Map_location : Map_locationStr
    let fee : String
    var is_favorite : Bool
    
    //details
    let details : DetailsStr
    
    let owner_comment : String
    
//    let register_date : Date  //자료형 어째야 할지 모르겟음
    init(_ id: String, _ building:BuildingStr,_ owner : OwnerStr,_ Map_location:Map_locationStr,_ fee:String,_ is_favorite:Bool,_  details:DetailsStr,_ owner_comment:String){
        self.building = building
        self.owner = owner
        self.Map_location = Map_location
        self.fee = fee
        self.is_favorite = is_favorite
        self.details = details
        self.owner_comment = owner_comment
        self.id = id
       // self.register_date = register_date
    }
}
class BuildingStr{
    let name : String
    let image_dir : [String]
    let address: String
    init(_ name : String,_ image : [String],_ address : String){
        self.name = name
        self.image_dir = image
        self.address = address
    }
}
class OwnerStr{
    let name : String
    let phone_num : String
    let mail_addr : String
    init(_ name : String,_ phone_num : String,_ mail_addr : String){
        self.name = name
        self.phone_num = phone_num
        self.mail_addr = mail_addr
    }
}

class Map_locationStr{
    let latitude : Double
    let longitude : Double
    init(_ latitude : Double,_ longitude : Double){
        self.latitude = latitude
        self.longitude = longitude
    }
}
class DetailsStr{
    let capacity : Int  //주차 공간 수
    let floor : Int  //지하는 '-'로 표현
    let available_time : String     //주차 가능 시간
    init(_ capacity : Int,_ floor : Int, _ available_time : String){
        self.capacity = capacity
        self.floor = floor
        self.available_time = available_time
    }
}
/*
let building1 = Building("한양대학교", ["img_building1"],"서울시 성동구 왕십리로 19-101")
let building2 = Building("왕십리역", ["img_building2"],"서울시 성동구 왕십리로 29")
let building3 = Building("행당역", ["img_building3"], "서울시 성동구 행당로 82")

let own1 = Owner("백수영","01064849708","qortndud97@naver.com")
let own2 = Owner("이진명", "01012345678", "binaryname@naver.com")
let own3 = Owner("유웅진", "01000000000", "yuyu@naver.com")

let addr1 = Map_location(123,123)
let addr2 = Map_location(456,456)
let addr3 = Map_location(789, 789)

let details1 = Details(4, -1, "9:00AM~10:00PM")
let details2 = Details(6, 2, "10:00AM~9:00PM")
let details3 = Details(7, 1, "8:00AM~9:00PM")

func createPark() ->[Park]{
    let park1 = Park(building1, own1, addr1, "소1000/중2000/대3000",true, details1, "왕십리역 부근")
    let park2 = Park(building2, own2, addr2, "소2000/중3000/대3000",false, details2, "주차하기 편함")
    let park3 = Park(building3, own3, addr3, "소500/중500/대500",false, details3, "트럭 주차 가능")

    return [park1, park2, park3]
}
*/
func createPhoneNum(phoneNum : String) -> String {
    var string = ""
    if(phoneNum.hasPrefix("010") == true){
        var lowerBound = String.Index(encodedOffset: 0)
        var upperBound = String.Index(encodedOffset: 2)
        string += phoneNum[lowerBound...upperBound] + "-"
        lowerBound = String.Index(encodedOffset: 3)
        upperBound = String.Index(encodedOffset: 6)
        string += phoneNum[lowerBound...upperBound] + "-"
        lowerBound = String.Index(encodedOffset: 7)
        upperBound = String.Index(encodedOffset: 10)
        string += phoneNum[lowerBound...upperBound]
    }
    return string
}
 

// 2018.5.31 김원준
// 서버에서 JSON 형식으로 현존하는 모든 데이터를 받아와 class에 대입
func createPark(completion: @escaping ([Park]) -> ()) {
    
    // return Park
    var retPark:[Park] = [];
    
    JSONParking.getAllParkingsJSON() { (results:[JSON_Parking_type]) in
        // results: JSON 타입의 배열
        for result in results {
            
            
            let building = BuildingStr(result.building.building_name, result.building.building_image_dir, result.building.building_address)
            
            let owner = OwnerStr(result.owner.owner_name, result.owner.owner_phone_number, result.owner.owner_mail_address)
            
            let map_location = Map_locationStr(result.google_mark.latitude, result.google_mark.longitude)
            
            let details = DetailsStr(result.detail.capacity, result.detail.floor, result.detail.available_time)
            
            let park:Park = Park(result._id, building, owner, map_location, result.price, result.is_favorite, details, result.owner_comment)
        
            retPark.append(park);
        }
        
        print(retPark[0].building.image_dir)
        completion(retPark)
    }
}

