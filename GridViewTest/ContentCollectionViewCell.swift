//
//  ContentCollectionViewCell.swift
//  CustomCollectionLayout
//
//  Created by Dhilip on 10/20/18.
//  Copyright © 2018 Dhilip. All rights reserved.
//

import UIKit

class ContentCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var circleView:UIView!
  
  override func prepareForReuse() {
    self.layer.borderColor = UIColor.black.cgColor
    self.layer.borderWidth = 1.0
    setCirlceView(color: UIColor.clear)
    self.backgroundColor = UIColor.white
  }
    override func awakeFromNib() {
        super.awakeFromNib()
      self.layer.borderColor = UIColor.black.cgColor
      self.layer.borderWidth = 1.0
      setCirlceView(color: UIColor.clear)
      self.backgroundColor = UIColor.white
        // Initialization code
    }

  func setCirlceView(color:UIColor){
    circleView.layer.borderColor = color.cgColor
    circleView.layer.borderWidth = 1.0
    circleView.layer.cornerRadius = 15.0
    circleView.backgroundColor = color
  }
}
