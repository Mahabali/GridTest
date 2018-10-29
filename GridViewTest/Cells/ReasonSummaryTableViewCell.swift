  //
//  ReasonSummaryTableViewCell.swift
//  GridViewTest
//
//  Created by Dhilip on 10/29/18.
//  Copyright © 2018 Dhilip. All rights reserved.
//

import UIKit

class ReasonSummaryTableViewCell: UITableViewCell,LoadFromNib {
  
  @IBOutlet var reasonCodeLabel:UILabel!
  @IBOutlet var reasonDetailLabel:UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
