//
//  TableViewController.swift
//  lonedog
//
//  Created by Franklin Schrans on 24/03/2015.
//  Copyright (c) 2015 Franklin Schrans. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var people = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
    func loadData() {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Person")
        
        var error: NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
        
        if let results = fetchedResults {
            self.people = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
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
        cell.name.text = person.valueForKey("name") as String?
        let debtValue = person.valueForKey("debt") as Float?
        cell.debt.text = "$\(debtValue!)"
        
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
            
            deletePerson(indexPath)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Segue" {
            var detailView: DetailViewController = segue.destinationViewController as DetailViewController
            var indexPath = self.tableView.indexPathForSelectedRow()
            
            let personData = people[indexPath!.row]
            let name = personData.valueForKey("name") as String?
            let debt = personData.valueForKey("debt") as Float?
            let debtStartDate = personData.valueForKey("debtStartDate") as String?
            let debtEndDate = personData.valueForKey("debtEndDate") as String?
            
            detailView.person = Person(name: name, debt: debt!, debtStartDate: debtStartDate, debtEndDate: debtEndDate)
        }
    }
    
    @IBAction func add(sender: AnyObject) {
        let alertController = UIAlertController(title: "Add new", message: nil, preferredStyle: .Alert);
        
        let addAction = UIAlertAction(title: "Add", style: .Default) { (_) in
            let newPersonNameTextField = alertController.textFields![0] as UITextField
            //(alertController.textFields![0] as UITextField).autocapitalizationType = .Words      <-- Doesn't seem to work
            //newPersonNameTextField.autocapitalizationType = .Words                               <-- Doesn't seem to work
            
            self.savePerson(newPersonNameTextField.text)
            
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
    
    var coreDataSetUp : () -> (NSManagedObjectContext, NSEntityDescription?) = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedContext)
        

        return (managedContext, entity)
    }
    
    func savePerson(name: String) {
        
        let (managedContext, entity) = coreDataSetUp()
        
        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        person.setValue(name, forKey: "name")
        
        var error : NSError?
        
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        
        people.append(person)
    }
    
    func deletePerson(indexPath : NSIndexPath) {
        
        let (managedContext, entity) = coreDataSetUp()
        
        let person = people[indexPath.row]
        
        people.removeAtIndex(indexPath.row)
        
        managedContext.deleteObject(person)
        
        var error : NSError?
        
        if !managedContext.save(&error) {
            println("Could not delete \(error), \(error?.userInfo)")
        }
        
    }
    
}