//
//  DescView.swift
//  CombineConcepts
//
//  Created by Yasin Erdemli on 16.09.2023.
//

import SwiftUI

struct DescView: View {
    let desc: String
    
    init(_ desc: String) {
        self.desc = desc
    }
    var body: some View {
        Text(desc)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color("Gold"))
            .foregroundStyle(.white)
    }
}

struct DescView_Previews: PreviewProvider {
    static var previews: some View {
        DescView("Description")
    }
}
