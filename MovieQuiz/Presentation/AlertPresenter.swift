//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Daria Lovkova on 29.06.2023.
//

import Foundation
import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: UIViewController?
    init(delegate: UIViewController?) {
        self.delegate = delegate
    }
    
    func showAlert(alertModel: AlertModel) {
        
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.buttonAction()
        }
        alert.addAction(action)
        delegate?.present(alert, animated: true, completion: nil)
        alert.view.accessibilityIdentifier = "Alert"
    }
    
    func showErrorAlert(errorAlert: errorAlert) {
        let alert = UIAlertController(
            title: errorAlert.title,
            message: errorAlert.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: errorAlert.buttonText, style: .default) { _ in
        }
        alert.addAction(action)
        delegate?.present(alert, animated: true, completion: nil)
        alert.view.accessibilityIdentifier = "Alert"
    }
}

