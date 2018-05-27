//
//  MapViewController.swift
//  UZuCha
//
//  Created by Woong Jin Yoo on 2018. 5. 27..
//  Copyright © 2018년 Woongjin Yoo. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class MapViewController: UIViewController, UISearchBarDelegate{
    @IBAction func searchButton(_ sender: Any) {
        print("searchButton pressed")
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    override func loadView() {
        
        let markerImage = UIImage(named: "marker_icon")!.withRenderingMode(.alwaysTemplate)
        let markerView = UIImageView(image: markerImage)
        markerView.tintColor = UIColor.red
        
        
        let camera = GMSCameraPosition.camera(withLatitude: 37.557266, longitude: 127.045314, zoom: 15)
        let mapView = GMSMapView.map(withFrame: CGRect(x: 100, y: 100, width: 200, height: 200), camera: camera)
        mapView.settings.myLocationButton = true
        mapView.settings.zoomGestures = true
        mapView.settings.scrollGestures = true
        
        
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

