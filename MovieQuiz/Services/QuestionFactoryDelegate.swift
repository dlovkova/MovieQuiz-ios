//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Daria Lovkova on 29.06.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error) 
}
