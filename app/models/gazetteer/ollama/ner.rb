require 'ollama-ai'
require 'json'

# Gazetteer::Ollama::Ner is a class that uses the Ollama AI service to extract
# named geographic entities from a given text. It returns the results as a JSON array
# of objects, each containing a "name" and "type" property.
#
# Example usage:
#   ner = Gazetteer::Ollama::Ner.new
#   text = "Mom and Dad live in Cedar Falls, Iowa. My older sister lives in Harrison, AR. My brother and I live in Minneapolis, MN."
#   results = ner.extract_entities(text)
#   puts results
# Combine with Geonames::Tagger to get the coordinates of the entities
#   tagger = Gazetteer::Geonames::Tagger.new
#   results = tagger.tag_entities(results)
class Gazetteer::Ollama::Ner

  # Initializes a new instance of the Gazetteer::Ollama::Ner class.
  #
  # @param address [String] the address of the Ollama AI service (default: 'http://localhost:11434')
  # @param model [String] the model to use for entity extraction (default: 'llama3.2')
  def initialize(address: 'http://localhost:11434', model: 'llama3.2')
    @client = Ollama.new(
      credentials: { address: address },
      options: { 
        format: "json",
        stream: false
      }
    )
    @model = model
  end

  # Extracts named geographic entities from the provided text.
  #
  # @param text [String] the text from which to extract geographic entities
  # @return [Array<Hash>] an array of hashes, each containing a "name" and "type" of the entity
  def extract_entities(text)
    prompt_preface = "Extract the named geographic entities from this text: "
    prompt_example_response = "[{\"name\": \"name\", \"type\": \"one\"}, {\"name\": \"name\", \"type\": \"two\"}]"
    prompt_suffix = "Return the results as an array of JSON objects. Each object should have a \"name\" and \"type\" property. Here is an example: #{prompt_example_response}. Do not prepend or append any text to your response. The response should be a valid JSON array of objects. Importantly, do not limit the number of results. Validate your JSON response before returning it."

    prompt = prompt_preface + text + prompt_suffix

    result = @client.generate(
      { 
        model: @model,
        prompt: prompt,
        stream: false
      }
    )
    
    begin
      parsed_result = JSON.parse(result.first["response"])
      [true, parsed_result]  # Return success and the parsed result
    rescue JSON::ParserError
      [false, nil]  # Return failure and nil
    end
  end
end