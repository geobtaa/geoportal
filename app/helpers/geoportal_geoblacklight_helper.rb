module GeoportalGeoblacklightHelper
  include GeoblacklightHelper

  def manifest_viewer
    content_tag :div, nil, class: "uv" do
      content_tag :iframe, nil,
                  allowfullscreen: true,
                  src: "#{asset_path("uv/uv", skip_pipeline: true)}#?manifest=#{@document.references.references(:iiif_manifest).endpoint}&config=#{asset_url('uv/uv_config.json')}"

    end
  end
end
