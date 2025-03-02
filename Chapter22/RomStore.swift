import Foundation

class RomStore: ObservableObject {
    @Published var objects: [Object] = []
    private var authToken: String?

    init() {
        #if DEBUG
        authenticateAndFetchMuseumData(query: "art")
        #endif
    }
// this function authenticate and retieve data for a given query
    func authenticateAndFetchMuseumData(query: String) {
        authenticate { success in
            if success {
                self.fetchMuseumData(query: query)
            }
        }
    }
// this function handles Api authentication
    private func authenticate(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://api.ingeniumcanada.org/auth-token") else { //is this the url for the museum Api page
            completion(false)
            return
        }

        let requestBody: [String: String] = [
            "username": "reytah131@yahoo.com", // this is my usernamr and password for the museum
            "password": "123321reY!"
        ]
        // create base on the museum Api page
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        // autheticcation failed because of in error
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let _ = error {
                completion(false)
                return
            }
            // failed because no data is received
            guard let data = data else {
                completion(false)
                return
            }
            // the authetication was successful tried to Decode response to find authetication token
            do {
                let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                DispatchQueue.main.async {
                    self.authToken = authResponse.token
                    completion(true)
                }
            } catch {
                completion(false)
            }
            // Decoding not successfull
        }.resume()
    }
    // this function fetching the museum data for a query
    func fetchMuseumData(query: String) {
        guard let token = authToken else { return } // if is not authetication key stop the function
// creating the Api url for searching the query
        guard let url = URL(string: "https://api.ingeniumcanada.org/collection/v1/search?query=\(query)&query_op=AND&lang=en&on_display=false&has_media=false&limit=10&offset=0&sort=id&dir=asc") else { return }
        //creation the url request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        // sending the request
        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let _ = error { return } //stop the function if their a error

                guard let data = data else { return } //stop the function if no data available

                do {
                    let responseObject = try JSONDecoder().decode(MuseumAPIResponse.self, from: data) // Decoding the reponse from json too object
                    self.objects = responseObject.docs.map { $0.toObject() }
                } catch {}
            }
        }.resume()
    }
}
//this struct represent the API reponse
struct MuseumAPIResponse: Decodable {
    let total: String
    let offset: String
    let limit: String
    let docs: [MuseumItem] //left off museum items return by the Api
}
