# frozen_string_literal: true

RSpec.describe '/api/v1/categories' do
  describe 'GET /' do
    subject { -> { get api_v1_categories_path } }

    let!(:category) { FactoryGirl.create(:category) }

    it 'responds with 200 OK' do
      subject.call
      expect(last_response.status).to eq(200)
    end

    it 'returns the categories' do
      subject.call
      expect(parsed_response).to match_array([
        a_hash_including('id' => category.id)
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
    subject { -> { get api_v1_category_path(category) } }

    let(:category) { FactoryGirl.create(:category) }

    it 'responds with 200 OK' do
      subject.call
      expect(last_response.status).to eq(200)
    end

    it 'returns the category' do
      subject.call
      expect(parsed_response).to match(a_hash_including(
        'id' => category.id
      ))
    end
  end
end
