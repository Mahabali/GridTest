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
  var phasesCompleted:Int = 1
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var gridLayout:CustomCollectionViewLayout!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Dashboard"
    collectionView.register(UINib(nibName: "ContentCollectionViewCell", bundle: nil),
                            forCellWithReuseIdentifier: contentCellIdentifier)
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Char", style: .done, target: self, action: #selector(addTapped))
    self.prepareDataFromDelegates()
    self.gridLayout.numberOfColumns = attributeTitleArray.count + 1
  }
  
  @objc func addTapped(){
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let controller = storyboard.instantiateViewController(withIdentifier: "RadarChartsViewController") as! RadarChartsViewController
    controller.phaseTitleArray = phaseTitleArray
    controller.attributeTitleArray = attributeTitleArray
    controller.gridDataSource = gridDataSource
    controller.phasesCompleted = phasesCompleted
    self.navigationController?.pushViewController(controller, animated: true)
  }
  func prepareDataFromDelegates () {
    self.phaseTitleArray = ["PH1","PH2","PH3","PH4","PH5", "PH6"]
    self.attributeTitleArray = ["AT1","AT2","AT3","AT4","AT5", "AT6"]
    let phaseCount = self.phaseTitleArray.count
    let attributeCoutn = self.attributeTitleArray.count
    
    for var i in 0..<phaseCount {
      for var j in 0..<attributeCoutn{
        let newScoringData = ScoringDataModel(rowIndex: j + 1, sectionIndex: i + 1)

          newScoringData.rowAttribute = self.attributeTitleArray[j]
          newScoringData.sectionAttribute = self.phaseTitleArray[i]
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
      cell.isUserInteractionEnabled = true
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
          //cell.contentLabel.text = "R \(scoringData.rowIndex) S \(scoringData.sectionIndex) "
          //cell.contentLabel.text = ""
          cell.setCirlceView(color: scoringData.scoreColor())
          cell.contentLabel.font = UIFont.systemFont(ofSize: 13.0)
        }
      }
      
      return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      let contentCell = cell as! ContentCollectionViewCell
      contentCell.contentLabel.textColor = UIColor.darkText
      contentCell.isUserInteractionEnabled = true
      if indexPath.section > 0  && indexPath.row == 0 {
        print("se \(indexPath.section) ro \(indexPath.row)")
        if indexPath.section <= phasesCompleted{
          contentCell.contentLabel.textColor = UIColor.darkText
        }
        else{
          contentCell.contentLabel.textColor = UIColor.lightGray
          contentCell.isUserInteractionEnabled = false
        }
      }
      
    }
  }

extension DashboardViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if indexPath.row == 0 && indexPath.section > 0 {
       print("ind \(indexPath.row) se \(indexPath.section)")
      openPhaseData(phaseData: [], phase: self.phaseTitleArray[indexPath.section-1], phaseId: indexPath.section-1)
      
    }
    else{
      print("ind \(indexPath.row) se \(indexPath.section)")
      let data = gridData(section: indexPath.section, row: indexPath.row)
      if data?.score == .two || data?.score == .one {
        presentReasonsView(selected: data!)
      }
      
    }
  }
  
  func openPhaseData(phaseData:[ScoringDataModel],phase:String, phaseId:Int){
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let controller = storyboard.instantiateViewController(withIdentifier: "CollectionViewController") as! CollectionViewController
    controller.phaseTitleArray = ["","",phase,"",""]
    controller.phaseId = phaseId
    let navigation = UINavigationController.init(rootViewController: controller)
    controller.dashboardVC = self
    self.present(navigation, animated: false, completion: nil)
  }
  func savePhaseData(phaseData:[ScoringDataModel],phase:String, phaseId:Int){
    for rowIndex in 1...phaseData.count{
      
     let index = gridDataSource.index(where: {$0.rowIndex == rowIndex && $0.sectionIndex == phaseId + 1})
      print("index \(index) row \(rowIndex) phase \(phaseId+1)")
      if index != nil {
      let score = phaseData[rowIndex-1]
        gridDataSource[index!].reasons = score.reasons
        gridDataSource[index!].score = score.score
      }
      else{
        print("else")
      }
      phasesCompleted = phaseId + 2
    
  }
    self.collectionView.reloadData()
  }
  
  func presentReasonsView(selected:ScoringDataModel){
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let controller = storyboard.instantiateViewController(withIdentifier: "ReasonsViewController") as! ReasonsViewController
    controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
    controller.delegate = nil
    controller.summaryArray = selected.reasons
    self.present(controller, animated: true, completion: nil)
  }
  
  func gridData(section:Int,row:Int) -> ScoringDataModel? {
    return gridDataSource.first(where:{$0.rowIndex == row && $0.sectionIndex == section}) ?? nil
  }
  
}

