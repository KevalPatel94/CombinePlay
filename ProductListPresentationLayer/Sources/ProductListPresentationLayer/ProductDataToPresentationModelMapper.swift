import ProductRepositoryLayer

public struct ProductDataToPresentationModelMapper {
    public init() {}
    public func map(product: [Product]) -> [ProductPresentationModel] {
        return product.map {
            ProductPresentationModel(id: $0.id,
                                     title: $0.title ?? "",
                                     description: $0.description,
                                     brand: $0.brand,
                                     images: $0.images)
        }
    }
}
