import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func highlightImageBorder(isCorrect: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator(_ hide: Bool)
    func isEnabledButtons(_ isEnabled: Bool)
    func whileWaitDownloadingImage()
    func hideBoarderImage()
}
