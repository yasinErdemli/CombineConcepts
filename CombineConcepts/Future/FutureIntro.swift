//
//  FutureIntro.swift
//  CombineConcepts
//
//  Created by Yasin Erdemli on 17.09.2023.
//

import SwiftUI
import Combine
import StoreKit

class FutureIntroViewModel: ObservableObject {
    @Published var hello: String = ""
    @Published var goodbye: String = ""
    private var cancellable: AnyCancellable?
    
    func sayHello() {
        Future<String,Never> { promise in
            promise(.success("Hello!"))
        }
        .assign(to: &$hello)
    }
    
    func sayGoodbye() {
        let featurePublisher = Future<String,Never> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                promise(.success("Goodbye!"))
            }
        }
        
        cancellable = featurePublisher
            .sink { [unowned self] goodbye in
                self.goodbye = goodbye
            }
    }
}

struct FutureIntro: View {
    @StateObject private var viewModel = FutureIntroViewModel()
    var body: some View {
        VStack(spacing: 15) {
            HeaderView("Future", subtitle: "Intro", desc: "Future publisher can only publish once")
            Button("Say Hello", action: viewModel.sayHello)
            Text(viewModel.hello)
                .padding(.bottom)
            Button("Say Goodbye", action: viewModel.sayGoodbye)
            Text(viewModel.goodbye)
        }
    }
}

struct FutureIntro_Previews: PreviewProvider {
    static var previews: some View {
        FutureIntro()
    }
}
