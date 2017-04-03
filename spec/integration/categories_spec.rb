RSpec.describe '/api/v1/categories' do
  describe 'GET /' do
    subject { -> { get api_v1_categories_path } }

    let!(:category) { FactoryGirl.create(:category) }

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
end
