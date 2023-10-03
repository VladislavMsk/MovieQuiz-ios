//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Vladislav Tudos on 16.08.2023.
//

import Foundation
/*
protocol QuestionFactoryDelegate: AnyObject {
    func didReciveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error)
    
}
*/
protocol QuestionFactoryDelegate: AnyObject{
    func didReceiveNextQuestion(_ question: QuizQuestion)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}

