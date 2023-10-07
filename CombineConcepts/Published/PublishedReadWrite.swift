//
//  PublishedReadWrite.swift
//  CombineConcepts
//
//  Created by Yasin Erdemli on 16.09.2023.
//

import SwiftUI

struct PublishedReadWrite: View {
    @StateObject private var viewModel: PublishedViewModel = .init()
    var body: some View {
        VStack(spacing: 15) {
            HeaderView("@Published", subtitle: "Read&Write", desc: "use dollar sign to create binding")
            
            TextField("state", text: $viewModel.state)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            Text(viewModel.state)
            
            DescView("view will automatically redraw after changes")
        }
        .font(.title)
    }
}

struct PublishedReadWrite_Previews: PreviewProvider {
    static var previews: some View {
        PublishedReadWrite()
    }
}
