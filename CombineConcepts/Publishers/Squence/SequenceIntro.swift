//
//  SequenceIntro.swift
//  CombineConcepts
//
//  Created by Yasin Erdemli on 07.10.2023.
//

import SwiftUI
import Combine

struct SequenceIntro: View {
    @State private var vm = SequenceIntroViewModel()
    var body: some View {
        VStack {
            HeaderView("Sequence", subtitle: "Intro", desc: "Arrays have a built in sequence publisher property, so a pipeline can be constructed on an array right away.")
            List(vm.dataToView, id: \.self) { item in
                Text(item)
            }
        }
        .font(.headline)
        .task {
            vm.fetch()
        }
    }
}

#Preview {
    SequenceIntro()
}

@Observable final class SequenceIntroViewModel {
    var dataToView = Array<String>()
    @ObservationIgnored var cancellables = Set<AnyCancellable>()
    
    func fetch() {
        var dataIn = ["Alice", "Bob", "Charlie", "David", "Eve", "Frank", "Grace", "Hannah", "Isaac", "Jack"]
        
        dataIn.publisher
            .sink { completion in
                print(completion)
            } receiveValue: { [unowned self] item in
                dataToView.append(item)
                print(item)
            }
            .store(in: &cancellables)

        dataIn.append(contentsOf: ["Liam", "Jennifer"])
    }
}
