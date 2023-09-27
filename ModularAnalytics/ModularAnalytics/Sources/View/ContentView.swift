//
//  ContentView.swift
//  Modular Analytics POC
//

import SwiftUI
import SampleFeature

struct ContentView: View {
    var body: some View {
        SampleFeatureFactory.makeInitialView()
                .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
