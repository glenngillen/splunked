require "test/unit"
require "webmock/test_unit"
require "#{File.dirname(__FILE__)}/../lib/splunked"

Splunked.base_url = "https://splunked.com"

WebMock.disable_net_connect!
