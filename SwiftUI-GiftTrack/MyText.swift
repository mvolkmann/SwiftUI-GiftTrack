//
//  MyText.swift
//  SwiftUI-GiftTrack
//
//  Created by R. Mark Volkmann on 11/10/21.
//

import SwiftUI

struct MyText: View {
    private let bold: Bool
    private let text: String
    
    init(_ text: String, bold: Bool = false) {
        self.text = text
        self.bold = bold
    }
    
    
    var body: some View {
        Text(text)
            .font(.system(size: 18, weight: bold ? .bold : .regular))
            .foregroundColor(.white)
    }
}
