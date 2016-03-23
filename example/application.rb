require File.expand_path("../environment", __FILE__)
require File.expand_path("../../core/init.rb", __FILE__)
Dir["#{File.dirname(__FILE__)}/../core/common/*.rb"].each{|f| require f}
Dir["#{File.dirname(__FILE__)}//common/**/*.rb"].each{|f| require f}
Dir["#{File.dirname(__FILE__)}/component/*/init.rb"].each{|f| require f}
module Ramadoka
  class API < Grape::API
    namespace :v1 do
      namespace :web do
        mount Component::PaymentGateway::Endpoint::V1.mounted_class
      end
    end
    namespace :v2 do
      namespace :web do
        mount Component::PaymentGateway::Endpoint::V2.mounted_class
      end
    end

    before do
      header["Access-Control-Allow-Origin"] = headers["Origin"]
      header['Access-Control-Allow-Headers'] = headers["Access-Control-Request-Headers"] #unless headers["Access-Control-Request-Headers"].nil?
      header['Access-Control-Allow-Methods'] = 'GET, POST, PATCH, PUT, DELETE, OPTIONS, HEAD'
      header['Access-Control-Expose-Headers'] = 'ETag'
      header['Access-Control-Allow-Credentials'] = 'true'
    end
    format(:json)

    # options "/(*:url)", anchor: false do
    # end
    add_swagger_documentation(
      info: { title: "Ramadoka Simple API" },
      hide_format: true,
      api_version: "v1",
      mount_path: "api/docs"
    )
  end

end
ApplicationServer = Rack::Builder.new do

  map "/" do
    run Ramadoka::API
  end

end
