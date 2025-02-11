class SerializedYamlToJson < ActiveRecord::Migration[7.2]
  def change
    # Fetch all elements with their id and html_attributes
    elements = ActiveRecord::Base.connection.execute("SELECT id, html_attributes FROM elements")

    elements.each do |element|
      id = element['id']
      yaml_attributes = element['html_attributes']

      next if yaml_attributes.nil? || yaml_attributes.strip.empty? # Skip if html_attributes is nil or empty

      # Convert YAML to JSON using Ruby
      json_attributes = yaml_to_json(yaml_attributes)
      next if json_attributes.nil? # Skip if conversion failed

      # Update the element with the new JSON attributes using raw SQL
      ActiveRecord::Base.connection.execute(
        "UPDATE elements SET html_attributes = #{ActiveRecord::Base.connection.quote(json_attributes)} WHERE id = #{id}"
      )
    end
  end

  private

  # Helper function to convert YAML to JSON
  def yaml_to_json(yaml_string)
    YAML.load(yaml_string).to_json
  rescue Psych::SyntaxError => e
    Rails.logger.error("YAML syntax error: #{e.message}")
    nil
  end
end
