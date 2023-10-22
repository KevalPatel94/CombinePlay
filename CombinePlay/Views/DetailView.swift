//
//  DetailView.swift
//  CombinePlay
//
//  Created by Keval Patel on 10/3/23.
//

import SwiftUI
import ProductListPresentationLayer

struct DetailView: View {
    let product: ProductPresentationModel
    var body: some View {
        VStack(alignment: .leading) {
            Text(product.title)
            Text(product.description ?? "")
        }
    }
}

