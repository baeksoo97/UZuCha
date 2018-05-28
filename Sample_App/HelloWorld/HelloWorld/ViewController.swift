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
        // Do any additional setup after loading the view, typically from a nib.
        
        JSONParking.getParkingsJSON(commands: "api/parkings") { (results:[JSONParking]) in
            for result in results {
                print("\(result)\n\n")
            }
        }
 
        /*
        Weather.forecast(withLocation: "37.8267,-122.4333") { (results:[Weather]) in
            for result in results {
                print("\(result)\n\n")
            }
 
            
        }
    */
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

