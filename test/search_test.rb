require 'helper'
class SearchTest < Test::Unit::TestCase

  def fixture_data
    File.read("#{File.dirname(__FILE__)}/fixtures/search.xml")
  end

  def setup
    stub_request(:post, "https://splunked.com/services/search/jobs").
      to_return(:status => 200, :body => fixture_data)
  end

  def test_sends_search_params
    Splunked.search("my term")

    assert_requested :post, "https://splunked.com/services/search/jobs" do |req|
      params = Hash[req.body.split("&").map{|p| p.split("=")}]
      CGI.unescape(params["search"]) == "search my term"
    end
  end

  def test_defaults_to_last_hour
    Splunked.search("my term")

    assert_requested :post, "https://splunked.com/services/search/jobs" do |req|
      params = Hash[req.body.split("&").map{|p| p.split("=")}]
      params["earliest_time"] == "-1h" &&
      params["latest_time"] == "-1m"
    end
  end

  def test_passes_time_range
    Splunked.search("my term", :from => (Time.now - 7200),
                               :to => (Time.now - 3600))

    assert_requested :post, "https://splunked.com/services/search/jobs" do |req|
      params = Hash[req.body.split("&").map{|p| p.split("=")}]
      params["earliest_time"] == "-2h" &&
      params["latest_time"] == "-1h"
    end
  end

  def test_returns_search_result_as_hash
    results = Splunked.search("foo")
    result = results.first

    assert result.is_a?(Hash)
    assert_equal "1089:282376590", result["_cd"]
    assert_equal "index09.splunk.example.com", result["splunk_server"]
    assert_equal "syslog", result["sourcetype"]
    assert_equal "2011-11-28T12:17:06+00:00 10.120.238.96 local4.notice server[24061] - someserver.57253@example.com - 10.210.17.219 - foo [28/Nov/2011:12:17:06 +0000] \"GET http://example.com/alerts/jobs HTTP/1.0\" 200 110 \"-\" \"Pingdom.com_bot_version_1.4_(http://www.pingdom.com/)\"", result["_raw"]
    assert_equal "10.120.238.96", result["host"]
    assert_equal "/var/log/example/UTC/log", result["source"]
    assert_equal "2011-11-28T12:17:06.000+00:00", result["_time"]
  end
end

