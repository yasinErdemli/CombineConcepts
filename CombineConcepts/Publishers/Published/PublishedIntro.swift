//
//  PublishedIntro.swift
//  CombineConcepts
//
//  Created by Yasin Erdemli on 16.09.2023.
//

import SwiftUI



struct PublishedIntro: View {
    @StateObject private var viewModel: PublishedViewModel = .init()
    var body: some View {
        VStack(spacing: 15) {
            HeaderView("@Published",subtitle: "Introduction",desc: "The @Published property wrapper with the ObservableObject is the publisher. It sends out a message to the view whenever its value has changed. The StateObject property wrapper helps to make the view the subscriber.")
            
            Text(viewModel.state)
            
            DescView("After one second the view updates")
        }
        .font(.title)
    }
}

struct PublishedIntro_Previews: PreviewProvider {
    static var previews: some View {
        PublishedIntro()
    }
}
