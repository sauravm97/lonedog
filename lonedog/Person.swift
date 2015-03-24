//
//  Person.swift
//  lonedog
//
//  Created by Franklin Schrans on 24/03/2015.
//  Copyright (c) 2015 Franklin Schrans. All rights reserved.
//

import Foundation

class Person {
  
  let name:String?
  var debt:Float?
  let debtStartDate:String?
  let debtEndDate:String?
  
  let currentDate : String? = {
    let date = NSDate()
    let calendar = NSCalendar.currentCalendar()
    let components = calendar.components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear , fromDate: date)
    let year = components.year
    let month = components.month
    let day = components.day
    
    return "\(day)/\(month)/\(year)"
  }()
  
  init(name: String!, debt: Float, debtStartDate: String?, debtEndDate: String?) {
    self.name = name
    self.debt = debt
    self.debtStartDate = debtStartDate == nil ? currentDate : debtStartDate
  }
}
