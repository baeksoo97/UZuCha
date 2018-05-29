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
        // 아래 함수들은 비동기 함수라서 코드 내 실행 순서를 보장할 수 없음 **
        // iOS LifeCycle에 주의하면서 페이지 로드 전 제일 처음에 호출되도록 할 것
        
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
        JSONParking.getParkingByID(id: "5b0d7e164f0fc30e871c8015") { (result:JSON_Parking_type) in
            // result : JSON type
            print("\(result)")
            print("\(result.building_name)\n")
        }
        
        
        // 3. id로 검색해서 해당 id의 사진 디렉토리 불러오기
        // image url이 들어있는 String 배열을 반환
        JSONParking.getImagesByID(id: "5b0d7e164f0fc30e871c8015") { (result:[String]) in
            // result : [String] type
            print("image : \(result)")
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

