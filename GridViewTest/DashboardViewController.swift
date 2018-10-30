//
//  DashboardViewController.swift
//  GridViewTest
//
//  Created by Dhilip on 10/30/18.
//  Copyright © 2018 Dhilip. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
  let contentCellIdentifier = "ContentCellIdentifier"
  var phaseTitleArray:[String] = []
  var attributeTitleArray:[String] = []
  var gridDataSource:[ScoringDataModel] = []
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var gridLayout:CustomCollectionViewLayout!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.register(UINib(nibName: "ContentCollectionViewCell", bundle: nil),
                            forCellWithReuseIdentifier: contentCellIdentifier)
    self.prepareDataFromDelegates()
    self.gridLayout.numberOfColumns = attributeTitleArray.count + 1
  }
  func prepareDataFromDelegates () {
    self.phaseTitleArray = ["PH1","PH2","PH3","PH4","PH5", "PH6"]
    self.attributeTitleArray = ["AT1","AT2","AT3","AT4","AT5", "AT6"]
    let phaseCount = self.phaseTitleArray.count
    let attributeCoutn = self.attributeTitleArray.count
    
    for var i in 0..<phaseCount {
      for var j in 0..<attributeCoutn{
        let newScoringData = ScoringDataModel(rowIndex: j + 1, sectionIndex: i + 1)
        if j > 0 {
          newScoringData.rowAttribute = self.attributeTitleArray[j]
          newScoringData.sectionAttribute = self.phaseTitleArray[2]
        }
        gridDataSource.append(newScoringData)
        j = j + 1
      }
      i = i + 1
    }
  }
}
  extension DashboardViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
      return phaseTitleArray.count + 1
      
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return attributeTitleArray.count + 1
      
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      // swiftlint:disable force_cast
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentCellIdentifier,
                                                    for: indexPath) as! ContentCollectionViewCell
      
      if indexPath.section == 0 {
        if indexPath.row == 0 {
          cell.contentLabel.text = "✈️"
          cell.contentLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        } else {
          cell.contentLabel.text = self.attributeTitleArray[indexPath.row - 1]
          cell.contentLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        }
      }
      else {
        if indexPath.row == 0 {
          cell.contentLabel.text = self.phaseTitleArray[indexPath.section - 1]
          cell.contentLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        }
          
          
        else {
          let indexCount = ((indexPath.section - 1) * self.attributeTitleArray.count ) + indexPath.row - 1
          let scoringData = gridDataSource[indexCount]
          cell.contentLabel.text = "R \(scoringData.rowIndex) S \(scoringData.sectionIndex) "
          //cell.contentLabel.text = ""
          cell.setCirlceView(color: scoringData.scoreColor())
          cell.contentLabel.font = UIFont.systemFont(ofSize: 13.0)
        }
      }
      
      return cell
    }
    
  }



