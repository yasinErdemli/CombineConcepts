//
//  CurrentValueSubjectIntro.swift
//  CombineConcepts
//
//  Created by Yasin Erdemli on 17.09.2023.
//

import SwiftUI
import Combine

class CurrentValueSubjectIntroViewModel: ObservableObject {
    @Published var selection: String = "Starting Value"
    var selectionSame: CurrentValueSubject<Bool,Never> = .init(false)
    var cancellables: Set<AnyCancellable> = .init()
    
    init() {
        $selection
            .map { [unowned self] newValue -> Bool in
                newValue == selection
            }
            .sink { [unowned self] value in
                selectionSame.value = value
                objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    func selectYasin() {
        selection = "Yasin"
    }
    
    func selectAlyona() {
        selection = "Alyona"
    }
}

struct CurrentValueSubjectIntro: View {
    @StateObject private var viewModel: CurrentValueSubjectIntroViewModel = .init()
    var body: some View {
        VStack(spacing: 15) {
            HeaderView("CurrentValueSubject", subtitle: "Intro", desc: "This publisher works like @Published and mainly used for non-SwiftUI apps.")
            
            Button("Select Yasin", action: viewModel.selectYasin)
            Button("Select Alyona", action: viewModel.selectAlyona)
            
            Text(viewModel.selection)
                .foregroundStyle(viewModel.selectionSame.value ? .red : .green)
        }
        .font(.title)
    }
}

struct CurrentValueSubjectIntro_Previews: PreviewProvider {
    static var previews: some View {
        CurrentValueSubjectIntro()
    }
}
