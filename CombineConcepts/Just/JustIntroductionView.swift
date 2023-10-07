//
//  JustIntroductionView.swift
//  CombineConcepts
//
//  Created by Yasin Erdemli on 07.10.2023.
//

import SwiftUI
import Combine

struct JustIntroductionView: View {
    @State private var vm = JustIntroductionViewModel()
    var body: some View {
        VStack {
            HeaderView("Just", subtitle: "Introduction", desc: "Jut publisher can turn any object into a publisher if it doesn't already have one")
                .layoutPriority(1)
            Text("This week's winner:")
            Text(vm.data)
                .bold()
            
            Form {
                Section {
                    ForEach(vm.dataToView, id: \.self) { item in
                        Text(item)
                    }
                } header: {
                    Text("Contest Participants")
                }
            }
        }
        .font(.headline)
        .task {
            vm.fetch()
        }
    }
}

#Preview {
    JustIntroductionView()
}

@Observable final class JustIntroductionViewModel {
    @ObservationIgnored @Published var data = ""
    var dataToView = Array<String>()
    
    func fetch() {
        let dataIn = ["Bojack Horseman", "Princess Carolyn", "Mister Peanutbutter", "Diane Nyugen", "Judas"]
        
        _ = dataIn.publisher
            .sink(receiveValue: { [unowned self] item in
                dataToView.append(item)
            })
        
        if dataIn.count > 0 {
            Just(dataIn[0])
                .map { item in
                    item.uppercased()
                }
                .assign(to: &$data)
        }
    }
}
