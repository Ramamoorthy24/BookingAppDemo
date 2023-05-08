

import Foundation
import Combine
import Alamofire


enum ErrorType {
    case decoding
    case noInternet
    case backend(Int)
}


protocol NetworkServiceProtocol {
    func getData() -> AnyPublisher<[PersonData], AFError>
}

struct NetworkService: NetworkServiceProtocol {
    
    func getData() -> AnyPublisher<[PersonData], AFError> {
        
        let url = URL(string: userListUrl)!

        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]

        return AF.request(url, method: .get,parameters: [:],headers: headers)
            .validate()
            .publishDecodable(type: [PersonData].self)
            .value()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
   
}
