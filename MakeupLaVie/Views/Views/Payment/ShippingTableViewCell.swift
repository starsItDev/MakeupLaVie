//
//  ShippingTableViewCell.swift
//  TabBar
//
//  Created by Rao Ahmad on 07/08/2023.
//

import UIKit

class ShippingTableViewCell: UITableViewCell, UITextFieldDelegate {

    
    //MARK: - Variables
  
    @IBOutlet weak var cellTextField: UITextField!
    @IBOutlet weak var pickerImage: UIImageView!
    weak var previousTextField: UITextField?
    var rotationAngle: CGFloat = 0.0
    var isPickerVisible: Bool = false
    
    //MARK: - Overrive Func
    override func awakeFromNib() {
        super.awakeFromNib()
        cellTextField.layer.borderWidth = 1.0
        cellTextField.layer.borderColor = UIColor.gray.cgColor
        cellTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldTapped))
        cellTextField.addGestureRecognizer(tapGesture)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Helper Function
    @objc func textFieldTapped() {
      if cellTextField.isFirstResponder {
         cellTextField.resignFirstResponder()
         rotationAngle -= CGFloat.pi / 1
         rotateImage(angle: rotationAngle)
  } else {
      if cellTextField.becomeFirstResponder() {
         rotationAngle += CGFloat.pi / 1
         rotateImage(angle: rotationAngle)
        }
    }
}
    func rotateImage(angle: CGFloat) {
        UIView.animate(withDuration: 0.5) {
        self.pickerImage.transform = CGAffineTransform(rotationAngle: angle)
    }
}
    func resetImageRotation() {
        rotationAngle = 0.0
        rotateImage(angle: rotationAngle)
    }
    func togglePickerVisibility(_ isVisible: Bool) {
               if let pickerView = cellTextField.inputView as? UIPickerView {
                   pickerView.isHidden = !isVisible
               }
           }
    override func becomeFirstResponder() -> Bool {
        if let pickerView = cellTextField.inputView as? UIPickerView {
            pickerView.isHidden = false
    }
        return super.becomeFirstResponder()
    }
    override func resignFirstResponder() -> Bool {
        if let pickerView = cellTextField.inputView as? UIPickerView {
            pickerView.isHidden = true
    }
        return super.resignFirstResponder()
  }
}
   
