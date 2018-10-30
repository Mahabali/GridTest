//
//  ReasonsViewController.swift
//  GridViewTest
//
//  Created by Dhilip on 10/29/18.
//  Copyright © 2018 Dhilip. All rights reserved.
//

import UIKit

struct ReasonModel {
  var mainReason:String
  var subReasons: [String]
//  init(main:String,sub:[String]) {
//    self.init(main: <#String#>)
//    self.mainReason = main
//    self.subReasons = sub
//  }
}

protocol ReasonSubmitted: class {
  func reasonSelected(reasons:[String])
}

class ReasonsViewController: UIViewController {

  @IBOutlet var reasonTableView:UITableView!
  @IBOutlet var reasonSummaryTableView:UITableView!
  weak var delegate:ReasonSubmitted? = nil
  var reasonsArray:[ReasonModel] = []
  var summaryArray:[String] = []
  @IBOutlet var submitButton:UIButton!
  @IBAction func submitAction(){
    delegate?.reasonSelected(reasons: summaryArray)
    self.dismiss(animated: true, completion: nil)
  }
  @IBAction func closeAction(){
    self.dismiss(animated: true, completion: nil)
  }
    override func viewDidLoad() {
        super.viewDidLoad()
      reasonTableView.register(ReasonTableViewCell.nib, forCellReuseIdentifier: ReasonTableViewCell.identifier)
      reasonSummaryTableView.register(ReasonSummaryTableViewCell.nib, forCellReuseIdentifier: ReasonSummaryTableViewCell.identifier)
      reasonTableView.register(HeaderView.nib, forHeaderFooterViewReuseIdentifier: HeaderView.identifier)
      reasonTableView.sectionHeaderHeight = 40.0
      reasonSummaryTableView.rowHeight = 50.0
      prepareData()
      if delegate == nil {
        submitButton.isHidden = true
      }
        // Do any additional setup after loading the view.
    }
  
  func prepareData(){
    let reasonModel = ReasonModel(mainReason: "Identifies the source of operating instructions", subReasons: [])
     let reasonModel1 = ReasonModel(mainReason: "Identifies and follows all operating instructions in a timely manner", subReasons: [])
     let reasonModel2 = ReasonModel(mainReason: "Complies with applicable regulations", subReasons: [])
    let reasonModel3 = ReasonModel(mainReason: "Applies relevant procedural Knowledge", subReasons: ["Dipatch duties - MEL", "Dipatch duties - OFP","Dipatch duties - LFP" ])
    reasonsArray = [reasonModel,reasonModel1,reasonModel2,reasonModel3]
  }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ReasonsViewController:UITableViewDataSource,UITableViewDelegate{
  func numberOfSections(in tableView: UITableView) -> Int {
     if tableView == reasonTableView{
    return reasonsArray.count
    }
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     if tableView == reasonTableView{
    let reason = reasonsArray[section]
    if reason.subReasons.count > 0 {
      return reason.subReasons.count
    }
    return 0
    }
     else{
      return summaryArray.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if tableView == reasonTableView{
      let cell = tableView.dequeueReusableCell(withIdentifier: ReasonTableViewCell.identifier, for: indexPath) as! ReasonTableViewCell
      let reason = reasonsArray[indexPath.section]
      let subReason = reason.subReasons[indexPath.row]
      if summaryArray.contains(constructSubReason(section: indexPath.section, row: indexPath.row)){
        cell.checkBox.isChecked = true
      }
      cell.reasonDetailLabel.text = subReason
      cell.checkBox.section = indexPath.section
      cell.checkBox.row = indexPath.row
      cell.checkBox.isRow = true
      cell.checkBox.addTarget(self, action: #selector(checkBoxTapped(sender:)), for: .valueChanged)
      if delegate == nil {
        cell.checkBox.isUserInteractionEnabled = false
      }
      return cell
    }
    else{
      let cell = tableView.dequeueReusableCell(withIdentifier: ReasonSummaryTableViewCell.identifier, for: indexPath) as! ReasonSummaryTableViewCell
      let reason = summaryArray[indexPath.row]
      cell.reasonDetailLabel.text = reason
      cell.reasonCodeLabel.text = "Reason \(indexPath.row)"
      return cell
    }
  }
  

  
   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if tableView == reasonTableView {
      let header = reasonTableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.identifier) as! HeaderView
      let reason = reasonsArray[section]
      if reason.subReasons.count > 0 {
        header.toggleCollapse(should: true)
      }
      header.titleLabel?.text = reason.mainReason
      if summaryArray.contains(reason.mainReason){
        header.checkBox.isChecked = true
      }
      header.checkBox.section = section
      header.checkBox.row = -1
      header.checkBox.isRow = false
      header.checkBox.addTarget(self, action: #selector(checkBoxTapped(sender:)), for: .valueChanged)
      return header
    }
    return nil
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if tableView == reasonTableView {
    return 60.0
    }
    return 0.0
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  @objc func checkBoxTapped(sender:Checkbox) {
    if sender.isChecked {
      if sender.isRow {
        summaryArray.append(constructSubReason(section: sender.section, row: sender.row))
      }
      else{
        let reason = reasonsArray[sender.section]
        summaryArray.append(reason.mainReason)
      }
    }
    else{
      if sender.isRow {
        let subReason = constructSubReason(section: sender.section, row: sender.row)
        if let index = summaryArray.index(of:subReason) {
          summaryArray.remove(at: index)
        }
      }
      else{
        let reason = reasonsArray[sender.section]
        if let index = summaryArray.index(of: reason.mainReason) {
          summaryArray.remove(at: index)
        }
      }
    }
    reasonSummaryTableView.reloadData()
  }
  
  func constructSubReason(section:Int, row:Int) -> String {
    let reason = reasonsArray[section]
    let subReason = reason.subReasons [row]
    return "\(reason.mainReason) \n \(subReason)"
  }
}
