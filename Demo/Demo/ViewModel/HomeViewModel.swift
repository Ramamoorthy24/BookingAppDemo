//
//  HomeViewModel.swift
//  Demo
//
//  Created by Ramamoorthy on 08/05/23.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var users: [PersonData] = []
    private var subscriptions: Set<AnyCancellable> = []
    private let networking: NetworkServiceProtocol
    @Published var validationMessage: String?
    @Published var showAlert: Bool = false
    @Published var isSuccess: Bool = false
    
    init(networking: NetworkServiceProtocol) {
        self.networking = networking
    }
    
    func proceedBooking() {
        ProgressViewModel.shared.isShowing = true
            networking.getData()
                .sink {[weak self] completion in
                    guard let self = self else { return }
                    switch completion {
                    case .failure(let error):
                        if let _ = error.responseCode {
                            ProgressViewModel.shared.isShowing = false
                            self.validationMessage = error.localizedDescription
                            self.isSuccess = false
                            self.showAlert = true
                        }
                        if error.isSessionTaskError {
                            ProgressViewModel.shared.isShowing = false
                            self.validationMessage = error.localizedDescription
                            self.isSuccess = false
                            self.showAlert = true
                        }
                        if error.isResponseSerializationError {
                            self.validationMessage = error.localizedDescription
                            self.isSuccess = false
                            self.showAlert = true
                        }
                    case .finished:
                        break
                    }
                } receiveValue: {[weak self] value in
                    guard let self = self else { return }
                    ProgressViewModel.shared.isShowing = false
                    self.users = value
                    self.isSuccess = true
                    self.showAlert = false
                }
                .store(in: &subscriptions)
        }

}
