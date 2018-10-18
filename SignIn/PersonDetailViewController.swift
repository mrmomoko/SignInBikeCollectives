//
//  BFFPersonDetailViewController.swift
//  SignIn
//
//  Created by Momoko Saunders on 1/29/15.
//  Copyright (c) 2015 Momoko Saunders. All rights reserved.
//

import Foundation
import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


protocol PersonDetailViewControllerDelegate {
    func didMakeChangesToContactOnEditVC()
}

class PersonDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EditUserViewControllerDelegate {
   
    var contact : Contact?
    var shopUse : ShopUse?
    let shopUseLog = ShopUseLog()
    var typesOfUsers = [String]()
    var delegate : PersonDetailViewControllerDelegate? = nil
    
    @IBOutlet weak var firstNameLastInitial: UILabel!
    @IBOutlet weak var hoursTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissViewControllerAfterTimeOut()
        firstNameLastInitial.text = contact?.displayName()
        // user interface for employees
        if self.tabBarController?.selectedIndex == 0 {
            self.navigationItem.rightBarButtonItem = nil 
        }
        typesOfUsers = ContactLog().typesUsedByContact(contact!)
    }
    override func viewDidAppear(_ animated: Bool) {
         typesOfUsers = ContactLog().typesUsedByContact(contact!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Edit User Segue" {
            let vc = segue.destination as! EditUserViewController
            vc.contact = contact
            vc.delegate = self
        }
    }
    
    func dismissViewControllerAfterTimeOut() {
        let delay = 15.0 * Double(NSEC_PER_SEC) // change to *15 sec
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
            if self.navigationController?.topViewController == self {
                self.navigationController!.popToRootViewController(animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as UITableViewCell
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            let membershipExpiration = contact?.membership!.membershipExpiration
            cell.textLabel?.text = contact?.membership!.membershipType
            if membershipExpiration?.timeIntervalSinceNow > 0 {
                cell.detailTextLabel?.text = String("Expires " + dateFormatter.string(from: membershipExpiration! as Date))
            } else {
                cell.textLabel?.text = "Membership does not exist or is expired"
                cell.detailTextLabel?.text = ""
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HourShopUseCell") as! HourShopUseCell
            let typeTitle = typesOfUsers[indexPath.row]
            cell.title!.text = typeTitle
            let shopUseLog = ShopUseLog()
            let hourThisMonth = shopUseLog.hourlyTotalForThisMonth(contact!, typeTitle: typeTitle)
            let totalHours = shopUseLog.numberOfHoursLoggedByContact(contact!, typeTitle: typeTitle)
            let lastMonthTotal = shopUseLog.hourlyTotalForLastMonth(contact!, typeTitle: typeTitle)
            if hourThisMonth == "1" {
                cell.detailHours.text = "1 hour this month"
                cell.totalHours.text = "1 hour"
                cell.lastMonth.text = "1 hour last month"
            } else {
                cell.detailHours.text = hourThisMonth + " hours this month"
                cell.totalHours.text = totalHours + " hours"
                cell.lastMonth.text = lastMonthTotal + " hours last month"
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return typesOfUsers.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Membership"
        } else {
            return "Hours of Shop Use"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 40
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func didMakeChangesToContact() {
        self.navigationController?.popViewController(animated: true)
        self.hoursTableView.reloadData()
        firstNameLastInitial.text = contact?.firstName
        delegate!.didMakeChangesToContactOnEditVC()
    }
    
}

