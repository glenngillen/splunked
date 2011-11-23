require "splunked/version"
require "rest-client"
require "nokogiri"

module Splunked
  def self.search(terms, opts = {})
    earliest  = opts[:from] || (Time.now - 3600)
    latest    = opts[:to]   || (Time.now - 60)
    wait_secs = opts[:timeout] || 600
    # TODO: Catch dates that are in the future
    # TODO: Catch dates that are more than x days old
    timeout(wait_secs) do
      xml = RestClient.post("#{base_url}/services/search/jobs",
                            { "search" => "search #{terms}",
                              "exec_mode" => "oneshot",
                              "earliest_time" => "-#{time_part_since(earliest)}",
                              "latest_time" => "-#{time_part_since(latest)}" })
      parse_xml(xml)
    end
  end

  def self.base_url=(val)
    @base_url = val
  end

  def self.base_url
    @base_url ||= ENV["SPLUNK_URL"]
  end

  private
  def self.time_part_since(date)
    ChronicDuration.output(Time.now - date, :format => :micro).
      match(/[\d]+[a-z]/)[0]
  end

  def self.parse_xml(xml)
    doc = Nokogiri.parse(xml)
    fields = doc.xpath("//results/meta/fieldOrder/field").map(&:text)
    rows = []
    doc.xpath("//results/result").each do |result|
      row = {}
      fields.each do |field|
        row[field] = result.search("field[@k='#{field}']").text.strip
      end
      row["attributes"] = split_attributes(row["_raw"])
      row["tags"] = extract_tags(row["_raw"])
      rows << row
    end
    rows
  end

  def self.split_attributes(data)
    return unless data
    Hash[data.split.reject{ |v| !v.index("=") }.map{|v| v.split("=", 2) }]
  end

  def self.extract_tags(data)
    return unless data
    data.scan(/#[a-zA-Z][^ ]*/)
  end

end
