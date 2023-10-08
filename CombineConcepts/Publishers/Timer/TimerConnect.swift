//
//  TimerConnect.swift
//  CombineConcepts
//
//  Created by Yasin Erdemli on 08.10.2023.
//

import SwiftUI
import Combine

struct TimerConnect: View {
    @State private var vm = TimerConnectViewModel()
    var body: some View {
        VStack {
            HeaderView("Timer", subtitle: "Connect", desc: "Instead of using autoconnect, you can manually connect the timer and disconnect.")
            HStack {
                Button("Start", action: vm.start)
                Button("Stop", action: vm.stop)
            }
            List(vm.data, id: \.self) { item in
                Text(item)
            }
        }
    }
}

#Preview {
    TimerConnect()
}

@Observable final class TimerConnectViewModel {
    var data = Array<String>()
    private var timerPublisher = Timer.publish(every: 0.2, on: .main, in: .common)
    private var timerCancellable: Cancellable?
    private var cancellables = Set<AnyCancellable>()
    private let timeFormatter = DateFormatter()
    init() {
        timeFormatter.dateFormat = "HH:mm:ss.SSS"
        
        timerPublisher
            .sink { [unowned self] datum in
                data.append(timeFormatter.string(from: datum))
            }
            .store(in: &cancellables)
    }
    
    func start() {
        timerCancellable = timerPublisher.connect()
    }
    
    func stop() {
        timerCancellable?.cancel()
        data.removeAll()
    }
}
