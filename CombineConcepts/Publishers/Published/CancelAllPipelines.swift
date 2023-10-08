//
//  CancelAllPipelines.swift
//  CombineConcepts
//
//  Created by Yasin Erdemli on 17.09.2023.
//

import SwiftUI
import Combine

class CancelAllPipelinesViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var firstNameValidation: String = ""
    @Published var lastName: String = ""
    @Published var lastNameValidation: String = ""
    private var cancellables: Set<AnyCancellable> = .init()
    
    init() {
        $firstName
            .map { $0.isEmpty ? "❌" : "✅" }
            .sink { [unowned self] value in
                firstNameValidation = value
            }
            .store(in: &cancellables)
        
        $lastName
            .map { $0.isEmpty ? "❌" : "✅" }
            .sink { [unowned self] value in
                lastNameValidation = value
            }
            .store(in: &cancellables)
        
    }
    
    func cancelAll() {
        cancellables.removeAll()
    }
}

struct CancelAllPipelines: View {
    @StateObject private var viewModel: CancelAllPipelinesViewModel = .init()
    var body: some View {
        VStack(spacing: 15) {
            HeaderView("Store", subtitle: "Introduction", desc: "You can use the store function to add your pipeline to a cancellable set")
            HStack {
                TextField("First Name", text: $viewModel.firstName)
                    .textFieldStyle(.roundedBorder)
                Text(viewModel.firstNameValidation)
            }
            .padding()
            
            HStack {
                TextField("Last Name", text: $viewModel.lastName)
                    .textFieldStyle(.roundedBorder)
                Text(viewModel.lastNameValidation)
            }
            .padding()
            
            Button("Cancell All", action: viewModel.cancelAll)
        }
        .font(.title)
    }
}

struct CancelAllPipelines_Previews: PreviewProvider {
    static var previews: some View {
        CancelAllPipelines()
    }
}
