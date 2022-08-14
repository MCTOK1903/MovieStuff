//
//  UIViewController+Extension.swift
//  MovieStuff
//
//  Created by Muhammed Celal Tok on 14.08.2022.
//

import UIKit

extension UIViewController {
    
    private enum Constant {
        static let errorTitle = "Error"
        static let okButtonTitle = "OK"
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: Constant.errorTitle, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constant.okButtonTitle, style: .default) {
                UIAlertAction in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
}
