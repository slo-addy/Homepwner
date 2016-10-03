//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by Addison Francisco on 9/25/16.
//  Copyright © 2016 Addison Francisco. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
    
    @IBAction func addNewItem(sender: AnyObject) {
        
        // Create a new item and add it the the store
        let newItem = itemStore.createItem()
        
        // Figure out where that item is in the array
        if let index = itemStore.allItems.index(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)
            
            // Insert this new row into the table
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func toggleEditingMode(sender: AnyObject) {
        
        // If you are currently in editing mode...
        if isEditing {
            sender.setTitle("Edit", for: .normal)
            
            // Turn off editing mode
            setEditing(false, animated: true)
        }
        else {
            // Change text of button to inform user of state
            sender.setTitle("Done", for: .normal)
            
            // Enter editing mode
            setEditing(true, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count + 1 // Silver Challenge
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        //​ ​S​e​t​ ​t​h​e​ ​t​e​x​t​ ​o​n​ ​t​h​e​ ​c​e​l​l​ ​w​i​t​h​ ​t​h​e​ ​d​e​s​c​r​i​p​t​i​o​n​ ​o​f​ ​t​h​e​ ​i​t​e​m
        // t​h​a​t​ ​i​s​ ​a​t​ ​t​h​e​ ​n​t​h​ ​i​n​d​e​x​ ​o​f​ ​i​t​e​m​s​,​ ​w​h​e​r​e​ ​n​ ​=​ ​r​o​w​ ​t​h​i​s​ ​c​e​l​l
        // ​w​i​l​l​ ​a​p​p​e​a​r​ ​i​n​ ​o​n​ ​t​h​e​ ​t​a​b​l​e​v​i​e​w
        // Silver challenge
        if indexPath.row == itemStore.allItems.count {
            cell.textLabel?.text = "No more items!"
            cell.detailTextLabel?.text = nil
        }
        else {
            let item = itemStore.allItems[indexPath.row]
            cell.textLabel?.text = item.name
            cell.detailTextLabel?.text = "$\(item.valueInDollars)"
        }
        return cell
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Get the height of the status bar
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // If the table view is asking to commit a delete command...
        if editingStyle == .delete {
            
            if indexPath.row == self.itemStore.allItems.count {
                let ac = UIAlertController(title: "Oops", message: "This row cannot be deleted", preferredStyle: .alert)
                let doneAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                ac.addAction(doneAction)
                present(ac, animated: true, completion: nil)
            }
            else {
                
                let item = itemStore.allItems[indexPath.row]
                
                let title = "Delete \(item.name)?"
                let message = "Are you sure you want to delete this item?"
                
                let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                ac.addAction(cancelAction)
                
                let deleteAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (action) -> Void in
                    
                    // Remove the item from the store
                    self.itemStore.removeItem(item: item)
                    
                    // Also remove that row from the table view with an animation
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                })
                ac.addAction(deleteAction)
                
                // Present the alert controller
                present(ac, animated: true, completion: nil)
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        // Update the model
        itemStore.moveItemAtIndex(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
}












