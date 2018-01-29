//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
  
  public func convert(_ to: String) -> Money {
    var result = 0
    let dAmount = Double(self.amount)
    if self.currency == "USD" {
        if to == "GBP" {
            result = Int(dAmount * 0.5)
        }
        if to == "EUR" {
            result = Int(dAmount * 1.5)
        }
        if to == "CAN" {
            result = Int(dAmount * 1.25)
        }
    }
    if self.currency == "GBP" {
        if to == "USD" {
            result = Int(dAmount * 2)
        }
        if to == "EUR" {
            result = Int(dAmount * 3.5)
        }
        if to == "CAN" {
            result = Int(dAmount * 3.25)
        }
    }
    if self.currency == "EUR" {
        if to == "GBP" {
            result = Int(dAmount * (1/3))
        }
        if to == "USD" {
            result = Int(dAmount * (2/3))
        }
        if to == "CAN" {
            result = Int(dAmount * 1.916666666666)
        }
    }
    if self.currency == "CAN" {
        if to == "GBP" {
            result = Int(dAmount * 1.3)
        }
        if to == "EUR" {
            result = Int(dAmount * 2.3)
        }
        if to == "USD" {
            result = Int(dAmount * 0.8)
        }
    }
    return Money(amount: result, currency: to)
  }
  
  public func add(_ to: Money) -> Money {
    if self.currency != to.currency {
        let converted = self.convert(to.currency)
        return Money(amount: converted.amount + to.amount, currency: to.currency)
    }
    return Money(amount: self.amount + to.amount, currency: to.currency)
  }
    
  public func subtract(_ from: Money) -> Money {
    if self.currency != from.currency {
        let converted = self.convert(from.currency)
        return Money(amount: converted.amount - from.amount, currency: from.currency)
    }
    return Money(amount: self.amount - from.amount, currency: from.currency)
  }
}

////////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch self.type {
        case .Hourly(let hourly): return Int(hourly * Double(hours))
        case .Salary(let salary): return salary
    }
  }
  
  open func raise(_ amt : Double) {
    switch self.type {
        case .Hourly(let hourly): self.type = JobType.Hourly(hourly + amt)
        case .Salary(let salary): self.type = JobType.Salary(Int(Double(salary) + amt))
    }
  }
}

////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get {
        return _job
    }
    set(newJob) {
        if self.age > 15 {
            _job = newJob
        }
    }
  }

  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get {
        return _spouse
    }
    set(newSpouse) {
        if self.age > 21 {
            _spouse = newSpouse
        }
    }
  }

  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }

  open func toString() -> String {
    return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(_job) spouse:\(_spouse)]"
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []

  public init(spouse1: Person, spouse2: Person) {
    if spouse1.spouse == nil && spouse2.spouse == nil {
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        members.append(spouse1)
        members.append(spouse2)
    }
  }

  open func haveChild(_ child: Person) -> Bool {
    self.members.append(child)
    return true
  }

  open func householdIncome() -> Int {
    var total = 0
    for member in members {
        if member.job != nil {
            total += Int(member.job!.calculateIncome(2000))
        }
    }
    return total
  }
}
