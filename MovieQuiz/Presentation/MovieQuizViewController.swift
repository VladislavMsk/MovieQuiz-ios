import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    struct QuizQuestion{
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    struct QuizStepViewModel {
        let imageView:UIImage
        let question: String
        let questionNumber: String
    }
    
    struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
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
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel{
        let questionStep = QuizStepViewModel(
            imageView: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1) / \(questions.count)"
        )
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel){
        imageView.image = step.imageView
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func showNextQuestionOrResults(){
        if currentQuestionIndex == questions.count - 1{
            let text = "Ваш результат: \(correctAnswers)/10"
            let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!",
                                                 text: text,
                                                 buttonText: "Сыграть еще раз")
            show(quiz: viewModel)

        } else {
            currentQuestionIndex += 1
            
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
        }
    }
    
    private func showAnswerResult(isCorrect: Bool){
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.cornerRadius = 6 // радиус скругления углов рамки - но вроде не нужан, либо ошибка в уроке
        if isCorrect{
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswer += 1
        } else{
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
           // код, который мы хотим вызвать через 1 секунду
           self.showNextQuestionOrResults()
        }
    }
    

    

    
    
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBAction func yeaButtonClicked(_ sender: Any) {
        if questions[currentQuestionIndex].correctAnswer == true{
            showAnswerResult(isCorrect: true)
        } else{
            showAnswerResult(isCorrect: false)
        }
    }
    
    @IBAction func noButtonClicked(_ sender: Any) {
        if questions[currentQuestionIndex].correctAnswer == false{
            showAnswerResult(isCorrect: true)
        } else{
            showAnswerResult(isCorrect: false)
        }
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1
         let alert = UIAlertController(title: "Этот раунд окончен"
                                       , message: "Ваш результат ?",
                                       preferredStyle: .alert)
         
         let action = UIAlertAction(title: "Сыграть еще раз", style: .default){
             _ in
             self.currentQuestionIndex = 0
             self.correctAnswer = 0
             
             let index = self.currentQuestionIndex
             let firstQustion = self.questions[index]
             let viewModel = self.convert(firstQustion)
             self.show(quiz: viewModel)
         }
         alert.addAction(action)

         self.present(alert, animated: true, completion: nil)
        
    }
}



