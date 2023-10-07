//
//  LongRunningProcess.swift
//  CombineConcepts
//
//  Created by Yasin Erdemli on 17.09.2023.
//

import SwiftUI
import Combine

class LongRunningProcessViewModel: ObservableObject {
    @Published var data: String = "Start Data"
    @Published var status: String = ""
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = $data
            .map { [unowned self] value -> String in
                status = "Processing..."
                return value
            }
            .delay(for: 5, scheduler: RunLoop.main)
            .sink { [unowned self] value in
                status = "Finished"
            }
    }
    
    func refreshData() {
        data = "Refreshed Data"
    }
    
    func cancel() {
        status = "Cancelled"
        cancellable?.cancel()
    }
}

struct LongRunningProcess: View {
    @StateObject private var viewModel: LongRunningProcessViewModel = .init()
    var body: some View {
        VStack(spacing: 15) {
            HeaderView("Cancellable Pipeline", subtitle: "Long-Running", desc: "You can cancel the operator while it is running.")
            
            Text(viewModel.data)
            
            Button("Refresh Data", action: viewModel.refreshData)
            
            Button("Cancel Subscription", action: viewModel.cancel)
                .opacity(viewModel.status == "Processing..." ? 1 : 0)
            Text(viewModel.status)
        }
        .font(.title)
    }
}

struct LongRunningProcess_Previews: PreviewProvider {
    static var previews: some View {
        LongRunningProcess()
    }
}
