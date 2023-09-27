//
//  SampleFeatureFactory.swift
//  Sample Feature
//

import SwiftUI

public struct SampleFeatureFactory {

    static func makeInitialView() -> some View {
        // TODO: Make Use Cases
        // TODO: Make View Model
        // TODO: Make View
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}
