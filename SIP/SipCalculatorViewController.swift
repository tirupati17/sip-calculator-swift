//
//  SipCalculatorViewController.swift
//  SIP
//
//  Created by Tirupati Balan on 12/03/16.
//  Copyright © 2016 CelerStudio. All rights reserved.
//

import Foundation
import UIKit

class SipCalculatorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var netReturnLable: UILabel!
    @IBOutlet var actualAmountLable: UILabel!
    @IBOutlet var rolledOverLable: UILabel!

    var periodValue: NSInteger = 0;
    var rorValue: Float = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SIP Calculator";
    }
    
    func returnCellForIndexPath(indexPath : NSIndexPath) -> UITableViewCell {
        return self.tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
    }
    
    func returnAmountField() -> UITextField {
        return self.returnCellForIndexPath(NSIndexPath.init(forRow: 0, inSection: 0)).viewWithTag(111) as! UITextField
    }

    func returnPeriodLabel() -> UILabel {
        return self.returnCellForIndexPath(NSIndexPath.init(forRow: 1, inSection: 0)).viewWithTag(221) as! UILabel
    }

    func returnPeriodSlider() -> UISlider {
        return self.returnCellForIndexPath(NSIndexPath.init(forRow: 1, inSection: 0)).viewWithTag(222) as! UISlider
    }

    func returnRateLabel() -> UILabel {
        return self.returnCellForIndexPath(NSIndexPath.init(forRow: 2, inSection: 0)).viewWithTag(331) as! UILabel
    }

    func returnRateSlider() -> UISlider {
        return self.returnCellForIndexPath(NSIndexPath.init(forRow: 2, inSection: 0)).viewWithTag(332) as! UISlider
    }

    func returnNetLabel() -> UILabel {
        return self.returnCellForIndexPath(NSIndexPath.init(forRow: 3, inSection: 0)).viewWithTag(441) as! UILabel
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.row) {
          case 0:
            return 80;
          case 1:
            return 90;
          case 2:
            return 90;
          case 3:
            return 100;
          default:
            break;
        }
        return 70.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = (self.tableView!.dequeueReusableCellWithIdentifier("cell\(indexPath.row)")! as UITableViewCell)
        
        self.configureCellForTableView(tableView, withCell: cell, withIndexPath: indexPath)
        return cell
    }
    
    func configureCellForTableView(tableView: UITableView, withCell cell: UITableViewCell, withIndexPath indexPath: NSIndexPath) {
        switch (indexPath.row) {
          case 0:
            let textField:UITextField = cell.viewWithTag(111) as! UITextField
            textField.delegate = self
            
            break;
          case 1:
            let periodSlider:UISlider = cell.viewWithTag(222) as! UISlider
            periodSlider.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
            break;
          case 2:
            let rateOfReturnSlider:UISlider = cell.viewWithTag(332) as! UISlider
            rateOfReturnSlider.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
          default:
            break;
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    
    func applyRedBorderOnAmount() {
        self.returnAmountField().layer.borderColor = UIColor.redColor().CGColor
        self.returnAmountField().layer.borderWidth = 1;
        self.returnAmountField().layer.cornerRadius = 5;
    }

    func clearRedBorderOnAmount() {
        self.returnAmountField().layer.borderColor = UIColor.clearColor().CGColor
        self.returnAmountField().layer.borderWidth = 0;
        self.returnAmountField().layer.cornerRadius = 0;
    }

    func sliderValueDidChange(sender: UISlider) {
        if (self.returnAmountField().text == nil || self.returnAmountField().text == "") {
            self.applyRedBorderOnAmount();
            self.tableView.scrollToRowAtIndexPath(NSIndexPath.init(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
            
            self.returnPeriodSlider().value = Float(self.periodValue)
            self.returnRateSlider().value = Float(self.rorValue)
            return;
        } else {
            self.clearRedBorderOnAmount();
        }
        
        switch (sender.tag) {
        case 222:
            self.periodValue = Int(floor(sender.value))
            self.returnPeriodLabel().text = String(format :"%.0f years", floor(sender.value)) //"\(floor(sender.value)) years"
            break;
        case 332:
            self.rorValue = Float(floor(sender.value))
            self.returnRateLabel().text = String(format : "%.0f%@", floor(sender.value), "%")
            break;
        default:
            break;
        }
        let amount = NSNumberFormatter().numberFromString(self.returnAmountField().text!)!.floatValue
        self.calculateNetReturn(amount, period: self.periodValue, rateOfReturn: self.rorValue)
    }
    
    func calculateNetReturn(amount: Float, period: NSInteger, rateOfReturn: Float) {
        let periodMonthly = Double((period * 12));
        let rateOfReturnMonthly = Double(rateOfReturn/12);

        let netReturn = round(-self.futureSipValue(rateOfReturnMonthly, nper: periodMonthly, pmt: Double(amount), pv: 0, type: 1));
        self.netReturnLable.text = String(format : "₹%.0f", floor(netReturn.isNaN ? 0 : netReturn))

        let actualAmout = (Double(period) * 12 * Double(amount));
        self.actualAmountLable.text = String(format : "₹%.0f", floor(actualAmout.isNaN ? 0 : actualAmout))

        let finalValue = self.futureSipValue(Double(rateOfReturn), nper: 1/12,pmt: 0, pv: -100, type: 1)-100
        let finalAmount = round(futureSipValue(finalValue, nper: Double(period) * 12, pmt: Double(amount), pv: 0, type: 1))
        
        let timeRolledOver = -(finalAmount/actualAmout);
        self.rolledOverLable.text = String(format : "%.0f", floor(timeRolledOver.isNaN ? 0 : timeRolledOver))
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func futureSipValue(returnspercent: Double, nper: Double, pmt: Double, pv: Double, type: Double) -> Double {
        let rate: Double = returnspercent/100
        var finalValue: Double = 0;
        finalValue = pmt * (1+rate * type) * ((1 - pow(1 + rate, nper))/rate) - (pv * pow(1+rate, nper))
        return finalValue
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        self.clearRedBorderOnAmount();
        let filtered = string.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString:"0123456789").invertedSet).joinWithSeparator("")
        return string == filtered
    }
}