//
//  FailIntro.swift
//  CombineConcepts
//
//  Created by Yasin Erdemli on 17.09.2023.
//

import SwiftUI
import Combine


struct Validators {
    static func validAgePublisher(age: Int) -> AnyPublisher<Int,InvalidAgeError> {
        if age < 0 {
            return Fail(error: InvalidAgeError.lessThanZero)
                .eraseToAnyPublisher()
        } else if age > 100 {
            return Fail(error: InvalidAgeError.moreThanHundred)
                .eraseToAnyPublisher()
        } else {
            return Just(age)
                .setFailureType(to: InvalidAgeError.self)
                .eraseToAnyPublisher()
        }
    }
}

class FailIntroViewModel: ObservableObject {
    @Published var age: Int = 0
    @Published var error: InvalidAgeError?
    @Published var didError: Bool = false
    
    func save(age: Int) {
        _ = Validators.validAgePublisher(age: age)
            .sink { [unowned self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                    self.didError = true
                }
            } receiveValue: { [unowned self] age in
                self.age = age
            }
    }
    
   
}

struct FailIntro: View {
    @StateObject private var viewModel: FailIntroViewModel = .init()
    @State private var age: String = ""
    var body: some View {
        VStack(spacing: 15) {
            HeaderView("Fail", subtitle: "Intro", desc: "Fail publisher publishes an error and close the pipeline")
            
            TextField("Age", text: $age)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            Button("Save") {
                viewModel.save(age: Int(age) ?? -1)
            }
            
            Text(viewModel.age.description)
        }
        .font(.title)
        .alert("Age Error", isPresented: $viewModel.didError, presenting: viewModel.error) { _ in
            Button("Cancel") {
                
            }
        } message: { errorMessage in
            Text(errorMessage.localizedDescription)
        }

    }
}

struct FailIntro_Previews: PreviewProvider {
    static var previews: some View {
        FailIntro()
    }
}

enum InvalidAgeError: Error, LocalizedError {
    case lessThanZero, moreThanHundred
    
    var errorDescription: String? {
        switch self {
        case .lessThanZero:
            return NSLocalizedString("The number you entered is less than the accepted value of 0!", comment: "lessThanZero")
        case .moreThanHundred:
            return NSLocalizedString("The number you entered is more than the accepted value of 100!", comment: "moreThanHundred")
        }
    }
}

