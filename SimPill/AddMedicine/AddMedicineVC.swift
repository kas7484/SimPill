//
//  AddMedicineVC.swift
//  SimPill


import UIKit
import UserNotifications

class AddMedicineVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource
{
    

    @IBOutlet var scrollView: UIScrollView!
     var picker = UIDatePicker()
     var window: UIWindow?
    
    //for the get the data from the user
    @IBOutlet var txtMedicineName: UITextField!
    @IBOutlet var txtMedicineType: UITextField!
    @IBOutlet var txtMedicineStrength: UITextField!
    @IBOutlet var txtDescription: UITextField!
    @IBOutlet var txtWithFood: UITextField!
    @IBOutlet var txtDoseSchedule: UITextField!
    @IBOutlet var addMedicineView: UIView!
    @IBOutlet var txtDate: UITextField!
    @IBOutlet var txtSelectTime: UITextField!
    
    
    var mName = String()
    var mType = String()
    var mStrength = String()
    var mTime = String()
    var mDesc = String()
    var mFood = String()
    var mDoseSchedule = String()
    var mDate =  String()
    
    var Medicine = [MedicineRecord]()
    var MedicineCount = [MedicineRecord]()
    var isEdit = Bool()
    var totalRecord = Int()
    
    var dosePickerView = UIPickerView()
    var arr_dose_schedule = ["Every Day","Day of week","Month of the week","Every Day one time"]
    
    var food_YesOrNo_pickerView = UIPickerView()
    var arr_with_food_YesOrNo = ["Yes" ,"No"]
    
    @IBOutlet var navBar: UINavigationItem!

    override func viewDidLoad()
    {
        super.viewDidLoad()
       //for the add medicine layout changes
        addMedicineView.layer.cornerRadius = 8.0
        addMedicineView.layer.borderWidth = 1.0
        addMedicineView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 600)
        
        getData()
        if MedicineCount.count > 0 {
            totalRecord = MedicineCount.count
            totalRecord = totalRecord + 1
        }else {
            totalRecord = 1
        }
        if isEdit == true {
            navBar.title = "Edit Medicine"
            let md = Medicine[0]
            txtMedicineName.text = md.mTitle
            txtMedicineType.text = md.mType
            txtMedicineStrength.text = md.mStrength
            txtDoseSchedule.text = md.mSchedule
            txtWithFood.text = md.mFood
            txtSelectTime.text = md.mTime
            txtDate.text = md.mDate
            txtDescription.text = md.mDescription
            
        }else {
            navBar.title = "Add Medicine"
        }
        
        //for the give the permition to allow the notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound]){ (success, error) in
            if error != nil {
                print("Authorization Unsuccessfull")
            }else {
                print("Authorization Successfull")
            }
        }
        setTextfieldDelegate()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == dosePickerView
        {
            return arr_dose_schedule.count
        }
        else if pickerView == food_YesOrNo_pickerView
        {
            return arr_with_food_YesOrNo.count
        }
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView == dosePickerView
        {
            return arr_dose_schedule[row]
        }
        else if pickerView == food_YesOrNo_pickerView
        {
            return arr_with_food_YesOrNo[row]
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == dosePickerView
        {
            txtDoseSchedule.text = arr_dose_schedule[row]
        }
        else if pickerView == food_YesOrNo_pickerView
        {
            txtWithFood.text = arr_with_food_YesOrNo[row]
        }
    }
    
    
    @IBAction func txtSelectDos(_ sender: UITextField) {
        dosePickerView.delegate = self
        txtDoseSchedule.inputView = dosePickerView
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let btnClick = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: nil, action: #selector(doneClicked))
        
        toolBar.setItems([cancelButton, spaceButton, btnClick], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        txtDoseSchedule.inputView = dosePickerView
        txtDoseSchedule.inputAccessoryView = toolBar
    }
    
    @objc func doneClicked() {
        txtDoseSchedule.resignFirstResponder()
    }
    
    
    @IBAction func txtWithFood(_ sender: UITextField) {
        food_YesOrNo_pickerView.delegate = self
        txtWithFood.inputView = food_YesOrNo_pickerView
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let btnClick = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(btnDonePressed))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: nil, action: #selector(btnDonePressed))
        
        toolBar.setItems([cancelButton, spaceButton, btnClick], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        txtWithFood.inputView = food_YesOrNo_pickerView
        txtWithFood.inputAccessoryView = toolBar
    }
    
    @objc func btnDonePressed() {
        txtWithFood.resignFirstResponder()
    }

    func setTextfieldDelegate()
    {
        txtDate.delegate = self
        txtMedicineName.delegate = self
        txtDoseSchedule.delegate = self
        txtMedicineStrength.delegate = self
        txtWithFood.delegate = self
        txtDescription.delegate = self
        txtDescription.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
       if txtMedicineName.resignFirstResponder()
       {
        txtDate.becomeFirstResponder()
        }
        else if txtDate.becomeFirstResponder()
       {
        txtMedicineType.resignFirstResponder()
        }
       else if txtDate.becomeFirstResponder()
       {
        txtMedicineType.resignFirstResponder()
       }
        else if txtMedicineType.resignFirstResponder()
       {
        txtMedicineStrength.becomeFirstResponder()
        }
        else if txtMedicineStrength.resignFirstResponder()
       {
        txtDescription.becomeFirstResponder()
        }
        else if txtDescription.isFirstResponder
       {
        txtWithFood.becomeFirstResponder()
        }
        else if txtWithFood.isFirstResponder
       {
        txtDoseSchedule.resignFirstResponder()
        }
       
        return true
    }
    
    
    @IBAction func selectTime(_ sender: UITextField) {
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(timeSelected))
        toolbar.setItems([done], animated: false)
        
        txtSelectTime.inputAccessoryView = toolbar
        txtSelectTime.inputView = picker
        
        // format picker for date
        picker.datePickerMode = .time
        
    }
    @objc func timeSelected() {
        // format date
        let formatter = DateFormatter()
        formatter.timeStyle = DateFormatter.Style.medium
        
        //formatter.dateFormat = " h:mm a"
        let dateString = formatter.string(from: picker.date)
        
        txtSelectTime.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func txtSelectDate(_ sender: UITextField)
    {
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        
        txtDate.inputAccessoryView = toolbar
        txtDate.inputView = picker
        
        // format picker for date
        picker.datePickerMode = .date
    }
    
    @objc func donePressed() {
        // format date
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        //formatter.dateFormat = "MMM dd, yyyy h:mm a"
        formatter.dateFormat = "MMM dd, yyyy"
        let dateString = formatter.string(from: picker.date)
        
        txtDate.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    
    @IBAction func btnBackAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnSubmitAction(_ sender: Any)
    {
        if isEdit == true {
            var selectedIndex = Int16()
            selectedIndex = Medicine[0].mId as! Int16
            updateMedicine(index: selectedIndex)
        }else{
            addMedicine()
        }
    }
    
    func updateMedicine(index : Int16)
    {
         guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            let medicineRecord = Medicine[0] as MedicineRecord
            medicineRecord.mTitle = self.txtMedicineName.text
            medicineRecord.mDate =  self.txtDate.text
            medicineRecord.mType = self.txtMedicineType.text
            medicineRecord.mStrength = self.txtMedicineStrength.text
            medicineRecord.mDescription = self.txtDescription.text
            medicineRecord.mFood = self.txtWithFood.text
            medicineRecord.mSchedule = self.txtDoseSchedule.text
            medicineRecord.mTime = self.txtSelectTime.text
        
            do {
                try managedContext.save()
                //self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            } catch let error as NSError {
                print("Error while trying to save medicine",error)
            }
        
    }
    
    
    
    func addMedicine()
    {
        if txtMedicineName.text == ""{
            SKToast.show(withMessage: "Required Medicine Name!")
            //txtMedicineName.resignFirstResponder()
        }
        else if txtMedicineType.text == ""{
            SKToast.show(withMessage: "Required Medicine Type!")
            ///txtMedicineName.resignFirstResponder()
        }
        else if txtDate.text == ""{
            SKToast.show(withMessage: "Required Medicine Date!")
            // txtMedicineType.resignFirstResponder()
        }
        else if txtSelectTime.text == ""{
            SKToast.show(withMessage: "Required Medicine Time!")
            // txtMedicineType.resignFirstResponder()
        }
        else if txtMedicineStrength.text == ""{
            SKToast.show(withMessage: "Required Medicine Strength!")
            // txtMedicineType.resignFirstResponder()
        }
        else if txtDescription.text == ""{
            SKToast.show(withMessage: "Required Medicine Description!")
            //txtMedicineStrength.resignFirstResponder()
        }
        else if txtWithFood.text == ""{
            SKToast.show(withMessage: "Required Food or Not!")
            //txtDescription.becomeFirstResponder()
        }
        else if txtDoseSchedule.text == ""{
            SKToast.show(withMessage: "Required Dose Schedule!")
            //txtWithFood.becomeFirstResponder()
        }
        else if txtMedicineName.text == mName || txtDate.text == mDate || txtSelectTime.text == mDate || txtMedicineType.text == mType || txtMedicineStrength.text == mStrength || txtDescription.text == mDesc || txtWithFood.text == mFood || txtDoseSchedule.text == mDoseSchedule
        {
            self.txtMedicineName.text = ""
            self.txtWithFood.text = ""
            self.txtDescription.text = ""
            self.txtMedicineType.text = ""
            self.txtDoseSchedule.text = ""
            self.txtMedicineStrength.text = ""
            self.txtDate.text = ""
            self.txtSelectTime.text = ""
            
        }
        else if txtMedicineName.text != "" && txtDate.text != "" && txtSelectTime.text != "" && txtMedicineType.text != "" && txtMedicineStrength.text != "" && txtDescription.text != "" && txtWithFood.text != "" && txtDoseSchedule.text != ""
        {
            let alert = UIAlertController(title: "SimPill", message: "Medicine Added Successfully", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler:
            { (alert) in
                
                //create the database object reference
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                
                //for the coredata table reference
                let medicine = MedicineRecord(context: context)
                
                //geting data from the user
                medicine.mId = Int16(self.totalRecord) as NSNumber
                medicine.mTitle = self.txtMedicineName.text
                medicine.mDate =  self.txtDate.text
                medicine.mTime  = self.txtSelectTime.text
                medicine.mType = self.txtMedicineType.text
                medicine.mStrength = self.txtMedicineStrength.text
                medicine.mDescription = self.txtDescription.text
                medicine.mFood = self.txtWithFood.text
                medicine.mSchedule = self.txtDoseSchedule.text
                
                //(UIApplication.shared.delegate as! AppDelegate).saveContext()
                do { let delegate = UIApplication.shared.delegate as? AppDelegate
                    delegate?.scheduleNotification(at: self.picker.date)
                    try context.save()
                } catch let error as NSError {
                    print("Error while trying to save notification",error)
                }
                print("Medicine Added Successfully.")
                
                //for the clear textfield after the add medicine
                self.txtMedicineName.text = ""
                self.txtWithFood.text = ""
                self.txtDescription.text = ""
                self.txtMedicineType.text = ""
                self.txtDoseSchedule.text = ""
                self.txtMedicineStrength.text = ""
                self.txtDate.text = ""
                self.txtSelectTime.text = ""
                
                //for the move to calender viewcontroller
                let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalenderVC")
                self.navigationController?.pushViewController(storyboard, animated: true)
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getData()
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            try MedicineCount = context.fetch(MedicineRecord.fetchRequest())
        }
        catch{
            print("Error Message :-\(error)")
        }
    }
    
}
