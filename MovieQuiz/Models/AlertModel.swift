//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Daria Lovkova on 29.06.2023.
//

import Foundation
import UIKit



struct AlertModel {
    
    let title: String?
    var message: String?
    let buttonText: String?
    let buttonAction: () -> Void
}

struct errorAlert {
    let title: String?
    var message: String?
    let buttonText: String?
}
