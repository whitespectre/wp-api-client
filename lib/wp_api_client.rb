require "wp_api_client/version"
require "wp_api_client/configuration"


require "wp_api_client/entities/base"
require "wp_api_client/entities/post"
require "wp_api_client/entities/taxonomy"
require "wp_api_client/entities/term"
require "wp_api_client/entities/image"
require "wp_api_client/entities/types"

require "wp_api_client/client"
require "wp_api_client/connection"
require "wp_api_client/collection"

module WpApiClient
  def self.get_client(&options)
    Client.new(Connection.new(configuration))
  end
end
