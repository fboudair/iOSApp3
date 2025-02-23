import Foundation

struct AuthResponse: Decodable {
    let token: String
}

func authenticate(username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
    let url = URL(string: "https://api.ingeniumcanada.org/auth/login")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body = [
        "username": username,
        "password": password
    ]
    
    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
    
    print("🔍 Sending authentication request to \(url)...")

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print(" Authentication failed: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            print(" No data received from authentication endpoint.")
            completion(.failure(NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
            return
        }

        do {
            let decodedResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
            print("✅ Authentication successful. Token received: \(decodedResponse.token)")
            completion(.success(decodedResponse.token))
        } catch {
            print(" Failed to decode authentication response: \(error)")
            completion(.failure(error))
        }
    }.resume()
}

struct MuseumAPI {
    static func search(query: String, token: String, completion: @escaping (Result<[MuseumItem], Error>) -> Void) {
        guard var urlComponents = URLComponents(string: "https://api.ingeniumcanada.org/collection/v1/search") else {
            print(" Invalid API URL")
            completion(.failure(MuseumAPIError.invalidURL))
            return
        }

        urlComponents.queryItems = [URLQueryItem(name: "q", value: query)]

        guard let url = urlComponents.url else {
            print(" Failed to construct search URL")
            completion(.failure(MuseumAPIError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        print("🔍 Sending museum search request to \(url) with token \(token.prefix(10))...")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(" Museum search failed: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print(" No valid HTTP response received")
                completion(.failure(MuseumAPIError.noResponse))
                return
            }

            print("ℹ️ API Response Status Code: \(httpResponse.statusCode)")

            guard (200...299).contains(httpResponse.statusCode) else {
                print(" API returned error with status code: \(httpResponse.statusCode)")
                completion(.failure(MuseumAPIError.httpError(statusCode: httpResponse.statusCode, message: "Invalid response")))
                return
            }

            guard let data = data else {
                print(" No data received from museum search")
                completion(.failure(MuseumAPIError.noData))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode([String: [MuseumItem]].self, from: data)
                if let items = decodedResponse["results"] {
                    print("✅ Museum search successful. Found \(items.count) items.")
                    DispatchQueue.main.async {
                        completion(.success(items))
                    }
                } else {
                    print(" Unexpected response format from museum API")
                    completion(.failure(MuseumAPIError.invalidResponseFormat))
                }
            } catch {
                print(" Failed to decode museum search response: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}

enum MuseumAPIError: Error {
    case missingAPIKey
    case invalidURL
    case noResponse
    case httpError(statusCode: Int, message: String)
    case noData
    case invalidResponseFormat
}
