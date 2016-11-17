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
// MARK: - Outlets
    @IBOutlet weak var editButton: UIButton!
    
// MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemStore = ItemStore()
        
        updateEditButton()
        
        // Get the height of the status bar
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }
    
// MARK: - User Interaction
    @IBAction func addNewItem(sender: AnyObject) {
        
        // Create a new item and add it the the store
        let newItem = itemStore.createItem()
        
        // Figure out where that item is in the array
        if let index = itemStore.allItems.index(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)
            
            // Insert this new row into the table
            tableView.insertRows(at: [indexPath], with: .automatic)
            updateEditButton()
        }
    }
    
    @IBAction func toggleEditingMode(sender: AnyObject) {
            if itemStore.allItems.count > 0 {
            if isEditing == true {
                // Turn off editing mode
                setEditing(false, animated: true)
                updateEditButton()
            }
            else {
                // Enter editing mode
                setEditing(true, animated: true)
                updateEditButton()
            }
        }
    }
    
// MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        // Update the labels for the new preferred text size
        cell.updateLabels()
        
        //​ ​S​e​t​ ​t​h​e​ ​t​e​x​t​ ​o​n​ ​t​h​e​ ​c​e​l​l​ ​w​i​t​h​ ​t​h​e​ ​d​e​s​c​r​i​p​t​i​o​n​ ​o​f​ ​t​h​e​ ​i​t​e​m
        // t​h​a​t​ ​i​s​ ​a​t​ ​t​h​e​ ​n​t​h​ ​i​n​d​e​x​ ​o​f​ ​i​t​e​m​s​,​ ​w​h​e​r​e​ ​n​ ​=​ ​r​o​w​ ​t​h​i​s​ ​c​e​l​l
        // ​w​i​l​l​ ​a​p​p​e​a​r​ ​i​n​ ​o​n​ ​t​h​e​ ​t​a​b​l​e​v​i​e​w
        // Silver challenge
        if indexPath.row == itemStore.allItems.count {
            cell.nameLabel.text = "No more items!"
            cell.serialNumberLabel.text = nil
            cell.valueLabel.text = nil
        }
        else {
            let item = itemStore.allItems[indexPath.row]
            
            // Configure the cell with the Item
            cell.nameLabel.text = item.name
            cell.serialNumberLabel.text = item.serialNumber
            cell.valueLabel.text = "$\(item.valueInDollars)"
        }
        updateValueLabelColorForPrice(cell: cell)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == itemStore.allItems.count {
            return false
        }
        else {
            return true
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == itemStore.allItems.count {
            return false
        }
        else {
            return true
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // If the table view is asking to commit a delete command...
        if editingStyle == .delete {
            
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
                    self.updateEditButton()
                })
                ac.addAction(deleteAction)
                
                // Present the alert controller
                present(ac, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update the model
        itemStore.moveItemAtIndex(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
// MARK: - Table View Delegates
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == itemStore.allItems.count {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.row >= itemStore.allItems.count {
            return sourceIndexPath
        }
        else {
            return proposedDestinationIndexPath
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowItem" {
            if let row = tableView.indexPathForSelectedRow?.row {
                let item = itemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
            }
        }
    }
    
// MARK: - Additional Helpers
    func updateEditButton() {
        if itemStore.allItems.count < 1 {
            editButton.setTitle("Edit", for: .disabled)
            editButton.isEnabled = false
        }
        else if isEditing == true {
            editButton.setTitle("Done", for: .normal)
            editButton.isEnabled = true
        }
        else {
            editButton.setTitle("Edit", for: .normal)
            editButton.isEnabled = true
        }
    }
    
    func updateValueLabelColorForPrice(cell: ItemCell) {
        if let value = cell.valueLabel.text?.replacingOccurrences(of: "$", with: "") {
            
            let intValue = Float(value)!
            
            
            if intValue < 50 {
                cell.valueLabel.textColor = UIColor(red: 249/255.0, green: 14/255.0, blue: 14/255.0, alpha: 0.8)
            } else {
                cell.valueLabel.textColor = UIColor(red: 11/255.0, green: 193/255.0, blue: 33/255.0, alpha: 0.8)
            }
        }
    }
}












