# frozen_string_literal: true
require 'action_controller'

RSpec.describe Pragma::Rails::Controller do
  subject { controller_klass.new.tap(&:run_operation) }

  let(:controller_klass) do
    Class.new do
      attr_reader :render_args

      def run_operation
        run (Class.new(Pragma::Operation::Base) do
          step :respond!

          def respond!(options, params:, **)
            options['result.response'] = Pragma::Operation::Response::Created.new(
              headers: { 'X-Foo' => params[:foo] },
              entity: { foo: params[:foo] }
            )
          end
        end)
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
        ActionController::Parameters.new(foo: 'bar')
      end
    end.tap do |klass|
      klass.include described_class
    end
  end

  it 'responds with the headers from the operation' do
    expect(subject.response.headers).to eq('X-Foo' => 'bar')
  end

  it 'responds with the status code from the operation' do
    expect(subject.render_args.first[:status]).to eq(201)
  end

  it 'responds with the resource from the operation' do
    expect(JSON.parse(subject.render_args.first[:json])).to eq('foo' => 'bar')
  end
end
