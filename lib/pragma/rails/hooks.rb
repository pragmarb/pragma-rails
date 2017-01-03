# frozen_string_literal: true
Pragma::Operation::Index.class_eval do
  def build_page_url(page)
    Rails.application.routes.url_helpers.url_for(params.merge(
      page_param => page,
      only_path: true
    ).symbolize_keys)
  end
end
