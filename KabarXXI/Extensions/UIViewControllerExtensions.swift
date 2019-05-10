//
//  UIViewControllerExtensions.swift
//  LoginDemo
//
//  Created by Bayu Yasaputro on 05/04/18.
//  Copyright © 2018 DyCode. All rights reserved.
//

import UIKit

extension UIViewController {
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}
