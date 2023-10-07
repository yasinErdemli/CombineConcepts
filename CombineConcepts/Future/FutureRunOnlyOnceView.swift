//
//  FutureRunOnlyOnceView.swift
//  CombineConcepts
//
//  Created by Yasin Erdemli on 07.10.2023.
//

import SwiftUI
import Combine

@Observable class FutureRunOnlyOnceViewModel {
    var firstResult = ""
    var secondResult = ""
    
    @ObservationIgnored var cancellables = Set<AnyCancellable>()
    
    let futurePublisher = Future<String,Never> { promise in
        promise(.success("Future Publisher has run"))
        print("Publisher has run")
    }
    
    func fetch() {
        futurePublisher
            .sink { [unowned self] result in
                firstResult = result
            }
            .store(in: &cancellables)
    }
    
    func runAgain() {
        futurePublisher
            .sink { [unowned self] result in
                secondResult = result
            }
            .store(in: &cancellables)
    }
}

struct FutureRunOnlyOnceView: View {
    @State private var viewModel = FutureRunOnlyOnceViewModel()
    var body: some View {
        VStack {
            HeaderView("Future", subtitle: "Runs Only Once", desc: "Future publisher will only run once and never again. It will store it's value and sink it only.")
            Text(viewModel.firstResult)
            Button("Run Again", action: viewModel.runAgain)
            Text(viewModel.secondResult)
        }
        .task {
            viewModel.fetch()
        }
    }
}

#Preview {
    FutureRunOnlyOnceView()
}
