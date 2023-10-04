//
//  ContentView.swift
//  Modular Analytics POC
//

import SwiftUI
import SampleFeature

struct ContentView: View {
    var body: some View {
        makeInitialView()
    }
}

private extension ContentView {
    func makeInitialView() -> some View {
        SampleFeatureFactory.makeInitialView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
