//
//  PublishedViewModel.swift
//  CombineConcepts
//
//  Created by Yasin Erdemli on 16.09.2023.
//

import Foundation

class PublishedViewModel: ObservableObject {
    @Published var state = "1st state"
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.state = "2nd State"
        }
    }
    
}
