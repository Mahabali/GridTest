//
//  ScoringDataModel.swift
//  GridViewTest
//
//  Created by Dhilip on 10/20/18.
//  Copyright © 2018 Dhilip. All rights reserved.
//

import Foundation
import UIKit
enum ScoringValue:Int{
  case one = 1,two = 2,three = 3,four = 4,five = 5
  case unassigned
}

class ScoringDataModel {
  var rowIndex = 0
  var columnIndex = 0
  var score: ScoringValue = .unassigned
  var rowAttribute:String = ""
  var sectionAttribute:String = ""
  var reasons:[String] = []
  
  
  convenience init(rowIndex:Int, columnIndex:Int) {
    self.init()
    self.rowIndex = rowIndex
    self.columnIndex = columnIndex
    
  }
  
  func scoreColor() -> UIColor {
    switch score {
    case .unassigned:
      return UIColor.white
    case .one:
      return UIColor.red
    case .two:
      return UIColor.yellow
    case .three:
      return UIColor.blue
    case .four:
      return UIColor.cyan
    case .five:
      return UIColor(red: 0.36, green: 0.98, blue: 0.01, alpha: 1.0)
    }
  }
}