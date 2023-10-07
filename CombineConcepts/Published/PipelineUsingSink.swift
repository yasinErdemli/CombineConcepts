//
//  PipelineUsingSink.swift
//  CombineConcepts
//
//  Created by Yasin Erdemli on 17.09.2023.
//

import SwiftUI
import Combine

class PipelineUsingSinkViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var validation: String = ""
    var cancellable: AnyCancellable?
    
    init() {
        cancellable = $text
            .map { $0.isEmpty ? "❌" : "✅" }
            .sink { [weak self] receivedValidation in
                self?.validation = receivedValidation
            }
    }
    
    func cancelSubscription() {
        self.validation = ""
        self.cancellable?.cancel()
    }
}

struct PipelineUsingSink: View {
    @StateObject private var viewModel: PipelineUsingSinkViewModel = .init()
    var body: some View {
        VStack(spacing: 15) {
            HeaderView("Cancellable Pipeline", subtitle: "sink with cancellable", desc: "You can validate data entry in the viewModel using a cancellable with sink operator.")
            HStack {
                TextField("text", text: $viewModel.text)
                    .textFieldStyle(.roundedBorder)
                Text(viewModel.validation)
            }
            .padding()
            
            Button("Cancel Subscription", action: viewModel.cancelSubscription)
            .padding()
        }
        .font(.title)
    }
}

struct PipelineUsingSink_Previews: PreviewProvider {
    static var previews: some View {
        PipelineUsingSink()
    }
}
