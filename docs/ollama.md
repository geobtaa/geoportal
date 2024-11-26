require 'ollama-ai'

client = Ollama.new(
  credentials: { address: 'http://localhost:11434' },
  options: { 
    format: "json",
    stream: false
  }
)

prompt_preface = "Extract the named geographic entities from this text: "

prompt_text_to_extract = "Mom and Dad live in Cedar Falls, Iowa. My older sister lives in Harrison, AR. My brother and I live in Minneapolis, MN. I also lived in Madison, Wisconsin for over 10 years. We get around a lot."

prompt_example_response = "[{\"name\": \"name\", \"type\": \"one\"}, {\"name\": \"name\", \"type\": \"two\"}]"

prompt_suffix = "Return the results as an array of JSON objects. Each object should have a \"name\" and \"type\" property. Here is an example: #{prompt_example_response}. Do not prepend or append any text to your response. The response should be a valid JSON array of objects. Do not limit the number of results. Validate your JSON response before returning it."

result = client.generate(
  { model: 'llama3.2',
    prompt: prompt_preface + prompt_text_to_extract + prompt_suffix,
    stream: false
   }
)

json_result = JSON.parse(result.first["response"])

puts json_result