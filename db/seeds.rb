API_KEY = ENV['ROTTEN_TOMATOES_API_KEY']
QUERY_DELAY = 1

def already_queued?(movie_id)
  QueuedMovie.exists?(movie_id: movie_id) or QueriedMovie.exists?(movie_id: movie_id)
end

def query(url)
  puts "Querying #{url}"

  begin
    sleep(QUERY_DELAY)
    return RestClient.get(url)
  rescue => e
    puts "Query failed (http code: #{e.http_code}, message: #{e.message})"
    if e.http_code == 404
      puts "Skipping..."
      return nil
    elsif e.http_code == 403
      puts "Either hit quota or missing access key, aborting.."
      abort
    else
      puts "Retrying..."
      retry
    end
  end
end

def fetch_json(url)
  results = query(url)

  if results.nil?
    nil
  else
    JSON.parse(results, symbolize_names: true)
  end
end

def query_movie(movie_id)
  url = "http://api.rottentomatoes.com/api/public/v1.0/movies/#{movie_id}.json?apikey=#{API_KEY}"
  puts "Querying movie info for #{movie_id}..."
  fetch_json(url)
end

def query_cast(movie_id)
  url = "http://api.rottentomatoes.com/api/public/v1.0/movies/#{movie_id}/cast.json?apikey=#{API_KEY}"
  puts "Querying cast for #{movie_id}..."
  fetch_json(url)
end

def query_similar_movies(movie_id)
  url = "http://api.rottentomatoes.com/api/public/v1.0/movies/#{movie_id}/similar.json?apikey=#{API_KEY}"
  puts "Querying similar movies for #{movie_id}..."
  fetch_json(url)
end

movie_count = 0

INITIAL_SEED = 12907

unless QueriedMovie.exists?(movie_id: INITIAL_SEED) or QueuedMovie.exists?(movie_id: INITIAL_SEED)
  QueuedMovie.create!(movie_id: INITIAL_SEED)
end

while QueuedMovie.any? and movie_count < 1000

  queued_movie = QueuedMovie.first

  if QueriedMovie.exists?(movie_id: queued_movie.movie_id)
    queued_movie.destroy!

  else
    results = query_movie(queued_movie.movie_id)

    unless results.nil?
      Movie.transaction do
        studio = nil

        if results[:studio]
          studio = Studio.find_or_create_by!(name: results[:studio])
        end

        raise ActiveRecord::Rollback if results[:genres].empty?

        genre = Genre.find_or_create_by!(name: results[:genres].first)

        movie_hash = {
          title: results[:title],
          year: results[:year].present? ? results[:year] : nil,
          synopsis: results[:synopsis].present? ? results[:synopsis] : nil,
          rating: results[:ratings][:critics_score] == -1 ? nil : results[:ratings][:critics_score],
          genre: genre,
          studio_id: studio && studio.id
        }

        puts "found movie #{movie_hash[:title]}"

        puts movie_hash

        unless movie_hash[:year].nil?
          movie = Movie.find_or_create_by!(movie_hash)
          movie_count += 1

          results = query_cast(queued_movie.movie_id)

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
        else
          puts "year is nil, skipping..."
        end

        results = query_similar_movies(queued_movie.movie_id)

        similar_movie_ids = results[:movies].map { |movie_info| movie_info[:id] }
        similar_movie_ids.each do |movie_id|
          unless already_queued?(movie_id)
            QueuedMovie.create!(movie_id: movie_id)
          end
        end
      end
    end

    QueriedMovie.create!(movie_id: queued_movie.movie_id)
    queued_movie.destroy!
  end
end
