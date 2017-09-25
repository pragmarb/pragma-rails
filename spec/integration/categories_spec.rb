# frozen_string_literal: true

RSpec.describe '/api/v1/categories' do
  describe 'GET /' do
    subject { -> { get api_v1_categories_path(params) } }

    let(:params) { {} }
    let!(:category) { FactoryGirl.create(:category) }

    it 'responds with 200 OK' do
      subject.call
      expect(last_response.status).to eq(200)
    end

    it 'returns the categories' do
      subject.call
      expect(parsed_response['data']).to match_array([
        a_hash_including('id' => category.id)
      ])
    end

    it 'adds pagination info to the response' do
      subject.call
      expect(parsed_response).to match(a_hash_including(
        'total_entries' => 1,
        'per_page' => 30,
        'current_page' => 1
      ))
    end

    context 'when pagination info is provided' do
      let(:params) do
        { page: 2, per_page: 1 }
      end

      let!(:category2) { FactoryGirl.create(:category) }

      it 'returns the articles from the given page' do
        subject.call
        expect(parsed_response['data']).to match_array([
          a_hash_including('id' => category2.id)
        ])
      end

      it 'adds the expected pagination info to the response' do
        subject.call
        expect(parsed_response).to match(a_hash_including(
          'total_entries' => 2,
          'per_page' => 1,
          'current_page' => 2
        ))
      end
    end

    context 'with an invalid page parameter' do
      let(:params) do
        { page: 0 }
      end

      it 'responds with 422 Unprocessable Entity' do
        subject.call
        expect(last_response.status).to eq(422)
      end
    end

    context 'with an invalid per_page parameter' do
      let(:params) do
        { per_page: 150 }
      end

      it 'responds with 422 Unprocessable Entity' do
        subject.call
        expect(last_response.status).to eq(422)
      end
    end

    context 'with an invalid expand parameter' do
      let(:params) do
        { expand: 'foo' }
      end

      it 'responds with 422 Unprocessable Entity' do
        subject.call
        expect(last_response.status).to eq(422)
      end
    end
  end

  describe 'GET /:id' do
    subject { -> { get api_v1_category_path(category, params) } }

    let(:category) { FactoryGirl.create(:category) }
    let(:params) { {} }

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

    context 'with an invalid expand parameter' do
      let(:params) do
        { expand: 'foo' }
      end

      it 'responds with 422 Unprocessable Entity' do
        subject.call
        expect(last_response.status).to eq(422)
      end
    end
  end
end
