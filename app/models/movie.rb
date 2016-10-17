class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R )
  end
  
class Movie::InvalidKeyError < StandardError ; end
  
  def self.find_in_tmdb(string)
    movies = []
    begin
    
      Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
      if Tmdb::Movie.find(string) == nil
        return movies
      end
      Tmdb::Movie.find(string).each do |movie|
        movie_info = {}
        movie_info["id"] = movie.id
        movie_info["title"] = movie.title
        movie_info["release_date"] = movie.release_date
        #movie_info["rating"] = Tmdb::Movie.releases(movie.id)["countries"][0]["certification"]
        Tmdb::Movie.releases(movie.id)["countries"].each do |info|
          movie_info["rating"] = ""
          if info["iso_3166_1"] == "US" && info["certification"] != ""
            movie_info["rating"] = info["certification"]
            break
          end
        end
        movies += [movie_info]
      end
      
    rescue Tmdb::InvalidApiKeyError
        raise Movie::InvalidKeyError, 'Invalid API key'
    end
    movies
    
  end
  
  def self.create_from_tmdb(id)
    #@movie = Tmdb::Movie.find(tmdb_search)
    Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
    new_movie = {}
    new_movie["title"] = Tmdb::Movie.detail(id)["title"]
    new_movie["release_date"] = Tmdb::Movie.detail(id)["release_date"]
    new_movie["rating"] = ""
    Tmdb::Movie.releases(id)["countries"].each do |info|
      if info["iso_3166_1"] == "US"
        new_movie["rating"] = info["certification"]
        if info["certification"] != ""
              break
        end
      end
    end
    Movie.create(new_movie).save()
    
  end

end
