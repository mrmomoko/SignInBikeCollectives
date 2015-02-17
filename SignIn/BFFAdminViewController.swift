//
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import UIKit

class BFFAdminViewController: UIViewController, UITableViewDelegate  {
    var currentShopLog : [BCNContact] = ShopUseLogSwift().contactsOfCurrentUsers()
    @IBOutlet weak var listOfPeopleTableView: UITableView!
    
    @IBAction func whosInTheShop(sender: AnyObject) {
        // i don't like that everytime i press this button, i'm creating a new instance of the shopUseLogSwift
        currentShopLog = ShopUseLogSwift().contactsOfCurrentUsers()
        listOfPeopleTableView.reloadData()
    }
    @IBAction func allVolunteers(sender: AnyObject) {
        currentShopLog = ShopUseLogSwift().contactsOfCurrentUsers()
        listOfPeopleTableView.reloadData()
    }
    @IBAction func currentMembers(sender: AnyObject) {
        currentShopLog = ShopUseLogSwift().contactsOfCurrentUsers()
        listOfPeopleTableView.reloadData()
    }
}

// Mark: - TableView Delegate -
extension BFFAdminViewController {
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return currentShopLog.count;
    }
    func tableView(tableView: UITableView!,
        cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
            var cell = UITableViewCell()
            cell = listOfPeopleTableView.dequeueReusableCellWithIdentifier("person") as UITableViewCell
            let contact = currentShopLog[indexPath.row]
            cell.textLabel?.text = contact.description()
            cell.backgroundColor = contact.colour
            return cell
                
    }
}
