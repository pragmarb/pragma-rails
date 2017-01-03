# frozen_string_literal: true
RSpec.describe Pragma::Rails::Controller do
  subject { controller_klass.new.tap(&:run_operation) }

  let(:controller_klass) do
    Class.new do
      OPERATION_KLASS = Class.new(Pragma::Operation::Base) do
        def call
          headers['X-Foo'] = params[:foo]
          respond_with status: :created, resource: { foo: params[:foo] }
        end
      end

      attr_reader :render_args

      def run_operation
        run OPERATION_KLASS
      end

      def response
        @response ||= OpenStruct.new(headers: {})
      end

      def render(*args)
        @render_args = args
      end

      def params
        {}
      end

      protected

      def operation_params
        { foo: 'bar' }
      end
    end.tap do |klass|
      klass.include described_class
    end
  end

  it 'responds with the headers from the operation' do
    expect(subject.response.headers).to eq('X-Foo' => 'bar')
  end

  it 'responds with the status code from the operation' do
    expect(subject.render_args.first[:status]).to eq(:created)
  end

  it 'responds with the resource from the operation' do
    expect(JSON.parse(subject.render_args.first[:json])).to eq('foo' => 'bar')
  end
end
