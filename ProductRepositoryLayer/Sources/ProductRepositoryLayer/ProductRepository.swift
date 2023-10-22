import Foundation
import Combine
import NetworkRepositoryLayer

public protocol ProductRepository {
    func fetchProducts() async throws -> [Product]
    func getProducts() -> AnyPublisher<[Product], Error>
}

public class ProductDataRepository: ProductRepository {
    private enum Constants {
        static let productListEndPoint = "https://dummyjson.com/products"
        static let invalidURL = "Invalid URL"
    }
    private let urlSession = URLSession.shared
    private let networkRepository: NetworkRepository
    public init(networkRepository: NetworkRepository = NetworkDataRepository.shared) {
        self.networkRepository = networkRepository
    }
    
    public func fetchProducts() async throws -> [Product] {
        //create a new urlRequest passing the url
        guard let url = URL(string: Constants.productListEndPoint) else {
            throw NSError(domain: Constants.invalidURL, code: 101)
        }
        return try await networkRepository.fetch(type: ProductPayLoad.self,
                                       with: URLRequest(url: url)).products
    }

    public func getProducts() -> AnyPublisher<[Product], Error>  {
        return urlSession
             // Not recomendded force unwrapping
            .dataTaskPublisher(for: URL(string: Constants.productListEndPoint)!)
            .tryDecodeResponse(type: ProductPayLoad.self, decoder: JSONDecoder())
            .map{ $0.products }
            .eraseToAnyPublisher()
    }
}
