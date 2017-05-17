require 'rest-client'
require 'json'
require 'pry'

class Character
  attr_reader :name, :films, :films_URLs, :film_titles

  def initialize(individual_character)
    @name = individual_character["name"]
    @film_titles = []
    @films_URLs = individual_character["films"]
  end

  def get_film_titles
    @films_URLs.each do |url|
      film_info = RestClient.get(url)
      film_hash = JSON.parse(film_info)
      @film_titles << film_hash["title"]
    end
  end

  def show_character_movies
    films_output = @film_titles.join(", ")
    character_name_output = @name.split.map(&:capitalize).join(' ')
    puts "#{character_name_output} was in #{films_output}"
  end

end

def get_character_movies_from_api(character)
  #make the web request
  film_urls_array = []
  all_characters = RestClient.get('http://www.swapi.co/api/people/')
  character_hash = JSON.parse(all_characters)
  character_hash["results"].each do |individual_character|
    character_index = character_hash["results"].index(individual_character)
      if character_hash["results"][character_index]["name"].downcase == character
        character = Character.new(individual_character)
      end
  end
  character.get_film_titles
  character.show_character_movies
end


## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
