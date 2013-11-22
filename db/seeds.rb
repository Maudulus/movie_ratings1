API_KEY = ENV['ROTTEN_TOMATOES_API_KEY']
QUERY_DELAY = 1

def query(url)
  puts "Querying #{url}"

  begin
    sleep(QUERY_DELAY)
    return RestClient.get(url)
  rescue => e
    puts "Query failed (exception: #{e}), retrying..."
    retry
  end
end

def query_movie(movie_id)
  url = "http://api.rottentomatoes.com/api/public/v1.0/movies/#{movie_id}.json?apikey=#{API_KEY}"
  puts "Querying movie info for #{movie_id}..."
  JSON.parse(query(url), symbolize_names: true)
end

def query_cast(movie_id)
  url = "http://api.rottentomatoes.com/api/public/v1.0/movies/#{movie_id}/cast.json?apikey=#{API_KEY}"
  puts "Querying cast for #{movie_id}..."
  JSON.parse(query(url), symbolize_names: true)
end

def query_similar_movies(movie_id)
  url = "http://api.rottentomatoes.com/api/public/v1.0/movies/#{movie_id}/similar.json?apikey=#{API_KEY}"
  puts "Querying similar movies for #{movie_id}..."
  JSON.parse(query(url), symbolize_names: true)
end

queued_movie_ids = [12907]
queried_movie_ids = []
movie_count = 0

until queued_movie_ids.empty? or movie_count > 200

  next_movie_id = queued_movie_ids.shift
  next if queried_movie_ids.include?(next_movie_id)

  results = query_movie(next_movie_id)

  studio = nil

  if results[:studio]
    studio = Studio.find_or_create_by!(name: results[:studio])
  end

  genre = Genre.find_or_create_by!(name: results[:genres].first)

  movie_hash = {
    title: results[:title],
    year: results[:year],
    synopsis: results[:synopsis],
    rating: results[:ratings][:critics_score],
    genre: genre,
    studio_id: studio && studio.id
  }

  puts "found movie #{movie_hash[:title]}"

  movie = Movie.find_or_create_by!(movie_hash)
  movie_count += 1

  results = query_cast(next_movie_id)

  results[:cast].each do |cast_member|
    actor_hash = {
      name: cast_member[:name],
    }

    actor = Actor.find_or_create_by!(actor_hash)

    cast_member_hash = {
      movie: movie,
      actor: actor,
      character: cast_member[:characters].first
    }

    CastMember.find_or_create_by!(cast_member_hash)
  end

  results = query_similar_movies(next_movie_id)

  results[:movies].each do |movie_info|
    queued_movie_ids << movie_info[:id]
  end

  queried_movie_ids << next_movie_id
end
