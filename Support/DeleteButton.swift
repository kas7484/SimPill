//
//  DeleteButton.swift
//  SimPill
//


import UIKit

class DeleteButton: UIButton
{

    var mainUIColor = UIColor(hexCode: "#FF2600")!
    
    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 8
        self.setTitleColor(mainUIColor, for: .normal)
        self.layer.borderWidth = 1
        self.layer.borderColor = mainUIColor.cgColor
        self.contentEdgeInsets = UIEdgeInsetsMake(10,40,10,40)
        
    }

}
