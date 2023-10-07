//
//  PublishedValidation.swift
//  CombineConcepts
//
//  Created by Yasin Erdemli on 16.09.2023.
//

import SwiftUI

struct PublishedValidation: View {
    @StateObject private var viewModel: PublishedViewModel = .init()
    @State private var message: String = ""
    var body: some View {
        VStack(spacing: 15) {
            HeaderView("Published", subtitle: "OnChange", desc: "You can validate data entry with onChange, but better make this in your view model")
            HStack {
                TextField("state", text: $viewModel.state)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: viewModel.state) { oldValue, newValue in
                        message = newValue.isEmpty ? "❌" : "✅"
                    }
                Text(message)
            }
            .padding()
        }
    }
}

struct PublishedValidation_Previews: PreviewProvider {
    static var previews: some View {
        PublishedValidation()
    }
}
