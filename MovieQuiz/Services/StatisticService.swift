import Foundation



final class StatisticServiceImpl {
    //MARK: - Privates Properties
    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let dateProvider: () -> Date
    
    //MARK: - Init
    init(userDefaults: UserDefaults = .standard,
         encoder: JSONEncoder = JSONEncoder(),
         decoder: JSONDecoder = JSONDecoder(),
         dateProvider: @escaping () -> Date = { Date() }
    ){
        self.userDefaults = userDefaults
        self.encoder = encoder
        self.decoder = decoder
        self.dateProvider = dateProvider
    }
}

extension StatisticServiceImpl: StatisticService {
    
    //MARK: - Public Properties
    var totalAccuracy: Double {
        Double(correct) / Double(total) * 100
    }
    
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gameCount.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.gameCount.rawValue)
        }
    }
    
    private var correct: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    private var total: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var bestGame: BestGame? {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? decoder.decode(BestGame.self, from: data) else {
                return nil
            }
            return record
        }
        
        set {
            guard let data = try? encoder.encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    //MARK: - Public Methods
    func store(correct count: Int, total amount: Int) {
        self.correct = count
        self.total = amount
        self.gamesCount += 1
        let date = dateProvider()
        
        let current = BestGame(correct: correct, total: total, date: date)
        
        if let previosBestGame = bestGame {
            if current > previosBestGame {
                bestGame = current
            }
        } else {
            bestGame = current
        }
    }
    
    //MARK: - Private Enum
    private enum Keys: String {
        case correct, total, bestGame, gameCount
    }
}
