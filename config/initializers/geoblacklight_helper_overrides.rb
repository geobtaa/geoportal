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
end
