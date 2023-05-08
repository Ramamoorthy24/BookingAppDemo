//
//  ProgressViewModel.swift

//

import Foundation

class ProgressViewModel: ObservableObject {
    
    static let shared = ProgressViewModel()
    
    @Published var isShowing = false
}
