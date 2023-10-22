
import Foundation

public enum ViewState<T: Equatable, E: Error> {
    case loaded(data: T)
    case loading
    case empty
    case error(error: E)
}
