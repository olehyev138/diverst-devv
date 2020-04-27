# This script is used to generate translation files from a primary language .json file combined with a .csv file that
# uses the values from the .json file as the first column for every row.
#
# Parsed JSON Format:
# {
#   "diverst.containers.App.dayOfWeek.sunday": "Sunday",
#   ...
# }
#
# Parsed CSV Format:
# [
#   ['Sunday', 'Domingo', 'Dimanche']
#   ...
# ]
# Note: the first item for every row must be the language of the JSON message values, aka the "primary" language
#
# *Important*: If a value is excluded, you must still include the comma, otherwise values can be placed in the wrong
#               language and/or you will not be warned if a translation message is missing

# File path for primary language JSON messages in the above format
PRIMARY_MESSAGES_JSON_FILE_PATH = 'client/app/translations/en.json'

# File path for CSV translation strings in the above format
TRANSLATIONS_CSV_FILE_PATH = 'translations.csv'

# Directory path for where to put the generated JSON files for each language, using the language keys defined below
OUTPUT_DIRECTORY = 'client/app/translations'

# Define *extra* languages in the order that they are in the CSV, values being the JSON filenames
LANGUAGE_KEYS = [
  'es',
  'fr',
]

# By default this script will generate human readable output, if you pass 'csv' it will only output failed translations in CSV format
USE_PRETTY_OUTPUT = ARGV[0] != 'csv'

# rubocop:disable Rails/Blank
require 'json'
require 'csv'
require 'fileutils'

primary_messages_json_file = File.open PRIMARY_MESSAGES_JSON_FILE_PATH

json = JSON.load primary_messages_json_file
csv = CSV.read TRANSLATIONS_CSV_FILE_PATH

primary_messages_json_file.close

report_file = File.open("translation_generation_report.#{USE_PRETTY_OUTPUT ? 'txt' : 'csv'}", 'w')

json_entry_count = json.keys.length

report_file.puts 'Starting translation generation with:' if USE_PRETTY_OUTPUT
report_file.puts "#{json_entry_count} JSON entries" if USE_PRETTY_OUTPUT
report_file.puts "#{csv.length} CSV rows" if USE_PRETTY_OUTPUT
report_file.puts '' if USE_PRETTY_OUTPUT

object_output_per_language = Array.new(LANGUAGE_KEYS.length) { Hash.new }

failure_count = 0

json.each do |key, value|
  # Custom logic for if the message string is placeholder text
  if value.start_with?('{') || value.end_with?('}')
    object_output_per_language.each { |language_messages| language_messages[key] = value }
    next
  end

  message_translations = csv.find { |sub_array| sub_array[0]&.downcase == value.downcase } # Find rows where the first value is the primary language string

  # If we can't find the primary language string as the first item in any of the rows then add a warning to the report file and use a placeholder for the value
  if message_translations.nil? || message_translations.empty?
    report_file.puts 'WARNING: Failed to find translations for any locale for:' if USE_PRETTY_OUTPUT
    if USE_PRETTY_OUTPUT
      report_file.puts "\"#{value}\" - Key: #{key}\n\n"
    else
      report_file.puts "\"#{value}\",#{key}"
    end
    object_output_per_language.each { |language_messages| language_messages[key] = 'MISSING TRANSLATION MESSAGE' }
    failure_count += 1
    next
  end

  message_translations = message_translations.drop(1) # Remove primary language string
  message_translations.each_with_index do |translation, index|
    if translation.nil? || translation.empty?
      report_file.puts 'WARNING: Failed to find translation for:' if USE_PRETTY_OUTPUT
      if USE_PRETTY_OUTPUT
        report_file.puts "Locale: '#{LANGUAGE_KEYS[index]}' - \"#{value}\" - Key: #{key}\n\n"
      else
        report_file.puts "#{LANGUAGE_KEYS[index]},\"#{value}\",#{key}"
      end
      object_output_per_language[index][key] = 'MISSING TRANSLATION MESSAGE'
      failure_count += 1
    else
      object_output_per_language[index][key] = translation
    end
  end
end

# Create directory structure if it doesn't already exist
FileUtils.mkdir_p OUTPUT_DIRECTORY

# Create JSON files with translation data
object_output_per_language.each_with_index do |language_translations_object, index|
  File.write(
      File.join(OUTPUT_DIRECTORY, "#{LANGUAGE_KEYS[index]}.json"),
      JSON.pretty_generate(language_translations_object, indent: "\t", object_nl: "\n")
    )
end

report_file.puts '' if USE_PRETTY_OUTPUT
report_file.puts "Finished translation generation at: #{Time.now}" if USE_PRETTY_OUTPUT
report_file.puts "Failure count: #{failure_count} out of #{json_entry_count} JSON entries" if USE_PRETTY_OUTPUT
report_file.puts "Note that this number is a sum of both when the translation couldn't be found at all, and when it can't find a translation for a single language" if USE_PRETTY_OUTPUT
report_file.close

puts "Translation generation finished with #{failure_count} failure(s). A report was generated in this directory"
