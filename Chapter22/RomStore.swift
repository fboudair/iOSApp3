import Foundation

class RomStore: ObservableObject {
    @Published var objects: [Object] = []
    private var authToken: String?

    init() {
        #if DEBUG
        authenticateAndFetchMuseumData(query: "art")
        #endif
    }

    func authenticateAndFetchMuseumData(query: String) {
        authenticate { success in
            if success {
                self.fetchMuseumData(query: query)
            }
        }
    }

    private func authenticate(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://api.ingeniumcanada.org/auth-token") else {
            completion(false)
            return
        }

        let requestBody: [String: String] = [
            "username": "reytah131@yahoo.com",
            "password": "123321reY!"
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let _ = error {
                completion(false)
                return
            }

            guard let data = data else {
                completion(false)
                return
            }

            do {
                let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                DispatchQueue.main.async {
                    self.authToken = authResponse.token
                    completion(true)
                }
            } catch {
                completion(false)
            }
        }.resume()
    }

    func fetchMuseumData(query: String) {
        guard let token = authToken else { return }

        guard let url = URL(string: "https://api.ingeniumcanada.org/collection/v1/search?query=\(query)&query_op=AND&lang=en&on_display=false&has_media=false&limit=10&offset=0&sort=id&dir=asc") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let _ = error { return }

                guard let data = data else { return }

                do {
                    let responseObject = try JSONDecoder().decode(MuseumAPIResponse.self, from: data)
                    self.objects = responseObject.docs.map { $0.toObject() }
                } catch {}
            }
        }.resume()
    }
}

struct MuseumAPIResponse: Decodable {
    let total: String
    let offset: String
    let limit: String
    let docs: [MuseumItem]
}
