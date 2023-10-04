//
//  SampleFeatureView.swift
//  Sample Feature
//

import SwiftUI

struct SampleFeatureView<ViewModel>: View where ViewModel: SampleFeatureViewModel {
    @ObservedObject var viewModel: ViewModel
    @State private var internalPassword: String = ""

    var body: some View {
        ZStack {
            //  Main View:
            VStack {
                Spacer()
                Text(title)
                    .font(.title)
                    .padding()

                GroupBox(content: {
                    TextField("Type in a password", text: $internalPassword)
                        .padding()
                        .disableAutocorrection(true)
                        .background(RoundedRectangle(cornerRadius: 5).fill(.gray.opacity(0.2)))
                }, label: {
                    Text("Password:")
                        .font(.body)
                        .padding()
                })

                HStack {
                    Spacer()
                    Button("Generate") {
                        Task {
                            await viewModel.generatePasswordRequested()
                        }
                    }
                    .padding()
                    .disabled(isLoading)

                    Spacer()

                    Button("Save") {
                        Task {
                            await viewModel.storePasswordRequested(password: internalPassword)
                        }
                    }
                    .padding()
                    .disabled(isLoading || internalPassword.isEmpty)

                    Spacer()
                }
                Spacer()
            }

            //  Preloader:
            if isLoading {
                VStack {
                    LoaderView(configuration: .default)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.opacity(0.5))
            }
        }
        .onChange(of: viewModel.viewState) {
            handleStateChange($0)
        }
        .onAppear {
            Task {
                await viewModel.onViewLoaded()
            }
        }
        .alert(isPresented: .init(get: { error != nil }, set: { _ in })) {
            Alert(
                title: Text("Error!"),
                message: Text("An error has occurred \(error ?? "unknown error")"),
                dismissButton: .cancel(Text("OK"), action: {
                    Task {
                        await viewModel.storePasswordRequested(password: internalPassword)
                    }
                })
            )
        }
    }
}

private extension SampleFeatureView {

    var viewState: SampleFeatureViewState {
        viewModel.viewState
    }

    var title: String {
        switch viewState {
        case .passwordRetrieved:
            return "Current password:"
        case .noPasswordSet, .settingPassword, .passwordGenerated:
            return "Set password:"
        case .loading:
            return "Loading..."
        case .error:
            return "Ooops!"
        }
    }

    var error: String? {
        if case let .error(error) = viewState {
            return error.errorDescription
        }
        return nil
    }

    var isLoading: Bool {
        switch viewState {
        case .loading, .settingPassword:
            return true
        default:
            return false
        }
    }

    func handleStateChange(_ state: SampleFeatureViewState) {
        switch state {
        case let .passwordRetrieved(password), let .passwordGenerated(password), let .settingPassword(password):
            internalPassword = password
        default:
            break // noop
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = PreviewSampleFeatureViewModel()
//        viewModel.viewState = .loading
//        viewModel.viewState = .noPasswordSet
//        viewModel.viewState = .passwordGenerated("fakePass")
//        viewModel.viewState = .passwordRetrieved("fakePass")
//        viewModel.viewState = .error(PasswordStorageError.unableToEncodePassword)
        let view = SampleFeatureView(viewModel: viewModel)
        viewModel.viewState = .settingPassword("fakePass")
        return view
    }
}
