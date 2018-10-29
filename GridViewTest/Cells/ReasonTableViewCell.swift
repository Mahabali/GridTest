//
//  ReasonTableViewCell.swift
//  GridViewTest
//
//  Created by Dhilip on 10/29/18.
//  Copyright © 2018 Dhilip. All rights reserved.
//

import UIKit
protocol LoadFromNib {
  
}
extension LoadFromNib{
  static var nib:UINib {
    return UINib(nibName: identifier, bundle: nil)
  }
  
  static var identifier: String {
    return String(describing: self)
  }
}
class ReasonTableViewCell: UITableViewCell,LoadFromNib {

  @IBOutlet var reasonDetailLabel:UILabel!
  @IBOutlet  var checkBox:Checkbox!
    override func awakeFromNib() {
        super.awakeFromNib()
      checkBox.borderStyle = .square
      checkBox.checkmarkStyle = .tick
      checkBox.checkmarkSize = 0.7
        // Initialization code
    }
  override func prepareForReuse() {
    checkBox.borderStyle = .square
    checkBox.checkmarkStyle = .tick
    checkBox.checkmarkSize = 0.7
  }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
