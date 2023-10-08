//
//  TimerIntro.swift
//  CombineConcepts
//
//  Created by Yasin Erdemli on 08.10.2023.
//

import SwiftUI
import Combine

struct TimerIntro: View {
    @State private var vm = TimerIntroViewModel()
    var body: some View {
        VStack {
            HeaderView("Timer", subtitle: "Introduction", desc: "Timer continously publishes the updated date and time at any interval you desire")
            Text("Adjust interval")
            Slider(value: $vm.interval, in: 0...1) {
                Text("Interval")
            } minimumValueLabel: {
                Image(systemName: "hare")
            } maximumValueLabel: {
                Image(systemName: "tortoise")
            }
            .padding()
            
            List(vm.data, id: \.self) { datum in
                Text(datum)
            }
        }
        .font(.title)
        .task {
            vm.start()
        }
    }
}

#Preview {
    TimerIntro()
}

@Observable final class TimerIntroViewModel {
    var data = Array<String>()
    @ObservationIgnored @Published var interval: Double = 1
    @ObservationIgnored private var timerCancellable: AnyCancellable?
    @ObservationIgnored private var intervalCancellable: AnyCancellable?
    let timeformatter = DateFormatter()
    
    init() {
        timeformatter.dateFormat = "HH:mm:ss.SSS"
        
        intervalCancellable = $interval
            .dropFirst()
            .sink(receiveValue: { [unowned self] value in
                timerCancellable?.cancel()
                data.removeAll()
                start()
            })
    }
    
    func start() {
        timerCancellable = Timer
            .publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { [unowned self] datum in
                data.append(timeformatter.string(from: datum))
            })
    }
}
