//
//  NoRecordFound.swift
//  SimPill


import UIKit

class NoRecordFound: UIViewController
{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func btnBackAct(_ sender: UIBarButtonItem) {
        //let storboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalenderVC")
        //self.navigationController?.pushViewController(storboard, animated: true)
       // self.present(storboard, animated: true, completion: nil)
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
