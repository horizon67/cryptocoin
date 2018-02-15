module ApplicationHelper
  def default_meta_tags
    {
      site: Settings.config.site.name,
      reverse: true,
      title: Settings.config.site.page_title,
      description: Settings.config.site.page_description,
      keywords: Settings.config.site.page_keywords,
      canonical: request.original_url,
      og: {
        title: :title,
        type: Settings.config.site.meta.ogp.type,
        url: request.original_url,
        image: image_url(Settings.config.site.meta.ogp.image_path),
        site_name: Settings.config.site.name,
        description: :description,
        locale: 'ja_JP'
      }
    }
  end
end
