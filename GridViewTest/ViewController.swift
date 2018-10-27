//
//  ViewController.swift
//  GridViewTest
//
//  Created by Dhilip on 10/20/18.
//  Copyright © 2018 Dhilip. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  @IBAction func openGridView(_ sender: Any) {
 
    let mainController: CollectionViewController = CollectionViewController(nibName: "CollectionViewController", bundle: nil)
    self.navigationController?.pushViewController(mainController, animated: true)
  }
  
}

