require 'csv'
require 'find'

COUNTRIES_DIR = "lib/smart_answer_flows/marriage-abroad/outcomes/countries/".freeze
OPPOSITE_SEX_FILE = "_opposite_sex.govspeak.erb".freeze
update_outcomes_csv = "script/update-outcomes.csv"

CSV.foreach(update_outcomes_csv, headers: true) do |row|
  country = row[0]
  variation = row[1]
  embassy_link = row[2]

  case variation
  when "1" # outcome_with_link
    text = "\nIf you’re entering an opposite sex civil partnership in #{country}, it might be recognised in England, Wales and Northern Ireland. You need to check with the [British embassy or high commission](#{embassy_link})."

    country_dir = File.open(COUNTRIES_DIR+country.downcase)
    opposite_sex_paths = []

    Find.find(country_dir) do |path|
      opposite_sex_paths << path if path =~ /_opposite_sex.govspeak.erb/
    end

    if opposite_sex_paths.length > 0
      puts "Found #{opposite_sex_paths.length} files called #{OPPOSITE_SEX_FILE} in the directory #{COUNTRIES_DIR}:"
      puts "#{opposite_sex_paths}"
    else
      puts "No files called #{OPPOSITE_SEX_FILE} found in the directory"
    end

    opposite_sex_paths.each do |path|
      # File.write(path, text, mode: 'a')
      puts "Appended text to end of file #{path}"
    end
  when "2" # outcome_without_link
    text = "\nIf you’re entering an opposite sex civil partnership in #{country}, it might be recognised in England, Wales and Northern Ireland. You need to check with the local government."

    country_dir = File.open(COUNTRIES_DIR+country.downcase)
    opposite_sex_paths = []

    Find.find(country_dir) do |path|
      opposite_sex_paths << path if path =~ /_opposite_sex.govspeak.erb/
    end

    if opposite_sex_paths.length > 0
      puts "Found #{opposite_sex_paths.length} files called #{OPPOSITE_SEX_FILE} in the directory #{COUNTRIES_DIR}:"
      puts "#{opposite_sex_paths}"
    else
      puts "No files called #{OPPOSITE_SEX_FILE} found in the directory"
    end

    opposite_sex_paths.each do |path|
      # File.write(path, text, mode: 'a')
      puts "Appended text to end of file #{path}"
    end
  when "3","4" # insert_outcome_with_link
    #TODO
  else
  end
end
