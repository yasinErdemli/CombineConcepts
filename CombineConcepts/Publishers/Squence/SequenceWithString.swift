//
//  SequenceWithString.swift
//  CombineConcepts
//
//  Created by Yasin Erdemli on 07.10.2023.
//

import SwiftUI
import Combine

struct SequenceWithString: View {
    @State var vm = SequenceWithStringViewModel()
    var body: some View {
        VStack {
            HeaderView("Sequence", subtitle: "With String", desc: "Strings also have their own publisher built in, this takes each charachter of the string as an item of collection")
            List(vm.dataToView, id: \.self) { item in
                Text(item)
            }
        }
        .font(.title)
        .task {
            vm.fetch()
        }
    }
}

#Preview {
    SequenceWithString()
}

@Observable final class SequenceWithStringViewModel {
    var dataToView = Array<String>()
    @ObservationIgnored var cancellable: AnyCancellable?
    
    func fetch() {
        let dataIn = "Hello World!"
        
        cancellable = dataIn.publisher
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { [unowned self] item in
                dataToView.append(String(item))
            })
    }
}
