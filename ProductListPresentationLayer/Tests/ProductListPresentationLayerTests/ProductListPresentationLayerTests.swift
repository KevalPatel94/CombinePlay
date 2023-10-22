import XCTest
import Combine
@testable import ProductListPresentationLayer
@testable import ProductRepositoryLayer

final class ProductListPresentationTests: XCTestCase {
    var productRepository: MockProductDataRepository!
    override func setUp() async throws {
        self.productRepository = MockProductDataRepository()
    }
    func testFetchProductSuccess() async throws {
        let products = try await productRepository.fetchProducts()
        XCTAssertEqual(products.count, 3)
    }
    
    func testFetchProductEmptyListSuccess() async throws {
        productRepository = MockProductDataRepository(resultType: .successithEmptyList)
        let products = try await productRepository.fetchProducts()
        XCTAssertTrue(products.isEmpty)
    }
    func testFetchProductFailure() async {
        productRepository = MockProductDataRepository(resultType: .failure)
        do {
            let _ = try await productRepository.fetchProducts()
        }
        catch {
            XCTAssertNotNil(error)
        }
    }
    
    func testGetProductsSuccess() {
        let _ = productRepository.getProducts().sink { _ in } receiveValue: { products in
            XCTAssertEqual(products.count, 3)
        }
    }
    
    func testGetProductsEmptyListSuccess() {
        productRepository = MockProductDataRepository(resultType: .successithEmptyList)
        let _ = productRepository.getProducts().sink { _ in } receiveValue: { products in
            XCTAssertTrue(products.isEmpty)
        }
    }
    
    func testGetProductsEmptyFailure() {
        productRepository = MockProductDataRepository(resultType: .failure)
        let _ = productRepository.getProducts().sink { completion in
            switch completion {
            case .failure(let error):
                XCTAssertNotNil(error)
            case .finished: break
            }
        } receiveValue: { _ in }
    }
}
