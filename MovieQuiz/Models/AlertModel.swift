//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Daria Lovkova on 29.06.2023.
//

import Foundation
import UIKit



struct AlertModel {
    
    let title: String = "Этот раунд окончен!"
    var message: String?
    let buttonText: String = "Сыграть еще раз!"
    let buttonAction: () -> Void
}

