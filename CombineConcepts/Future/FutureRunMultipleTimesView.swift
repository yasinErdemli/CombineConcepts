//
//  FutureRunMultipleTimesView.swift
//  CombineConcepts
//
//  Created by Yasin Erdemli on 07.10.2023.
//

import SwiftUI
import Combine

struct FutureRunMultipleTimesView: View {
    @State private var vm = FutureRunMultipleTimesViewModel()
    var body: some View {
        VStack {
            HeaderView("Future", subtitle: "Run multiple times", desc: "Future publishers execute one time and execute immediately. To change this behavior you can use the Deferred publisher which will wait until a subscriber is attached before letting the Future execute and publish")
            Text(vm.firstResult)
            Button("Run Again", action: vm.runAgain)
            Text(vm.secondResult)
        }
        .task {
            vm.fetch()
        }
    }
}

#Preview {
    FutureRunMultipleTimesView()
}

@Observable class FutureRunMultipleTimesViewModel {
    var firstResult = ""
    var secondResult = ""
    @ObservationIgnored var cancellables = Set<AnyCancellable>()
    
    let deferredFuturePublisher = Deferred {
        Future<String,Never> { promise in
            promise(.success("Futur publisher has run"))
            print("publisher has run")
        }
    }
    
    func fetch() {
        deferredFuturePublisher
            .sink { [unowned self] value in
                firstResult = value
            }
            .store(in: &cancellables)
    }
    
    func runAgain() {
        deferredFuturePublisher
            .sink { [unowned self] value in
                secondResult = value
            }
            .store(in: &cancellables)
    }
}
