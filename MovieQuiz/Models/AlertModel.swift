//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Vladislav Tudos on 16.08.2023.
//

import Foundation
import UIKit

struct AlertModel{
    let title: String
    let message: String
    let buttonText: String
    
    let completion: () -> Void
}
