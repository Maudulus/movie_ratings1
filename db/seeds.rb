API_KEY = ENV['ROTTEN_TOMATOES_API_KEY']
QUERY_DELAY = 1

def query_movie(movie_id)
  sleep(QUERY_DELAY)
  url = "http://api.rottentomatoes.com/api/public/v1.0/movies/#{movie_id}.json?apikey=#{API_KEY}"
  puts "Querying movie info for #{movie_id}..."
  JSON.parse(RestClient.get(url), symbolize_names: true)
end

def query_cast(movie_id)
  sleep(QUERY_DELAY)
  url = "http://api.rottentomatoes.com/api/public/v1.0/movies/#{movie_id}/cast.json?apikey=#{API_KEY}"
  puts "Querying cast for #{movie_id}..."
  JSON.parse(RestClient.get(url), symbolize_names: true)
end

def query_similar_movies(movie_id)
  sleep(QUERY_DELAY)
  url = "http://api.rottentomatoes.com/api/public/v1.0/movies/#{movie_id}/similar.json?apikey=#{API_KEY}"
  puts "Querying similar movies for #{movie_id}..."
  JSON.parse(RestClient.get(url), symbolize_names: true)
end

queued_movie_ids = [12907]
queried_movie_ids = []
movie_count = 0

until queued_movie_ids.empty? or movie_count > 200

  next_movie_id = queued_movie_ids.shift
  next if queried_movie_ids.include?(next_movie_id)

  results = query_movie(next_movie_id)

  movie_hash = {
    title: results[:title],
    year: results[:year],
    synopsis: results[:synopsis],
    rating: results[:ratings][:critics_score]
  }

  puts "found movie #{movie_hash[:title]}"

  movie = Movie.find_by(movie_hash)
  movie ||= Movie.create!(movie_hash)

  movie_count += 1

  results[:genres].each do |name|
    genre = Genre.find_by(name: name)
    genre ||= Genre.create!(name: name)

    movie.genres << genre
  end

  results = query_cast(next_movie_id)

  results[:cast].each do |cast_member|
    actor_hash = { name: cast_member[:name] }

    actor = Actor.find_by(actor_hash)
    actor ||= Actor.create!(actor_hash)

    movie.actors << actor unless movie.actors.include?(actor)
  end

  results = query_similar_movies(next_movie_id)

  results[:movies].each do |movie_info|
    queued_movie_ids << movie_info[:id]
  end

  queried_movie_ids << next_movie_id
end
