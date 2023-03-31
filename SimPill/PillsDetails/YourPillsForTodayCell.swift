//
//  YourPillsForTodayCell.swift
//  SimPill
//


import UIKit

class YourPillsForTodayCell: UITableViewCell {

    var medicine: MedicineRecord?
    var selectedDate: String?
    
    @IBOutlet var pillView: UIView!
    @IBOutlet var mTitle: UILabel!
    @IBOutlet var mType: UILabel!
    @IBOutlet var mStrength: UILabel!
    @IBOutlet var mDescription: UILabel!
    @IBOutlet var mDoseSchedule: UILabel!
    @IBOutlet var mTime: UILabel!
    @IBOutlet var mFood: UILabel!
    @IBOutlet var mDate: UILabel!
    
    @IBOutlet var flagImage: UIImageView!
    
    
    func setup()
    {
        self.mTitle.text = self.medicine?.mTitle
        self.mDate.text = self.medicine?.mDate
        
        if selectedDate == medicine?.mDate
        {
            let color = UIColor.red
            self.mDate.textColor = color
            self.mTitle.textColor = color
        }else {
            let color = UIColor.black
            self.mDate.textColor = color
            self.mTitle.textColor = color
            
        }
    }
    
   

}
