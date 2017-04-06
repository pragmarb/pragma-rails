# frozen_string_literal: true

RSpec.describe '/api/v1/articles' do
  describe 'GET /' do
    subject { -> { get api_v1_articles_path(params) } }

    let(:params) { {} }
    let!(:article) { FactoryGirl.create(:article) }

    it 'responds with 200 OK' do
      subject.call
      expect(last_response.status).to eq(200)
    end

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

    context 'with the expand parameter' do
      let(:params) do
        { expand: ['category'] }
      end

      it 'expands the associations' do
        subject.call
        expect(parsed_response).to match_array([
          a_hash_including(
            'category' => a_hash_including('id' => article.category_id)
          )
        ])
      end
    end

    context 'when pagination info is provided' do
      let(:params) do
        { page: 2, per_page: 1 }
      end

      let!(:article2) { FactoryGirl.create(:article) }

      it 'returns the articles from the given page' do
        subject.call
        expect(parsed_response).to match_array([
          a_hash_including('id' => article2.id)
        ])
      end

      it 'adds the expected pagination info to the headers' do
        subject.call
        expect(last_response.headers).to match(a_hash_including(
          'Total' => 2,
          'Per-Page' => 1,
          'Page' => 2
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
    subject { -> { get api_v1_article_path(article, params) } }

    let(:article) { FactoryGirl.create(:article) }
    let(:params) { {} }

    it 'responds with 200 OK' do
      subject.call
      expect(last_response.status).to eq(200)
    end

    it 'returns the article' do
      subject.call
      expect(parsed_response).to match(a_hash_including(
        'id' => article.id
      ))
    end

    context 'with the expand parameter' do
      let(:params) do
        { expand: ['category'] }
      end

      it 'expands the associations' do
        subject.call
        expect(parsed_response).to match(a_hash_including(
          'category' => a_hash_including('id' => article.category_id)
        ))
      end
    end
  end

  describe 'POST /' do
    subject { -> { post api_v1_articles_path(params), article.to_json } }

    let(:article) do
      FactoryGirl.attributes_for(:article).tap do |a|
        a[:category] = FactoryGirl.create(:category).id
      end
    end

    let(:params) { {} }

    it 'responds with 201 Created' do
      subject.call
      expect(last_response.status).to eq(201)
    end

    it 'returns the article' do
      subject.call
      expect(parsed_response).to match(a_hash_including(
        'title' => article[:title]
      ))
    end

    it 'creates the article' do
      expect(subject).to change(Article, :count).by(1)
    end

    context 'with the expand parameter' do
      let(:params) do
        { expand: ['category'] }
      end

      it 'expands the associations' do
        subject.call
        expect(parsed_response).to match(a_hash_including(
          'category' => a_hash_including('id' => article[:category])
        ))
      end
    end
  end

  describe 'PATCH /:id' do
    subject { -> { patch api_v1_article_path(article, params), new_article.to_json } }

    let(:article) { FactoryGirl.create(:article) }
    let(:params) { {} }

    let(:new_article) do
      {
        title: 'New Article Title'
      }
    end

    it 'responds with 200 OK' do
      subject.call
      expect(last_response.status).to eq(200)
    end

    it 'returns the updated article' do
      subject.call
      expect(parsed_response).to match(a_hash_including(
        'title' => new_article[:title]
      ))
    end

    it 'updates the article' do
      expect(subject).to change { article.reload.title }.to(new_article[:title])
    end

    context 'with the expand parameter' do
      let(:params) do
        { expand: ['category'] }
      end

      it 'expands the associations' do
        subject.call
        expect(parsed_response).to match(a_hash_including(
          'category' => a_hash_including('id' => article.category_id)
        ))
      end
    end
  end

  describe 'DELETE /:id' do
    subject { -> { delete api_v1_article_path(article) } }

    let!(:article) { FactoryGirl.create(:article) }

    it 'responds with 204 No Content' do
      subject.call
      expect(last_response.status).to eq(204)
    end

    it 'deletes the article' do
      expect(subject).to change(Article, :count).by(-1)
    end
  end
end
