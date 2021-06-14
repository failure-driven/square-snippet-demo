module Support
  module Fakes
    class Square
      def initialize(spec, sites: nil, snippet_result: {})
        @spec = spec
        @sites = OpenStruct.new(
          list_sites: OpenStruct.new(
            success?: true,
            data: OpenStruct.new(
              sites: sites,
            ),
          ),
        )

        @client = FakeSquareClient.new(
          @sites,
          snippet_result,
        )

        spec.allow(
          ::Square::Client,
        ).to spec.receive(:new) do |options|
          @credentials_provided = {
            access_token: options[:access_token],
          }
          @client
        end
      end

      class FakeSquareClient
        attr_reader :sites

        def initialize(sites, snippet_result)
          @sites = sites
          @snippet_result = snippet_result
        end

        def snippets
          FakeSquareSnippet.new(@snippet_result)
        end
      end

      class FakeSquareSnippet
        def initialize(snippet_result)
          @snippet_result = snippet_result
        end

        def retrieve_snippet(_args)
          @snippet_result
        end
      end
    end
  end
end
