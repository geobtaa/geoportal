GeoblacklightHelper.module_eval do
  ##
  # Render help text popover for a given feature and translation key
  # @return [HTML tag]
  def render_help_text_entry(feature, key)
    if I18n.exists?("geoblacklight.help_text.#{feature}.#{key}", locale)
      help_text = I18n.t("geoblacklight.help_text.#{feature}.#{key}")
      content_tag :h3, class: 'help-text viewer_protocol h6' do
        content_tag :a, 'data': { toggle: 'popover', title: help_text[:title], content: help_text[:content] } do
          "#{help_text[:title]} #{geoblacklight_icon('info-circle-solid')}".html_safe
        end
      end
    else
      tag.span class: 'help-text translation-missing'
    end
  end

  ##
  # Render value for a document's field as a truncate abstract
  # div. Arguments come from Blacklight::DocumentPresenter's
  # get_field_values method
  # @param [Hash] args from get_field_values
  def render_placenames_as_truncate_abstract(args)
    content_tag :div, class: 'truncate-abstract' do
      links = []
      args[:value].each do |val|
        link = link_to val, search_action_path({:f => { args[:field].to_sym => [val]}})
        links << link.html_safe
      end
      links.flatten.join(', ').html_safe
    end
  end
end
