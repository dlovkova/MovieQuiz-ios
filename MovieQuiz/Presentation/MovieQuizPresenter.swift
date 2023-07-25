//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Daria Lovkova on 25.07.2023.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
     var currentQuestionIndex: Int = 0
     let questionsCount: Int = 10
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    
    
   func yesButtonClicked() {
       didAnswer(isYes: true)
}
    
    func noButtonClicked() {
        didAnswer(isYes: false)
}
    
    func didAnswer (isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let answer = isYes
        viewController?.showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel (
            image: UIImage (data: model.image) ?? UIImage (),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsCount)"
        )
        return questionStep
    }
    
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
       
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    
     func showNextQuestionOrResults() {
        if self.isLastQuestion() {
           
            viewController?.imageView.layer.borderColor = UIColor.ypBlack.cgColor
            viewController?.showResults()
            viewController?.yesButton.isEnabled = true
            viewController?.noButton.isEnabled = true
        } else {
            self.switchToNextQuestion()
            viewController?.imageView.layer.borderColor = UIColor.ypBlack.cgColor
            
            viewController?.yesButton.isEnabled = true
            viewController?.noButton.isEnabled = true
            viewController?.questionFactory?.requestNextQuestion()
        
        }
    }
    
    
    func isLastQuestion () -> Bool {
        currentQuestionIndex == questionsCount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
}
