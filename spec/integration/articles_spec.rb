# frozen_string_literal: true

RSpec.describe '/api/v1/articles' do
  describe 'GET /' do
    subject { -> { get api_v1_articles_path } }

    let!(:article) { FactoryGirl.create(:article) }

    it 'returns the articles' do
      subject.call
      expect(parsed_response).to match_array([
        a_hash_including('id' => article.id)
      ])
    end

    it 'adds pagination info to the headers' do
      subject.call
      expect(last_response.headers).to match(a_hash_including(
        'Total' => 1,
        'Per-Page' => 30,
        'Page' => 1
      ))
    end
  end

  describe 'GET /:id' do
    subject { -> { get api_v1_article_path(article) } }

    let(:article) { FactoryGirl.create(:article) }

    it 'returns the article' do
      subject.call
      expect(parsed_response).to match(a_hash_including(
        'id' => article.id
      ))
    end
  end
end
