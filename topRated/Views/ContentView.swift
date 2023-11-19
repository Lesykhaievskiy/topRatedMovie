import SwiftUI

private struct AppColors {
    static let background = Color(UIColor(red: 0.184, green: 0.102, blue: 0.214, alpha: 1.0))
    static let title = Color.white
    static let secondaryText = Color(red: 0.776, green: 0.78, blue: 0.802)
    static let button = Color(red: 0.347, green: 0.337, blue: 0.837)
}

private struct TextConstants {
    static let readMore = "Read more"
    static let hide = "Hide"
    static let about = "About"
    static let trailers = "Trailers"
    static let similar = "Similar"
}

struct ContentView: View {
    @State private var isTextExpand = false
    @StateObject private var viewModel = MovieViewModel()
    
    var body: some View {
            ZStack {
                Color(UIColor(red: 0.184, green: 0.102, blue: 0.214, alpha: 1.0))
                    .ignoresSafeArea()
                ScrollView {
                    VStack {
                        HStack{
                            Text("Hi, Lesyk")          
                            Spacer()
                            Image(systemName: "square.and.arrow.up")
                        }
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/original/\(viewModel.movieDetails?.backdrop_path ?? "")")) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 233)
                                    .frame(maxWidth: .infinity)
                            case .failure:
                                Image("notFound")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 233)
                                    .frame(maxWidth: .infinity)
                            @unknown default:
                                fatalError()
                            }
                        }

                        Text("\(viewModel.movieDetails?.original_title ?? "")")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        movieDetails2()
                        
                        ScrollView {
                            Text("\(viewModel.movieDetails?.overview ?? "")")
                                .font(.headline)
                                .foregroundColor(AppColors.secondaryText)
                                .fontWeight(.light)
                                .lineLimit(isTextExpand ? nil : 3)
                                .padding(.top)
                            Button {
                                isTextExpand.toggle()
                            } label: {
                                Text(isTextExpand ? TextConstants.hide : TextConstants.readMore)
                                    .foregroundColor(AppColors.button)
                            }
                        }
                        .padding()
                        bottomBar()
                        HStack{
                            VStack(alignment: .leading, spacing: 10){
                                Text("Genre:")
                                    .foregroundColor(.gray)
                                Text(viewModel.formattedGenres(viewModel.movieDetails?.genres ?? []))
                                    .foregroundColor(.white)
                                Text("Year:")
                                    .foregroundColor(.gray)
                                Text(viewModel.extractYear(from: viewModel.movieDetails?.release_date ?? ""))
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            VStack(alignment: .leading, spacing: 10){
                                Text("Language text:")
                                    .foregroundColor(.gray)
                                Text(viewModel.languageName(for: viewModel.movieDetails?.original_language ?? "", spokenLanguage: viewModel.movieDetails?.spoken_languages ?? []) ?? "English")
                               
                                    .foregroundColor(.white)
                                Text("Country:")
                                    .foregroundColor(.gray)
                                Text(viewModel.formattedCountries(viewModel.movieDetails?.production_countries ?? []))
                                    .foregroundColor(.white)
                            }
                            
                        }
                        .padding()
                        
                        HStack {
                            VStack(alignment: .leading){
                                Text("Creators:")
                                    .foregroundColor(.gray)
                                
                                ScrollView(.horizontal){
                                    HStack(spacing: 20){
                                        let directors = viewModel.movieCredits?.getDirectors()
                                        ForEach(directors ?? [], id: \.id){ director in
                                            CreditsView(actor: director)
                                              
                                        }
                                    }
                                }
                                
                                Text("Actors:")
                                    .foregroundColor(.gray)
                                
                                
                                ScrollView(.horizontal){
                                    HStack(spacing: 20){
                                        let actors = viewModel.movieCredits?.getActors()
                                        ForEach(actors ?? [], id: \.id){ actor in
                                            CreditsView(actor: actor)
                                              
                                        }
                                    }
                                }
                                
                                
                                HStack{
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.leadinghalf.filled")
                                    Spacer()
                                    Text("+ Add feedback")
                                        .foregroundColor(.white)
                                        .underline()
                                    
                                }
                                .foregroundColor(.orange)
                                .padding(.top)
                            }
                            .padding()
                            Spacer()
                        }
                        
                    }
                }
           
            .task {
                viewModel.fetchData()
            }
               
            
        }
    }
    
    
    private func movieTitle() -> some View {
        Text("This will be a title for a movie")
            .multilineTextAlignment(.center)
            .foregroundColor(AppColors.title)
            .font(.largeTitle)
            .fontWeight(.bold)
    }
    
    private func movieDetails2() -> some View {
        HStack {
            Text("\(viewModel.extractYear(from: viewModel.movieDetails?.release_date ?? ""))   •")
            Text("\(viewModel.formattedGenres(viewModel.movieDetails?.genres ?? []))   •")
            Text("\(viewModel.convertTime(minutes: viewModel.movieDetails?.runtime ?? 0))")
        }
        .font(.headline)
        .foregroundColor(AppColors.secondaryText)
        .fontWeight(.light)
    }
    
    
    private func bottomBar() -> some View {
        HStack {
            Spacer()
            Text(TextConstants.about)
            Spacer()
            Text(TextConstants.trailers)
            Spacer()
            Text(TextConstants.similar)
            Spacer()
        }
        .foregroundColor(AppColors.title)
    }
}
#Preview {
    ContentView()
}
