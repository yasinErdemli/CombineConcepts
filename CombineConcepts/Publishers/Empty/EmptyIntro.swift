//
//  EmptyIntro.swift
//  CombineConcepts
//
//  Created by Yasin Erdemli on 17.09.2023.
//

import SwiftUI
import Combine

class EmptyIntroViewModel: ObservableObject {
    @Published var dataToView: [String] = []
    
    func fetch() {
        let dataIn: [String] = ["Value 1","Value 2", "Value 3" , "🧨", "Value 4", "Value5"]
        
        _ = dataIn.publisher
            .tryMap { item in
                if item == "🧨" {
                    throw PublisherError.bombHasBeenFound
                }
                return item
            }
            .catch { error in
                Empty()
            }
            .sink { [unowned self] receivedValue in
                dataToView.append(receivedValue)
            }
    }
}

struct EmptyIntro: View {
    @StateObject private var viewModel: EmptyIntroViewModel = .init()
    var body: some View {
        VStack(spacing: 15) {
            HeaderView("Empty", subtitle: "Intro", desc: "Empty Publisher will send nothing downstream")
            
            List(viewModel.dataToView, id: \.self) { item in
                Text(item)
            }
            .listStyle(.plain)
            
            DescView("Values after 3 can't be send because of an error thrown and sent Empty")
        }
        .font(.title)
        .onAppear {
            viewModel.fetch()
        }
    }
}

struct EmptyIntro_Previews: PreviewProvider {
    static var previews: some View {
        EmptyIntro()
    }
}
