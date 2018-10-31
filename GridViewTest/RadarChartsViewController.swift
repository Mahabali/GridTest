//
//  RadarChartsViewController.swift
//  GridViewTest
//
//  Created by Dhilip on 10/31/18.
//  Copyright © 2018 Dhilip. All rights reserved.
//

import UIKit

class RadarChartsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
  
  var gridDataSource:[ScoringDataModel] = []
  var phaseTitleArray:[String] = []
  var attributeTitleArray:[String] = []
  var phasesCompleted:Int = 0

  @IBOutlet var collectionView:UICollectionView?
    override func viewDidLoad() {
        super.viewDidLoad()
      collectionView?.register(CollectionCell.self, forCellWithReuseIdentifier: "CollectionCell")
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
   
    return phasesCompleted - 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
    collectionCell.initCharts(attributeTitles: attributeTitleArray, scores: ["1","2","3","4","5"])
    var dataSet = ChartDataSet()
    dataSet.entries = dataSetFor(row: indexPath.row)
    dataSet.strokeColor = .red
    dataSet.fillColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
    collectionCell.chartView.dataSets = [dataSet]
    collectionCell.chartView.isAnimationEnabled = false
    return collectionCell
  }

  func dataSetFor(row:Int) -> [ChartDataEntry] {
   let filteredSet = gridDataSource.filter({$0.sectionIndex == row+1})
    var data:[ChartDataEntry] = []
    for i in 0..<filteredSet.count {
      data.append(ChartDataEntry(value: CGFloat(filteredSet[i].score.rawValue)))
    }
    return data
    
  }
}
class CollectionCell: UICollectionViewCell {
  let label: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 14)
    label.textColor = .black
    return label
  }()
  
  let chartView = RadarChartView()
  
  override func prepareForReuse() {
    chartView.removeFromSuperview()
    label.removeFromSuperview()
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    chartView.frame = CGRect(origin: CGPoint.zero, size:frame.size)
    self.layer.borderWidth = 1.0
    self.layer.borderColor = UIColor.black.cgColor
  }
  
  func initCharts(attributeTitles:[String],scores:[String]) {
    chartView.titles = attributeTitles
    chartView.webTitles = scores
    self.addSubview(chartView)
    self.addSubview(label)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
