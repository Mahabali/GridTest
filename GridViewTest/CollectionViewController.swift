// Copyright 2017 Brightec
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// indexPath.row == column
// indexPath.section == row

import UIKit

class CollectionViewController: UIViewController {

    let contentCellIdentifier = "ContentCellIdentifier"
    var phaseTitleArray:[String] = []
    var attributeTitleArray:[String] = []
  var ratingSystemValues:[ScoringDataModel] = []
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

}

// MARK: - UICollectionViewDataSource
extension CollectionViewController: UICollectionViewDataSource {

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
        else if indexPath.row == 1 {
      if indexPath.section > 0 && indexPath.section < ratingSystemValues.count + 1  {
        let scoringModel = ratingSystemValues[indexPath.section - 1]
        cell.contentLabel.text = ""
        cell.setCirlceView(color: scoringModel.scoreColor())
      }
      else{
        cell.contentLabel.text = ""
        cell.setCirlceView(color: UIColor.clear)
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
              
               cell.setCirlceView(color: scoringData.scoreColor())
              cell.contentLabel.font = UIFont.systemFont(ofSize: 13.0)
            }
        }

        return cell
    }

}

// MARK: - UICollectionViewDelegate
extension CollectionViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if indexPath.row == 1 && indexPath.section > 0 && indexPath.section < ratingSystemValues.count + 1{
      
      let scoringData = ratingSystemValues[indexPath.section - 1]
      self.select(value: scoringData.score, forRow: scoringData.rowIndex)
    }
    else{
      print("ind \(indexPath.row) se \(indexPath.section)")
    let scoring = ratingSystemValues[indexPath.section-1]
    select(value: scoring.score,section: indexPath.section , forRow: indexPath.row )
    }
  }
}

extension CollectionViewController {
  
  func prepareDataFromDelegates () {
    self.phaseTitleArray = ["","","PH3","","", ""]
    self.attributeTitleArray = ["AT1","AT2","AT3","AT4","AT5", "AT6"]
    self.attributeTitleArray.insert("Score", at: 0)
    let phaseCount = self.phaseTitleArray.count
    let attributeCoutn = self.attributeTitleArray.count
    
    for var i in 0..<phaseCount {
      for var j in 0..<attributeCoutn{
        let newScoringData = ScoringDataModel(rowIndex: j + 1, sectionIndex: i + 1)
        gridDataSource.append(newScoringData)
        j = j + 1
      }
      i = i + 1
    }

    let score1 = ScoringDataModel.init(rowIndex: 1, sectionIndex: 1)
    score1.score = .one
    let score2 = ScoringDataModel.init(rowIndex: 2, sectionIndex: 1)
    score2.score = .two
    let score3 = ScoringDataModel.init(rowIndex: 3, sectionIndex: 1)
    score3.score = .three
    let score4 = ScoringDataModel.init(rowIndex: 4, sectionIndex: 1)
    score4.score = .four
    let score5 = ScoringDataModel.init(rowIndex: 5, sectionIndex: 1)
    score5.score = .five

    ratingSystemValues = [score1, score2, score3, score4, score5]
  }
  
  func select(value:ScoringValue,forRow:Int){
    gridDataSource = gridDataSource.map({ (scoringDataModel:ScoringDataModel) -> ScoringDataModel in
      if scoringDataModel.sectionIndex == forRow && scoringDataModel.sectionIndex > 0 {
         scoringDataModel.score = value
        return scoringDataModel
      }
      else{
        scoringDataModel.score = .unassigned
        return scoringDataModel
      }
    })
    collectionView.reloadData()
}
  
  func select(value:ScoringValue,section:Int, forRow:Int){
    gridDataSource = gridDataSource.map({ (scoringDataModel:ScoringDataModel) -> ScoringDataModel in
      if scoringDataModel.rowIndex == forRow {
      if scoringDataModel.sectionIndex == section {
        scoringDataModel.score = value
        print("updating for \(forRow) \(section)")
      }
      else{
        scoringDataModel.score = .unassigned
      }
    }
      return scoringDataModel
    })
    collectionView.reloadData()
  }
}
