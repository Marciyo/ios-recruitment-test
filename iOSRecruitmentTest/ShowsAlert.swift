//
//  ShowsAlert.swift
//  iOSRecruitmentTest
//
//  Created by Marcel Mierzejewski on 3/24/18.
//  Copyright © 2018 Snowdog. All rights reserved.
//

import UIKit

protocol ShowsAlert {}

extension ShowsAlert where Self: UIViewController {
    func showAlert(title: String = "Error", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
