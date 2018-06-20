//
//  MapViewController.swift
//  UZuCha
//
//  Created by Woong Jin Yoo on 2018. 5. 27..
//  Copyright © 2018년 Woongjin Yoo. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import GoogleMaps

class MapViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate,GMSMapViewDelegate,UIGestureRecognizerDelegate{
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    var parks:[Park] = []
    var selected_marker_id: String = String()


    @IBOutlet weak var mapView: GMSMapView!
    @IBAction func searchButton(_ sender: Any) {
        print("searchButton pressed")
        removCustomInfoWindow()
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //ignoring user
        UIApplication.shared.beginIgnoringInteractionEvents()
        //activity indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    
        self.view.addSubview(activityIndicator)
    
        //Hide  search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    
        //Create the search request
        //지금 현재 MapKit을 이용하고 있는데 이거를 구글 지오코딩으로 해서 바꾸면 조금더 정확한 값을 얻을수있을듯
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
    
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start{(response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil{
                print("Error")
            }
            else{
                let latitude_ = response?.boundingRegion.center.latitude
                let longtitude_ = response?.boundingRegion.center.longitude
                
                let camera = GMSCameraPosition.camera(withLatitude: latitude_!, longitude: longtitude_!, zoom: 15.0)
                self.mapView?.animate(to: camera)
                self.getMarker()
            }
        }
        
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        initGoogleMaps()
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet var info_button: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager.delegate = self
        getMarker()

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if locations.count > 0
        {
            self.mapView?.camera = GMSCameraPosition.camera(withTarget: (locations.last?.coordinate)!, zoom: 10.0)
        }
    }
    
    func initGoogleMaps() {
        print("init")
        let camera = GMSCameraPosition.camera(withLatitude: 37.557266, longitude: 127.045314, zoom: 15)


        self.mapView?.camera = camera
        self.mapView?.delegate = self
        self.mapView?.isMyLocationEnabled = true
        self.mapView?.settings.myLocationButton = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.view.addSubview(mapView)

    }
    
    func getMarker(){
        print("getmarker")
        createPark() { (results:[Park]) in
            
            self.parks = results
            
            DispatchQueue.main.async {
                self.setupMarker()
            }
        }
    }
    
    func setupMarker(){
        print("setupMarker")

        let markerImage = UIImage(named: "marker_icon3")!.withRenderingMode(.alwaysTemplate)
        let markerView = UIImageView(image: markerImage)
        markerView.tintColor = UIColor.red
        
        for i in 0...(parks.count - 1){

            var parking_lot : GMSMarker?
            parking_lot = GMSMarker()
            parking_lot?.position = CLLocationCoordinate2DMake(parks[i].Map_location.longitude, parks[i].Map_location.latitude)
            parking_lot?.title = parks[i].building.name
            parking_lot?.snippet = parks[i].building.address
            parking_lot?.userData = parks[i].id
//            print(parking_lot?.userData)
            parking_lot?.icon = self.imageWithImage(image: UIImage(named: "marker_icon3")!, scaledToSize: CGSize(width: 48.0, height: 48.0))

            

            parking_lot?.map = self.mapView
        }
    }
   
    
    @IBOutlet var info_id: UILabel!
    @IBOutlet var infowindow: UIView!
    
    @IBOutlet var info_detail: UILabel!
    @IBOutlet var info_comment: UILabel!
    @IBOutlet var info_fee: UILabel!
    @IBOutlet var info_img: UIImageView!
    
    
    func removCustomInfoWindow(){
        print("Start remove sibview")
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }else{
            print("No!")
        }
        if let viewWithTag2 = self.view.viewWithTag(101){
            viewWithTag2.removeFromSuperview()
        }
        print("remove done")
    }
    
    
    func set_infowindow(marker:GMSMarker) {
        
        removCustomInfoWindow()

        infowindow = UIView(frame: CGRect.init(x: 0, y: 0, width: mapView.frame.size.width, height: 130))
        infowindow.tag = 100
        infowindow.backgroundColor = UIColor.white
        infowindow.frame.origin.y = mapView.frame.size.height - 129
        infowindow.layer.cornerRadius = 6
        info_id.tag = 101
        info_img = UIImageView(frame: CGRect.init(x: infowindow.frame.size.width - 165, y: 10, width: 160, height: 110))
        info_img.image = nil
        info_fee.frame.origin.y = (infowindow.frame.size.height - 10) / 5
        info_fee.frame.origin.x = 8
        info_comment.frame.origin.x = 8
        info_comment.frame.origin.y = (infowindow.frame.size.height - 10) / 4  * 3
        info_detail.frame.origin.y = (infowindow.frame.size.height - 10) / 2
        
        info_detail.frame.origin.x = 8


        let park_id = marker.userData as! String

        for park in parks{
            if (park_id == park.id){
                selected_marker_id = park.id
                info_id.text = park_id
                info_button.setTitle(park_id, for: .normal)
                var detailsString = ""
                detailsString += "\(park.details.capacity)" + "대 | "
                if(park.details.floor < 0){
                    detailsString += "지하" + "\(-park.details.floor)" + "층 | "
                }
                else{
                    detailsString += "\(park.details.floor)" + "층 | "
                }
                detailsString += park.details.available_time
                
                info_comment.text = park.owner_comment
                info_fee.text = park.fee
                info_detail.text = detailsString
                
                if (park.building.image_dir.count > 0) {
                    let url = URL(string: park.building.image_dir[0])
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    info_img.image = UIImage(data: data!)
                }
                break
            }
        }
        
        info_fee.font = UIFont.boldSystemFont(ofSize: 17.0)
        info_img.layer.cornerRadius = info_img.frame.width/30

        infowindow.addSubview(info_fee)
        infowindow.addSubview(info_detail)
        infowindow.addSubview(info_comment)
        infowindow.addSubview(info_img)
        infowindow.addSubview(info_button)
        
        mapView.addSubview(infowindow)
    }
    

    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("tap")
        set_infowindow(marker: marker)
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        print("coord")
        removCustomInfoWindow()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "MapParkSegue"
        {
            if let destination = segue.destination as? DetailViewController
            {
                for park in parks{
                    if(selected_marker_id == park.id){
                        destination.selectedPark = park
                    }
                }
            }
        }
        
    }
}

