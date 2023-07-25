//
//  MovieQuizControllerProtocol.swift
//  MovieQuiz
//
//  Created by Daria Lovkova on 26.07.2023.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showResults()
    func resetBorderAndButtons()
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
}

