import XCTest
import Combine
@testable import ProductListPresentationLayer
@testable import ProductRepositoryLayer

struct MockProduct {
   static let productList: [Product] = [Product(id: 1, title: "iPhone"),
                                        Product(id: 2, title: "Samsung"),
                                        Product(id: 3, title: "Google")]
}
class MockProductDataRepository: ProductRepository {
    enum ResultType {
        case successWithProductList
        case successithEmptyList
        case failure
    }
    let resultType: ResultType
    init(resultType: ResultType = .successWithProductList) {
        self.resultType = resultType
    }
    func fetchProducts() async throws -> [Product] {
        switch resultType {
        case .successWithProductList:
            return MockProduct.productList
        case .successithEmptyList:
            return []
        case .failure:
            throw NSError(domain: "Failed to Load", code: 155)
        }
    }
    func getProducts() -> AnyPublisher<[Product], Error> {
        switch resultType {
        case .successWithProductList:
            return Result.Publisher(MockProduct.productList).eraseToAnyPublisher()
        case .successithEmptyList:
            return Result.Publisher([]).eraseToAnyPublisher()
        case .failure:
            return Result.Publisher(NSError(domain: "Failed to Load", code: 155)).eraseToAnyPublisher()
        }
    }
}
