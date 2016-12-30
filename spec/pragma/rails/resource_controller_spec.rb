# frozen_string_literal: true
RSpec.describe Pragma::Rails::ResourceController do
  subject { controller_klass.new }

  before(:all) do
    module API
      module V1
        module Post
          module Operation
            class Update < Pragma::Operation::Base
            end
          end
        end
      end
    end
  end

  let(:controller_klass) do
    Class.new.tap do |klass|
      klass.include described_class
      allow(klass).to receive(:name).and_return('API::V1::PostsController')
    end
  end

  describe '.operation_klass' do
    it 'builds the expected operation class name' do
      expect(controller_klass.operation_klass(:update)).to eq('API::V1::Post::Operation::Update')
    end
  end

  describe '.operation?' do
    context 'when the operation class exists' do
      it 'returns true' do
        expect(controller_klass.operation?(:update)).to eq(true)
      end
    end

    context 'when the operation class does not exist' do
      it 'returns false' do
        expect(controller_klass.operation?(:create)).to eq(false)
      end
    end
  end

  describe 'calling a missing method' do
    context 'when the related operation does not exist' do
      it 'raises a NoMethodError' do
        expect { subject.create }.to raise_error(NoMethodError)
      end
    end

    context 'when the related operation exists' do
      it 'runs the related operation' do
        # rubocop:disable RSpec/SubjectStub
        expect(subject).to receive(:run).with('API::V1::Post::Operation::Update').once
        # rubocop:enable RSpec/SubjectStub
        subject.update
      end
    end
  end
end
