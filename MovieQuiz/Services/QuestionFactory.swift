//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Vladislav Tudos on 14.08.2023.
//

import Foundation
import UIKit

protocol QuestionFactoryDelegate: AnyObject{
    func didRecieveQuestion(_ question: QuizQuestion)
}

final class QuestionFactory {
    private weak var delegate: QuestionFactoryDelegate?
    
    init(delegate: QuestionFactoryDelegate?) {
        self.delegate = delegate
    }
}

extension QuestionFactory: QuestionFactoryProtocol {
    func requestNextQuestion() {
        guard let question = questions.randomElement() else {
            assertionFailure("no question")
            return
        }
        delegate?.didRecieveQuestion(question)
    }
}

/*
 extension QuestionFactory: QuestionFactoryProtocol {
     func requestNextQuestion() {
         guard let question = questions.randomElement() else {
             assertionFailure("no question")
             return
         }
         delegate?.didRecieveQuestion(question)
     }
 }
 */

private let questions: [QuizQuestion] = [
    QuizQuestion(
        image: "The Godfather",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: true),
    QuizQuestion(
        image: "The Dark Knight",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: true),
    QuizQuestion(
        image: "Kill Bill",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: true),
    QuizQuestion(
        image: "The Avengers",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: true),
    QuizQuestion(
        image: "Deadpool",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: true),
    QuizQuestion(
        image: "The Green Knight",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: true),
    QuizQuestion(
        image: "Old",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: false),
    QuizQuestion(
        image: "The Ice Age Adventures of Buck Wild",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: false),
    QuizQuestion(
        image: "Tesla",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: false),
    QuizQuestion(
        image: "Vivarium",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: false)
]


/*
class QuestionFactory: QuestionFactoryProtocol {
//class QuestionFactory {
    private let questions: [QuizQuestion] = [
            QuizQuestion(
                image: "The Godfather",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "The Dark Knight",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "Kill Bill",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "The Avengers",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "Deadpool",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "The Green Knight",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "Old",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),
            QuizQuestion(
                image: "The Ice Age Adventures of Buck Wild",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),
            QuizQuestion(
                image: "Tesla",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),
            QuizQuestion(
                image: "Vivarium",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false)
        ]
    
    func requestNextQuestion(){
        guard let index = (0..<questions.count).randomElement() else{
            delegate?.didReciveNextQuestion(question: nil)
            return 
        }
        let question = questions[safe: index]
        delegate?.didReciveNextQuestion(question: question)
    }
    
    weak var delegate: QuestionFactoryDelegate?
    init(delegate: QuestionFactoryDelegate? = nil) {
        self.delegate = delegate
    }
    
}
*/
