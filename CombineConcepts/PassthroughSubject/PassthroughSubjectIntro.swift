//
//  PassthroughSubjectIntro.swift
//  CombineConcepts
//
//  Created by Yasin Erdemli on 07.10.2023.
//

import SwiftUI
import Combine

struct PassthroughSubjectIntro: View {
    @State private var vm = PassthroughSubjectViewModel()
    var body: some View {
        VStack {
            HeaderView("PassthroughSubject", subtitle: "Intro", desc: "PassthroughSubject publisher will send a value through pipeline but will not retain it's value")
            
            HStack {
                TextField("Credit Card Number", text: $vm.creditCard)
                Group {
                    switch vm.status {
                    case .ok:
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    case .invalid:
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.red)
                    case .notEvaluated:
                        EmptyView()
                    }
                }
            }
            .padding()
            
            Button("Verify Number") {
                vm.verifyCreditCard.send(vm.creditCard)
            }
        }
    }
}

#Preview {
    PassthroughSubjectIntro()
}

@Observable final class PassthroughSubjectViewModel {
    var creditCard = ""
    var status = CreditCardStatus.notEvaluated
    @ObservationIgnored var cancellable: AnyCancellable?
    let verifyCreditCard = PassthroughSubject<String,Never>()
    
    init() {
        cancellable = verifyCreditCard
            .map { creditCard -> CreditCardStatus in
                if creditCard.count == 16 {
                    return .ok
                } else {
                    return .invalid
                }
            }
            .sink(receiveValue: { [unowned self] status in
                self.status = status
            })
        
    }
}

enum CreditCardStatus {
    case ok, invalid, notEvaluated
}


