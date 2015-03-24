//
//  TableViewController.swift
//  lonedog
//
//  Created by Franklin Schrans on 24/03/2015.
//  Copyright (c) 2015 Franklin Schrans. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
  
  var people: [Person] = [Person(name: "Thomas", debt: 35.32, debtStartDate: nil, debtEndDate: nil)]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
      return 1;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return people.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as TableViewCell

        let person = people[indexPath.row]
        cell.name.text = person.name
        cell.debt.text = "$\(person.debt!)"

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            people.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "Segue" {
        var detailView: DetailViewController = segue.destinationViewController as DetailViewController
        var indexPath = self.tableView.indexPathForSelectedRow()
        detailView.person = people[indexPath!.row]
      }
    }

  @IBAction func add(sender: AnyObject) {
    let alertController = UIAlertController(title: "Add new", message: nil, preferredStyle: .Alert);
    
    let addAction = UIAlertAction(title: "Add", style: .Default) { (_) in
      let newPersonNameTextField = alertController.textFields![0] as UITextField
      self.people.append(Person(name: newPersonNameTextField.text, debt: 0, debtStartDate: nil, debtEndDate: nil))
      self.tableView.reloadData()
    }
    
    addAction.enabled = false
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
    alertController.addTextFieldWithConfigurationHandler { (textField) in
      textField.placeholder = "Add"
      
      NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
        addAction.enabled = textField.text != ""
      }
    }
  
    alertController.addAction(cancelAction)
    alertController.addAction(addAction)
    
    self.presentViewController(alertController, animated: true, completion: nil)
    
  }
}
