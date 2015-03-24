//
//  DetailViewController.swift
//  lonedog
//
//  Created by Franklin Schrans on 24/03/2015.
//  Copyright (c) 2015 Franklin Schrans. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  var person : Person!
  
  //NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];

  @IBOutlet weak var descriptionText: UILabel!
  @IBOutlet weak var amount: UILabel!
  @IBOutlet weak var amountField: UITextField!
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  
  override func viewDidLoad() {
    self.descriptionText.text = person.debt < 0 ? "\(person.name!) owes me" : "I owe \(person.name!)"
    self.amount.text = "$\(abs(person.debt!))"
    self.navigationItem.title = person.name
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    
    amountField.keyboardType = UIKeyboardType.DecimalPad
  }
  
  @IBAction func update(sender: AnyObject) {
    
    if segmentedControl.selectedSegmentIndex == 0 {
      person.debt = person.debt! - getAmountFromText(self.amountField.text)
    } else {
      person.debt = person.debt! + getAmountFromText(self.amountField.text)
    }
    self.view.endEditing(true)
    viewDidLoad()
  }
  
  func getAmountFromText(amount: NSString) -> Float {
    return amount.floatValue
  }
 
  func keyboardWillShow(sender: NSNotification) {
    self.view.frame.origin.y -= (amountField.frame.height + amountField.frame.origin.x) - 80
  }
  
  func keyboardWillHide(sender: NSNotification) {
    self.view.frame.origin.y += (amountField.frame.height + amountField.frame.origin.x) - 80
  }
}