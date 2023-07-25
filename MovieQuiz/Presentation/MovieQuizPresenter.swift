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
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel (
            image: UIImage (data: model.image) ?? UIImage (),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsCount)"
        )
        return questionStep
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
