import Foundation

enum HTTPError: Error {
    case badStatus(status: Int)
    case badUrl
    case jsonEncode
}

extension HTTPError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badStatus(let status):
            return "bad status \(status)"
        case .badUrl:
            return "bad URL"
        case .jsonEncode:
            return "JSON encoding failed"
        }
    }
}

struct HttpUtil {
    
    static func delete(from url: String, id: Int) async throws {
        guard let url = URL(string: "\(url)/\(id)") else {
            throw HTTPError.badUrl
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        let (_, res) = try await URLSession.shared.data(for: request)
        
        if let res = res as? HTTPURLResponse, res.statusCode != 200 {
            throw HTTPError.badStatus(status: res.statusCode)
        }
    }
    
    static func get<T>(
        from url: String,
        type: T.Type
    ) async throws -> T where T: Decodable {
        guard let url = URL(string: url) else {
            throw HTTPError.badUrl
        }

        let (data, res) = try await URLSession.shared.data(from: url)
        print("HTTPUtil.get: data =", data)
        if let res = res as? HTTPURLResponse, res.statusCode != 200 {
            print("HTTPUtil.get: res.statusCode =", res.statusCode)
            throw HTTPError.badStatus(status: res.statusCode)
        }
        
        print("HTTPUtil.get: decoding")
        return try JSONDecoder().decode(type, from: data)
    }

    static func post<T, U>(
        to url: String,
        with data: T,
        type: U.Type
    ) async throws -> U where T: Encodable, U: Decodable {
        return try await httpWithBody(to: url, method: "POST", with: data, type: type)
    }

    static func put<T, U>(
        to url: String,
        with data: T,
        type: U.Type
    ) async throws -> U where T: Encodable, U: Decodable {
        return try await httpWithBody(to: url, method: "PUT", with: data, type: type)
    }

    private static func httpWithBody<T, U>(
        to url: String,
        method: String,
        with data: T,
        type: U.Type
    ) async throws -> U where T: Encodable, U: Decodable {
        guard let url = URL(string: url) else {
            throw HTTPError.badUrl
        }

        guard let json = try? JSONEncoder().encode(data) else {
            throw HTTPError.jsonEncode
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, res) = try await URLSession.shared.upload(for: request, from: json)
        
        if let res = res as? HTTPURLResponse, res.statusCode != 200 {
            throw HTTPError.badStatus(status: res.statusCode)
        }
        
        return try JSONDecoder().decode(type, from: data)
    }
}
