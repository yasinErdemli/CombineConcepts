//
//  PublishedValidationWithViewModel.swift
//  CombineConcepts
//
//  Created by Yasin Erdemli on 17.09.2023.
//

import SwiftUI

class PublishedValidationWithViewModelViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var message: String = ""
    
    init() {
        $text
            .map { $0.isEmpty ? "❌" : "✅" }
            .assign(to: &$message)
    }
}

struct PublishedValidationWithViewModel: View {
    @StateObject private var viewModel: PublishedValidationWithViewModelViewModel = .init()
    var body: some View {
        VStack(spacing: 15) {
            HeaderView("Published", subtitle: "validation on viewModel", desc: "You can validate data entry in the viewModel")
            HStack {
                TextField("text", text: $viewModel.text)
                    .textFieldStyle(.roundedBorder)
                Text(viewModel.message)
            }
            .padding()
        }
    }
}

struct PublishedValidationWithViewModel_Previews: PreviewProvider {
    static var previews: some View {
        PublishedValidationWithViewModel()
    }
}
