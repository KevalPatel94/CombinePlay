//
//  ProductItemView.swift
//  CombinePlay
//
//  Created by Keval Patel on 10/17/23.
//

import SwiftUI
import ProductListPresentationLayer

struct ProductItemView: View {
    private enum Constants {
        static let imageSize: CGFloat = 50
        static let oneLineLimit: Int = 1
        static let horizontalStackPadding: CGFloat = 4.0
        static let cornerRadius: CGFloat = 4.0
    }
    let product: ProductPresentationModel
    
    var body: some View {
        HStack {
            leftImageViewBuilder(for: product.images)
            titleAndDescriptionView(for: product.title,
                                    and: product.description)
        }
    }
    
    private func titleAndDescriptionView(for title: String?,
                                         and description: String?) -> some View {
        VStack(alignment: .leading) {
            if !product.title.isEmpty {
                Text(product.title)
                    .font(.title2)
                    .lineLimit(Constants.oneLineLimit)
            }
            if let description = product.brand {
                Text(description)
                    .frame(alignment: .leading)
                    .lineLimit(Constants.oneLineLimit)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(Constants.horizontalStackPadding)
        .frame(minHeight: .zero, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func leftImageViewBuilder(for imageUrlList: [String]?) -> some View {
        if let images = imageUrlList, images.count > .zero {
            if let imageUrlString = images.first, let imageUrl = URL(string: imageUrlString) {
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(width: Constants.imageSize, height: Constants.imageSize)
                .aspectRatio(contentMode: .fit)
                .cornerRadius(Constants.cornerRadius)
            }
        }
    }
}

