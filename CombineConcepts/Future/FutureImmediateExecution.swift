//
//  FutureImmediateExecution.swift
//  CombineConcepts
//
//  Created by Yasin Erdemli on 07.10.2023.
//

import SwiftUI
import Combine

@Observable class FutureImmediateExecutionViewModel {
    var data = ""
    
    func fetch() {
        _ = Future<String, Never> { [unowned self ] promise in
            data = "Hello my friend"
        }
    }
}

struct FutureImmediateExecution: View {
    @State private var viewModel = FutureImmediateExecutionViewModel()
    var body: some View {
        VStack {
            HeaderView("Future", subtitle: "Immediate Execution", desc: "Future publishers can execute immedietly whether they have subscribers or not, unlike all the other publishers")
            
            Text(viewModel.data)
        }
        .font(.title)
        .task {
            viewModel.fetch()
        }
    }
}

#Preview {
    FutureImmediateExecution()
}
