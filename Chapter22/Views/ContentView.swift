import SwiftUI

struct ContentView: View {
    @StateObject private var store = RomStore()
    @State private var query = "Arts"
    @State private var showQueryField = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("You searched for '\(query)'")
                    .padding(5)
                    .background(Color("Color 3"))
                    .cornerRadius(10)

                List(store.objects, id: \ .objectID) { object in
                    if !object.isPublicDomain, let url = URL(string: object.objectURL) {
                        NavigationLink(destination: SafariView(url: url)) {
                            WebIndicatorView(title: object.title)
                        }
                        .listRowBackground(Color("Color 7"))
                        .foregroundColor(Color ("Color 8"))
                    } else {
                        NavigationLink(destination: ObjectView(object: object)) {
                            Text(object.title)
                        }
                        .listRowBackground(Color ("Color 7" ))
                    }
                }
                .navigationTitle("The Ingenium")
                .toolbarBackground(Color ("Color 5"), for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showQueryField = true
                        }) {
                            Text("Search the Ingenium")
                                .font(.system(size:20))
                                .foregroundColor(Color ("Color 5"))
                                .padding(.horizontal)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color ("Color 5"), lineWidth: 2)
                                )
                        }
                    }
                }
                .alert("Search the ROM", isPresented: $showQueryField) {
                    TextField("Enter search term", text: $query)
                    Button("Search") {
                        store.fetchMuseumData(query: query) // ✅ Trigger search on button press
                    }
                }
            }
            .navigationDestination(for: URL.self) { url in
                SafariView(url: url)
                    .navigationBarTitleDisplayMode(.inline)
                    .ignoresSafeArea()
            }
            .navigationDestination(for: Object.self) { object in
                ObjectView(object: object)
            }
        }
    }
}

struct WebIndicatorView: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                .font(.footnote)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
