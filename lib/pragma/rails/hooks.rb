# frozen_string_literal: true
Pragma::Operation::Index.class_eval do
  def build_page_url(page)
    Rails.application.routes.url_for(params.merge(page_param => page))
  end
end
