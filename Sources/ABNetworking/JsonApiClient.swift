import Foundation

public final class JsonApiClient: APIClient {
    
    private let session: URLSessionProtocol

    public convenience init() {
        self.init(session: URLSession.shared)
    }
    
    public init(session: URLSessionProtocol) {
        self.session = session
    }
}

// MARK: - Callback methods
public extension JsonApiClient {
    @discardableResult func start<Model: Decodable>(_ request: APIRequest, resource: Model.Type = Model.self, using jsonDecoder: JSONDecoder, completion: @escaping (Result<Model, ABNetworkingError>) -> Void) -> APICancellable {
        let task = session.dataTask(with: request.jsonUrlRequest) { data, response, error in
            switch (data, response, error) {
            case (let data?, let response?, nil):
                
                guard let response = response as? HTTPURLResponse else {
                    fatalError("Should always be a httpUrlResponse")
                }
                
                guard response.statusCode != 404 else {
                    completion(.failure(ABNetworkingError.noResourceFound))
                    return
                }

                do {
                    let model = try jsonDecoder.decode(Model.self, from: data)
                    completion(.success(model))
                } catch {
                    completion(.failure(ABNetworkingError.couldNotParseResult(error)))
                }
            case (nil, _, let error?):
                completion(.failure(ABNetworkingError.urlSessionError(error)))
            default:
                break
            }
        }
        task.resume()
        return task
    }
}

// MARK: - Async/Await methods
public extension JsonApiClient {
    func start<Model: Decodable>(_ request: APIRequest, resource: Model.Type = Model.self, using jsonDecoder: JSONDecoder) async throws -> Model {

        do {
            try Task.checkCancellation()
            let (data, response) = try await session.data(for: request.jsonUrlRequest)

            try Task.checkCancellation()
            guard let response = response as? HTTPURLResponse else {
                throw ABNetworkingError.receivedNonHttpResponse
            }

            guard response.statusCode != 404 else {
                throw ABNetworkingError.noResourceFound
            }

            return try jsonDecoder.decode(Model.self, from: data)

        } catch let error as DecodingError {
            throw ABNetworkingError.couldNotParseResult(error)
        } catch let error as CancellationError {
            throw error
        } catch let error {
            let nsError = error as NSError
            if nsError.domain == NSURLErrorDomain, nsError.code == NSURLErrorCancelled {
                throw CancellationError()
            } else {
                throw ABNetworkingError.urlSessionError(error)
            }
        }
    }
}
