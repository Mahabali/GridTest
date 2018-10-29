//
//  HeaderView.swift
//  TableViewWithMultipleCellTypes
//
//  Created by Stanislav Ostrovskiy on 5/21/17.
//  Copyright © 2017 Stanislav Ostrovskiy. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: class {
    func toggleSection(header: HeaderView, section: Int)
}

class HeaderView: UITableViewHeaderFooterView,LoadFromNib {

    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var arrowLabel: UILabel?
  @IBOutlet  var checkBox:Checkbox!
    var section: Int = 0
    
    weak var delegate: HeaderViewDelegate?
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
      checkBox.borderStyle = .square
      checkBox.checkmarkStyle = .tick
      checkBox.checkmarkSize = 0.7
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
    }
    
    @objc private func didTapHeader() {
        delegate?.toggleSection(header: self, section: section)
    }

    func setCollapsed(collapsed: Bool) {
        arrowLabel?.rotate(collapsed ? 0.0 : .pi)
    }
  override func prepareForReuse() {
    checkBox.borderStyle = .square
    checkBox.checkmarkStyle = .tick
    checkBox.checkmarkSize = 0.7
     self.checkBox.isHidden = false
  }
  
  func toggleCollapse(should:Bool) {
    if should {
      self.checkBox.isHidden = true
    }
    else{
      self.checkBox.isHidden = false
    }
  }
}


extension UIView {
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
      animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
}
