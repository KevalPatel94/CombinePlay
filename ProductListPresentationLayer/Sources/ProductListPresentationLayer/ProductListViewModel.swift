import Foundation
import SwiftUI
import Combine
import ProductRepositoryLayer

public class ProductListViewModel: ObservableObject {
    private enum Constants {
        static let navigationTitle: String = "Products"
    }
    private let productDataRepository: ProductRepository
    private let productDataToPresentationModelMapper: ProductDataToPresentationModelMapper
    @Published private(set) public var navigationTitle: String = Constants.navigationTitle
    @Published private(set) public var productList: [ProductPresentationModel] = []
    @Published private(set) public var error: Error?
    @Published private(set) public var state: ViewState<[ProductPresentationModel], Error> = .loading
    private var anyCancellable: AnyCancellable?
    public init(productDataRepository: ProductRepository = ProductDataRepository(),
                productDataToPresentationModelMapper: ProductDataToPresentationModelMapper = .init(),
                anyCancellable: AnyCancellable? = nil) {
        self.productDataRepository = productDataRepository
        self.productDataToPresentationModelMapper = productDataToPresentationModelMapper
        self.anyCancellable = anyCancellable
    }
    public func getData() {
         anyCancellable = productDataRepository.getProducts()
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.state = .error(error: error)
                    self?.error = error
                case .finished: break
                    //Do something
                }
            } receiveValue: { [weak self] products in
                guard let self = self else { return }
                self.state = .loaded(data: self.mapAndSortProductList(for: products))
            }
    }
    
    public func fetchProduct() {
        Task {
            do {
                let products = try await productDataRepository.fetchProducts()
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.state = .loaded(data: self.mapAndSortProductList(for: products))
                }
            }
            catch(let error) {
                self.state = .error(error: error)
            }
        }
    }
    
    private func mapAndSortProductList(for products: [Product]) -> [ProductPresentationModel] {
        let presentationModels = productDataToPresentationModelMapper.map(product: products)
        return presentationModels.sorted { $0.title < $1.title }
    }
    
    deinit {
        anyCancellable = nil
    }
}
