//
//  DetailViewController.swift
//  UZuCha
//
//  Created by 수영백 on 2018. 5. 28..
//  Copyright © 2018년 KWJ. All rights reserved.
//

import UIKit

class DetailViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var imageCollection: UICollectionView!
    var selectedPark : Park?
   // var imageArray = [UIImage(named : "img_building1"),UIImage(named : "img_building2"),UIImage(named : "img_building3")]
    var imageArray : [URL] = []
    
    
    @IBOutlet weak var feeView: UILabel!
    @IBOutlet weak var detailsCapacityView: UILabel!
    @IBOutlet weak var detailsAvailableTimeView: UILabel!
    @IBOutlet weak var detailsFloorView: UILabel!
    @IBOutlet weak var commentView: UILabel!
    @IBOutlet weak var addressView: UILabel!
   
    @IBAction func callingButton(_ sender: Any) {
        if let phoneNum = selectedPark?.owner.phone_num{
            let num = createPhoneNum(phoneNum: phoneNum)
            if let phoneCallURL = URL(string: "tel://\(num)") {
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //var image : [String] = selectedPark?.building.image_dir
        var rightFavoriteBarButtonItem : UIBarButtonItem
        if(selectedPark?.is_favorite == true){
             rightFavoriteBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_redheart"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(switchColor))
        }
        else{
             rightFavoriteBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_heart"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(switchColor))
        }
       
        self.navigationItem.setRightBarButtonItems([rightFavoriteBarButtonItem], animated: true)
        
        feeView.text = selectedPark?.fee
        feeView.font = UIFont.boldSystemFont(ofSize: 21.0)
        
        if let capacity = selectedPark?.details.capacity{
            detailsCapacityView.text = "\(capacity)" + "대"
        }
        if let floor = selectedPark?.details.floor{
            if (floor > 0){
                detailsFloorView.text = "\(floor)" + "층"}
            else{
                detailsFloorView.text = "지하 " + "\(-floor)" + "층"}
        }
        detailsAvailableTimeView.text = selectedPark?.details.available_time
        commentView.text = selectedPark?.owner_comment
        commentView.font = UIFont.boldSystemFont(ofSize: 14.0)
        addressView.text = selectedPark?.building.address
            
        imageCollection.dataSource = self
        imageCollection.delegate = self
//        parkImageView.image = UIImage(named: (selectedPark?.building.image_dir[0])!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func switchColor(){
        var afterRightFavoriteBarButtonItem : UIBarButtonItem
        if(selectedPark?.is_favorite == true){
            afterRightFavoriteBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_heart"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(switchColor))
            selectedPark?.is_favorite = false
        }
        else{
            afterRightFavoriteBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_redheart"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(switchColor))
            selectedPark?.is_favorite = true
            print("change true")
        }
        self.navigationItem.setRightBarButtonItems([afterRightFavoriteBarButtonItem], animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let num : Int = selectedPark?.building.image_dir.count {
            for i in 0..<num {
                if let string : String = selectedPark?.building.image_dir[i]{
                    // let url = URL(string: string)
                    imageArray.append( URL(string : string)!)
                }
            }
        }
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ParkImageCollectionViewCell", for: indexPath) as! ParkImageCollectionViewCell
       
      //  print(imageArray[indexPath.row])
        let selectedUrl = imageArray[indexPath.row]
        let data = try? Data(contentsOf: selectedUrl) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        cell.parkImage.image = UIImage(data: data!)
        return cell
    }

}
