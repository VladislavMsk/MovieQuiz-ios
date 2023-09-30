//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Vladislav Tudos on 16.08.2023.
//

import Foundation
import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    private weak var delegate: UIViewController?
    
    init (delegate: UIViewController) {
        self.delegate = delegate
    }
    func showQuizResult(model: AlertModel) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText,style: .default) { _ in model.completion()}
        alert.addAction(action)
        delegate?.present(alert, animated: true, completion: nil)

    }
}

