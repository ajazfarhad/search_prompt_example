require 'net/http'

module PromptDataLoader
  DATASET_ENDPOINT = URI('https://datasets-server.huggingface.co/rows?dataset=Gustavosta%2FStable-Diffusion-Prompts&config=default&split=test&offset=0&length=100')
  EXTRACT_PROMPT_CONTENT = ->(data) { data.dig('row', 'Prompt') }

  def self.load_sample_data
    PromptDatum.delete_all

    response = Net::HTTP.get(DATASET_ENDPOINT)
    parsed_response = JSON.parse(response)

    puts "Data loading started....."

    total_created_records = parsed_response['rows'].map(&EXTRACT_PROMPT_CONTENT).count

    parsed_response['rows'].map(&EXTRACT_PROMPT_CONTENT).each do |row|
      puts "Creating PromptDatum record........"
      PromptDatum.create!(content: row)
    end

    puts "#{total_created_records} records created..."
  end
end

namespace :prompt_data do
  desc "Load sample prompt data to the DB"
  task load: :environment do
    PromptDataLoader.load_sample_data
  end
end
