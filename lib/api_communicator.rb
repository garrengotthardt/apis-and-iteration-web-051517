require 'rest-client'
require 'json'
require 'pry'

def get_character_movies_from_api(character)
  #make the web request
  film_urls_array = []
  all_characters = RestClient.get('http://www.swapi.co/api/people/')
  character_hash = JSON.parse(all_characters)
  character_hash["results"].each do |individual_character|
    character_index = character_hash["results"].index(individual_character)
      if character_hash["results"][character_index]["name"].downcase == character
        film_urls_array = character_hash["results"][character_index]["films"]
      end
      film_urls_array
  end

  films_hash = []

  film_urls_array.each do |url|
    film_info = RestClient.get(url)
    film_hash = JSON.parse(film_info)
    films_hash << film_hash
  end
  #binding.pry

  # iterate over the character hash to find the collection of `films` for the given
  #   `character`
  # collect those film API urls, make a web request to each URL to get the info
  #  for that film
  # return value of this method should be collection of info about each film.
  #  i.e. an array of hashes in which each hash reps a given film
  # this collection will be the argument given to `parse_character_movies`
  #  and that method will do some nice presentation stuff: puts out a list
  #  of movies by title. play around with puts out other info about a given film.
  films_hash
end

def parse_character_movies(films_hash)
  # some iteration magic and puts out the movies in a nice list
  film_list = []
  films_hash.each do |film_hash|
    film_list << "'#{film_hash["title"]}'"
  end

  film_list.join(", ")
end

def show_character_movies(character)
  films_hash = get_character_movies_from_api(character)
  films_output = parse_character_movies(films_hash)
  character_name_output = character.split.map(&:capitalize).join(' ')
  puts "#{character_name_output} was in #{films_output}"

end

## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
