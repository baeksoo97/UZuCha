//
//  FavoriteTableViewController.swift
//  UZuCha
//
//  Created by 수영백 on 2018. 5. 24..
//  Copyright © 2018년 KWJ. All rights reserved.
//

import UIKit

class FavoriteTableViewController: UITableViewController {
    //let favorParks = parks.filter({$0.is_favorite == true})
    var favorParks:[Park] = []
    
    
    // init(_ building:Building,_ owner : Owner,_ address:Address,_ fee:String,_ is_favorite:Bool,_  details:Details,_ owner_comment:String,_ register_date: String){
    override func viewDidLoad() {
        super.viewDidLoad()
        createPark() { (results:[Park]) in
            for result in results {
                print(result.fee)
            }
            self.favorParks = results.filter({$0.is_favorite == true})
        }
        
        tableView.estimatedRowHeight = 80.0
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favorParks.count
    }

    	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteParkCell", for: indexPath) as! FavoriteParkTableViewCell
        print("1");
        let favoritePark = favorParks[indexPath.row]
        
        var detailsString = ""
        detailsString += "\(favoritePark.details.capacity)" + "대 | "
        if(favoritePark.details.floor < 0){
            detailsString += "지하" + "\(-favoritePark.details.floor)" + "층 | "
        }
        else{
            detailsString += "\(favoritePark.details.floor)" + "층 "
        }
        detailsString += favoritePark.details.available_time
   
        cell.feeView?.text = favoritePark.fee
        cell.detailsView?.text = detailsString
        cell.commentView?.text = favoritePark.owner_comment
        cell.parkImageView?.image = UIImage(named: favoritePark.building.image_dir[0])
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "DetailParkSegue"
        {
            if let destination = segue.destination as? DetailViewController,
                let selectedIndex = self.tableView.indexPathForSelectedRow?.row
            {
                destination.selectedPark = favorParks[selectedIndex]
            }
        }
        
    }
 
    
}

class FavoriteParkTableViewCell : UITableViewCell{
    var parkForCell:Park? { didSet{
        setUpCell()
    }}
    @IBOutlet weak var feeView: UILabel!
    @IBOutlet weak var detailsView: UILabel!
    
    @IBOutlet weak var commentView: UILabel!
    
    @IBOutlet weak var parkImageView: UIImageView!
    
    func setUpCell() {
        guard let park = parkForCell else {
            return
        }
        feeView.text = park.fee
        detailsView.text = ""
        //park.details.available_time + " | " + park.details.capacity + " |" + park.details.floor
        commentView.text = park.owner_comment
        parkImageView.image = UIImage(named:park.building.image_dir[0])
    }
}
