//
//  HeaderView.swift
//  CombineConcepts
//
//  Created by Yasin Erdemli on 16.09.2023.
//

import SwiftUI

struct HeaderView: View {
    let title: String
    let subtitle: String
    let desc: String
    
    init(_ title: String, subtitle: String, desc: String) {
        self.title = title
        self.subtitle = subtitle
        self.desc = desc
    }
    
    var body: some View {
        VStack(spacing: 15) {
            if !title.isEmpty {
                Text(title)
                    .font(.largeTitle)
            }
            
            Text(subtitle)
                .foregroundStyle(.gray)
            
            DescView(desc)
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView("Title", subtitle: "Subtitle", desc: "Desc")
    }
}
