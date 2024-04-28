//
//  TestView.swift
//  BuildingATipJar
//
//  Created by Marcin Jędrzejak on 29/04/2024.
//

import SwiftUI
import StoreKit

struct TestView: View {

    @State private var myProduct: Product?

    var body: some View {
        VStack {
            Text("Product Info")
            Text(myProduct?.displayName ?? "")
            Text(myProduct?.description ?? "")
            Text(myProduct?.displayPrice ?? "")
            Text(myProduct?.price.description ?? "")
        }
        .task {
            myProduct = try? await Product.products(for: ["mj.BuildingATipJar.TinyTip"]).first
        }
    }
}

#Preview {
    TestView()
}
