require_relative 'config/environment'

use Rack::RequestId

run AdsRoutes

