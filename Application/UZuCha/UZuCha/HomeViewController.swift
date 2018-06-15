//
//  HomeViewController.swift
//  UZuCha
//
//  Created by 수영백 on 2018. 6. 1..
//  Copyright © 2018년 KWJ. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var currentParks:[Park] = []
    
    @IBOutlet weak var CurrentParkCollectionView: UICollectionView!
    @IBOutlet weak var titleView: UILabel!
    @IBAction func submitView(_ sender: Any) {
        guard let url = URL(string: "http://52.78.114.28:8091/admin/parkings/write") else {
            return //be safe
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        titleView.font = UIFont.boldSystemFont(ofSize: 28.0)
        CurrentParkCollectionView.dataSource = self
        CurrentParkCollectionView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        createPark() { (results:[Park]) in
            self.currentParks = results
            
            DispatchQueue.main.async {
                self.CurrentParkCollectionView.reloadData()
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
        return currentParks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CurrentParkCollectionViewCell", for: indexPath) as! CurrentParkCollectionViewCell

        let currentPark = currentParks[indexPath.row]
        
        if (currentPark.building.image_dir.count > 0){
            if let url = URL(string : currentPark.building.image_dir[0]){
                let selectedUrl = url
                if let data = try? Data(contentsOf: selectedUrl){ //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    cell.CurrentParkImage.image = UIImage(data: data)
                }
                cell.CurrentParkImage.layer.cornerRadius = cell.CurrentParkImage.frame.width/30
                cell.CurrentParkImage.clipsToBounds = true
            }
        }
        
        cell.CurrentParkFee.text = currentPark.fee
        cell.CurrentParkFee.font = UIFont.boldSystemFont(ofSize: 13.0)
        cell.CurrentParkAddress.text = currentPark.building.address
        
        return cell
    }


//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        if segue.identifier == "DetailParkSegue"
//        {
//            if let destination = segue.destination as? DetailViewController,
//                let selectedIndex = self.CurrentParkCollectionView.indexPathsForSelectedItems?.first?.row
//            {
//                destination.selectedPark = currentParks[selectedIndex]
//            }
//        }
//
//    }

}


