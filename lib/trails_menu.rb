require_relative 'search_menu.rb'

def trail_list(user, zipcode)
  puts
  if @nearby_trails.empty?
    puts "Sorry, there are no trails near this zipcode."
    puts "Would you like a list of all trails in #{@borough} instead? (Y/N)"
    answer = gets.chomp
    if answer == "Y" || answer == "y"
      borough_toggled_trails(user)
    else
      get_search_zipcode(user)
    end
  end

  puts "Here are the trails most recommended for you:"
  @nearby_trails.flatten.each_with_index { |trail, index| puts "#{index + 1}. #{trail.name}.  Difficulty: #{trail.difficulty}" }
  puts "Please pick a trail number:"
  trail_number = gets.chomp
  chosen_trail = @nearby_trails[trail_number.to_i - 1]
  puts "Would you like to see (1) Directions or (2) Reviews for #{chosen_trail.name}?"
  choice = gets.chomp
  case choice
  when "1"
    directions_list(user, chosen_trail)
  when "2"
    reviews(user, chosen_trail)
  end
end

def borough_toggled_trails(user)
  puts "Here is the trail(s) within #{@borough}:"
  @borough_trails.flatten.each_with_index { |trail, index| puts "#{index+1}. #{trail.name} Difficulty: #{trail.difficulty}"}
  # binding.pry
  puts "Please pick a trail number:"
  trail_number = gets.chomp
  chosen_trail = @borough_trails[trail_number.to_i - 1]
  puts "Would you like to see (1) Directions or (2) Reviews for #{chosen_trail.name}?"
  choice = gets.chomp
  case choice
  when "1"
    directions_list(user, chosen_trail)
  when "2"
    reviews(user, chosen_trail)
  end

end

def directions_list(user, chosen_trail)
  puts "Please wait, system processing"
  # binding.pry
  directions = chosen_trail.directions(user.geolocation, chosen_trail.geolocation)
  3.times do
    print "."
    sleep(1)
  end
  puts "Here are directions to #{chosen_trail.name} from your chosen kiosk:"
  puts "Distance: #{directions[:distance]}"
  puts "Duration: #{directions[:duration]}"
  directions[:directions].each do |line|
    puts line
    sleep(0.5)
  end
  puts
  puts "Thanks!"
  exit
end

def reviews(user, chosen_trail)
  if chosen_trail.reviews.empty?
    puts "No reviews for #{chosen_trail.name}. Would you like to add one? (Y/N)"
    choice = gets.chomp
    if choice == "Y"
      puts "Please add review description: "
      trail_description = gets.chomp
      user.add_review(trail_description, chosen_trail)
      puts "Review Added."
      puts "Please pick another trail:"
      borough_toggled_trails(user)
    else
      puts "Please pick another trail: "
      borough_toggled_trails(user)
    end

  else
    puts
    puts "Reviews for #{chosen_trail.name}:"
    chosen_trail.reviews.each do |review|
      sleep(0.5)
      puts "#{review.user_id}: #{review.desc} "
    end
  end
end
