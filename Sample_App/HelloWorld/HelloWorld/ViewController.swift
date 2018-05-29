//
//  ViewController.swift
//  HelloWorld
//
//  Created by KWJ on 2018. 5. 25..
//  Copyright © 2018년 KWJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 주의사항
        // 아래 함수들은 비동기 함수라서 실행 순서를 보장할 수 없음 **
        
        
        // 사용 예시
        //
        // 1. 저장되어있는 모든 DB 순회하면서 모든 데이터 불러오기
        JSONParking.getAllParkingsJSON() { (results:[JSON_Parking_type]) in
            // results: JSON 타입의 배열
            for result in results {
                
                // 전체 JSON 데이터
                print("\(result)\n")
                
                // JSON 부분 데이터 활용할 때
                print("\(result.building_address)")
                print("\(result.google_mark.latitude)")
                print("\n")
            }
        }
        
        
        
        // 2. id로 검색해서 해당 id의 json 데이터 하나 불러오기
        // id parameter 필요
        JSONParking.getParkingByID(id: "5b082d96791d9b0d7263c93c") { (result:JSON_Parking_type) in
            // result : JSON type
            print("\(result)")
            print("\(result.building_name)\n")
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

