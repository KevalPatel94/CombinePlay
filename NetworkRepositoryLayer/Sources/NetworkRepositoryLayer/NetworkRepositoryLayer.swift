import Foundation

public protocol NetworkRepository {
    func fetch<T: Codable>(type: T.Type, with request: URLRequest) async throws -> T
}

public class NetworkDataRepository: NetworkRepository {
    public static let shared = NetworkDataRepository()
    private var session = URLSession.shared
    private init() { }

    public func fetch<T: Codable>(type: T.Type,
                           with request: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "Invalid response", code: 190)
        }
        guard httpResponse.statusCode == 200 else {
            throw NSError(domain: "Status code: \(httpResponse.statusCode)", code: 191)
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(type, from: data)
        } catch {
            throw NSError(domain: "\(error.localizedDescription)", code: 192)

        }
    }
}
