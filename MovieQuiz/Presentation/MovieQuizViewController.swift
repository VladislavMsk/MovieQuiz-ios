import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenter(delegate: self)
        statisticService = StatisticServiceImplementation(userDefaults: Foundation.UserDefaults.standard,decoder: JSONDecoder(), encoder: JSONEncoder(), dateProvider: { Date() } )
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion?.correctAnswer)}
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion?.correctAnswer)}
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticService?
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel (
            imageView: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionAmount)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.imageView
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderWidth = 0
    }
    
    private func showAlert() {
        statisticService?.store(correct: correctAnswers, total: questionAmount)
        guard let statisticService = statisticService else {
            assertionFailure("error 1")
            return
        }
        guard let bestGame = statisticService.bestGame else {
            assertionFailure("error 2")
            return
        }
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message:
            """
            Количество сыгранных квизов: \(statisticService.gamesCount)
            Ваш результат: \(correctAnswers)\\\(questionAmount)
            Рекорд: \(bestGame.correct)\\\(bestGame.total) \(bestGame.date.dateTimeString)
            Средняя точность \(String(format: "%.2f",statisticService.totalAccuracy))%
            """,
            buttonText: "Сыграть ещё раз",
            completion: { [weak self] in

                self?.currentQuestionIndex = 0
                self?.correctAnswers = 0
                self?.questionFactory?.requestNextQuestion()
            })
        alertPresenter?.showQuizResult(model: alertModel)
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionAmount - 1 {
            showAlert()
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        noButton.isEnabled = false
        yesButton.isEnabled = false
        if isCorrect {
            correctAnswers += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
        }
    }
}

extension MovieQuizViewController: QuestionFactoryDelegate {
    func didRecieveQuestion(_ question: QuizQuestion) {
        self.currentQuestion = question
        let viewModel = self.convert(model: question)
        self.show(quiz: viewModel)
    }
}

/*
final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Lifecycle

    private let questionAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(delegate: self)
        
        questionFactory?.requestNextQuestion()
        
        let alert = UIAlertController(title: "Этот раунд окончен"
                                       , message: "Ваш результат ?",
                                       preferredStyle: .alert)
         let action = UIAlertAction(title: "Сыграть еще раз", style: .default){
             _ in
             self.currentQuestionIndex = 0
             self.correctAnswers = 0
             
             //let index = self.currentQuestionIndex
             //let firstQustion = self.questions[index]
             //let viewModel = self.convert(model: firstQustion)
             //self.show(quiz: viewModel)
         }
         alert.addAction(action)

         self.present(alert, animated: true, completion: nil)

}
    // MARK: - QuestionFactoryDelegate
    
    func didReciveNextQuestion(question: QuizQuestion?) {
        guard let question = question else{
        return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async {
            [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel{
        let questionStep = QuizStepViewModel(
            imageView: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1) / \(questionAmount)"
        )
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel){
        imageView.image = step.imageView
        
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
   
    
    private func showNextQuestionOrResults(){
        if currentQuestionIndex == questionAmount - 1 {
            let text = correctAnswers == questionAmount ?
                    "Поздравляем, Вы ответили на 10 из 10!" :
                    "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!",
                                                 text: text,
                                                 buttonText: "Сыграть еще раз")
            show(quiz: viewModel)

        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showAnswerResult(isCorrect: Bool){
        imageView.layer.masksToBounds = true // 1
        imageView.layer.borderWidth = 8 // 2
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        
        if isCorrect {correctAnswers += 1}
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [ weak self ] in
            guard let self = self else { return }
           // код, который мы хотим вызвать через 1 секунду
           self.showNextQuestionOrResults()
           self.imageView.layer.borderWidth = 0 // 2
        }
    }

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBAction private func yeaButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else{
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else{
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    print("Нет")
    }
    
}



*/
