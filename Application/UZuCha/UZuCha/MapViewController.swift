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

class MapViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate,GMSMapViewDelegate{
    var locationManager = CLLocationManager()
    


    @IBOutlet weak var mapView: GMSMapView!
    @IBAction func searchButton(_ sender: Any) {
        print("searchButton pressed")
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
        //print(searchBar.text)
        
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
                self.setupMarker()
                self.view = self.mapView
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

        mapView?.delegate = self
        
        locationManager.delegate = self


        initGoogleMaps()
        setupMarker()

    }
    
    func initGoogleMaps() {
        print("init")
        let camera = GMSCameraPosition.camera(withLatitude: 37.557266, longitude: 127.045314, zoom: 15)
        
        self.mapView?.camera = camera
        self.mapView?.delegate = self
        self.mapView?.isMyLocationEnabled = true
        self.view = mapView

    }
    
    func setupMarker(){
        print("setupMarker")
        let markerImage = UIImage(named: "marker_icon")!.withRenderingMode(.alwaysTemplate)
        let markerView = UIImageView(image: markerImage)
        markerView.tintColor = UIColor.red
        
        let marker1 : GMSMarker?
        marker1 = GMSMarker()
        marker1?.position = CLLocationCoordinate2DMake(37.555769,127.049195)
        marker1?.title = "한양대학교 IT/BT 주차장"
        marker1?.icon = self.imageWithImage(image: UIImage(named: "marker_icon")!, scaledToSize: CGSize(width: 48.0, height: 48.0))
        marker1?.opacity = 0.6
        marker1?.snippet = "한양대학교 IT/BT 주차장입니다."
        marker1?.map = mapView
        
        let marker2 : GMSMarker?
        marker2 = GMSMarker()
        marker2?.position = CLLocationCoordinate2DMake(37.561251,127.047674)
        marker2?.title = "사근동 광덕빌딩 주차장"
        marker2?.icon = self.imageWithImage(image: UIImage(named: "marker_icon")!, scaledToSize: CGSize(width: 48.0, height: 48.0))
        marker2?.opacity = 0.6
        marker2?.snippet = "사근동 광덕빌딩 주차장입니다."
        marker2?.map = mapView
        
        self.view = mapView
    }
   
}

