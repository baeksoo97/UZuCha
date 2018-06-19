//
//  DetailViewController.swift
//  UZuCha
//
//  Created by 수영백 on 2018. 5. 28..
//  Copyright © 2018년 KWJ. All rights reserved.
//

import UIKit
import GoogleMaps
import MessageUI

class DetailViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MFMessageComposeViewControllerDelegate,GMSMapViewDelegate {
    var selectedPark : Park?
    var imageArray : [URL] = []
    
    @IBOutlet weak var detailView: UILabel!
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var feeView: UILabel!
    @IBOutlet weak var detailsCapacityView: UILabel!
    @IBOutlet weak var detailsAvailableTimeView: UILabel!
    @IBOutlet weak var detailsFloorView: UILabel!
    @IBOutlet var detail_mapView: GMSMapView!
    @IBOutlet weak var commentView: UILabel!
    @IBOutlet weak var addressView: UILabel!
    @IBAction func messageButton(_ sender: Any) {
        if MFMessageComposeViewController.canSendText() == true{
            if let phoneNum = selectedPark?.owner.phone_num{
                print(phoneNum)
                let recipients : [String] = [phoneNum]
                let messageController = MFMessageComposeViewController()
                messageController.messageComposeDelegate = self
                messageController.recipients = recipients
                messageController.body = "hello"
                self.present(messageController, animated: true, completion: nil)
            }
        }
        else{
            print("not working")
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func callingButton(_ sender: Any) {
        if let phoneNum = selectedPark?.owner.phone_num{
            if let phoneCallURL = URL(string: "tel://\(phoneNum)") {
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                }
            }
        }
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
        detailView.text = selectedPark?.owner_comment
        imageCollection.dataSource = self
        imageCollection.delegate = self
        if let phoneNum = selectedPark?.owner.phone_num{
            print(phoneNum)
        }
        
        
        //test

        initmap()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
        let selectedUrl = imageArray[indexPath.row]
        if let data = try? Data(contentsOf: selectedUrl) {//make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            cell.parkImage.image = UIImage(data: data)
        }
        return cell
    }
    func initmap(){
        let latitude = selectedPark?.Map_location.latitude
        let longtitude = selectedPark?.Map_location.longitude
        print(latitude!)
        print(longtitude!)
        

        let camera = GMSCameraPosition.camera(withLatitude: longtitude!,
                                              longitude: latitude!,
                                              zoom: 16)
        detail_mapView?.camera = camera
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: longtitude!, longitude: latitude!)

        marker.map = detail_mapView
    }

}
