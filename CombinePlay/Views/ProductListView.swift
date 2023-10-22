//
//  ContentView.swift
//  CombinePlay
//
//  Created by Keval Patel on 10/3/23.
//

import SwiftUI
import Combine
import ProductListPresentationLayer

struct ProductListView: View {
    @State private var product: ProductPresentationModel?
    @ObservedObject private var viewModel = ProductListViewModel()
    var body: some View {
        NavigationView {
            ScrollView  {
                switch viewModel.state {
                case .loading:
                    EmptyView()
                case .loaded(data: let products):
                    loadedView(for: products)
                case .error(error: _):
                    EmptyView()
                case .empty:
                    EmptyView()
                }
            }
            .navigationTitle(viewModel.navigationTitle)
        }
        .accentColor(.black)
        .padding()
        .onAppear {
            viewModel.fetchProduct()
        }
    }
    
    private func loadedView(for products: [ProductPresentationModel]) -> some View {
        LazyVStack(alignment: .leading) {
            listView(for: products)
        }
        .padding()
    }
    
    private func listView(for products: [ProductPresentationModel]) -> some View {
        ForEach(products, id: \.id) { product in
            NavigationLink {
                DetailView(product: product)
            } label: {
                HStack {
                    ProductItemView(product: product)
                        .foregroundColor(.black)
                        .frame(alignment: .leading)
                }
            }
            .frame(minWidth: .zero, maxWidth: .infinity, alignment: .leading)
        }
    }
    
}

struct EmptyView: View {
    var body: some View {
        Text("No Data to display")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView()
    }
}
