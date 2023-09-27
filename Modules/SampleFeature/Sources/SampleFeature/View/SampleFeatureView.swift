//
//  SampleFeatureView.swift
//  Sample Feature
//

import SwiftUI

struct SampleFeatureView<ViewModel>: View where ViewModel: SampleFeatureViewModel {
    @StateObject var viewModel: ViewModel

    var body: some View {
        VStack {
            Text("Hello, world!")
                .padding()
        }.onAppear {
            viewModel.onViewLoaded()
        }
    }
}

private extension SampleFeatureView {}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = PreviewSampleFeatureViewModel()
        return SampleFeatureView(viewModel: viewModel)
    }
}
