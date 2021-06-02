module Support
  module Fakes
    class Square
      def initialize(spec, sites: nil)
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

        def initialize(sites)
          @sites = sites
        end
      end
    end
  end
end
