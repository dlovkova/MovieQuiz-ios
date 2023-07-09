//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Daria Lovkova on 08.07.2023.
//

import Foundation



protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord? { get }
    
    func store(correct: Int, total: Int)
    
}

final class StatisticServiceImplementation: StatisticService {
    private enum Keys: String {
        
        case correct, total, bestGame, gamesCount
    }
    var totalAccuracy: Double {
        Double(correct) / Double(total) * 100
    }
    
    private var userDefaults = UserDefaults.standard
    private let date: () -> Date
    
    init (
        userDefaults: UserDefaults = UserDefaults.standard,
        date: @escaping () -> Date = {Date()}
    ) {
        self.userDefaults = userDefaults
        self.date = date
    }
    
    
    
    var total: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var correct: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var gamesCount : Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord? {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let bestGame = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return nil
            }
            
            return bestGame
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    
    
    
    
    
    func store(correct: Int, total: Int) {
        self.correct += correct
        self.total += total
        self.gamesCount += 1
        
        let currentBestGame = GameRecord (correct: correct,
                                          total: total,
                                          date: date())
        
       if let previousBestGame = bestGame {
            
            if currentBestGame > previousBestGame {
                bestGame = currentBestGame
            }
        } else {
            bestGame = currentBestGame
        }
        
    }
    
}

let controller = MovieQuizViewController()

