//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Vladislav Tudos on 30.09.2023.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: BestGame? { get }
    func store(correct: Int, total: Int)
}
