import Foundation

protocol AlertDelegate: AnyObject {
    func show(model: AlertModel?)
}
