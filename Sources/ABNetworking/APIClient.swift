import Foundation

protocol APIClient {
    func start<Model: Decodable>(_ request: APIRequest, resource: Model.Type, using jsonDecoder: JSONDecoder, completion: @escaping (Result<Model, ABNetworkingError>) -> Void) -> APICancellable
    func start<Model: Decodable>(_ request: APIRequest, resource: Model.Type, using jsonDecoder: JSONDecoder) async throws -> Model
}

extension APIClient {
    func start<Model: Decodable>(_ request: APIRequest, resource: Model.Type = Model.self, completion: @escaping (Result<Model, ABNetworkingError>) -> Void) -> APICancellable {
        return start(request, resource: resource, using: JSONDecoder(), completion: completion)
    }

    func start<Model: Decodable>(_ request: APIRequest, resource: Model.Type = Model.self) async throws -> Model {
        try await start(request, resource: resource, using: JSONDecoder())
    }
}
