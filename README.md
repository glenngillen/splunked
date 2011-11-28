## Usage

(These aren't implmented yet, just driving development based on desired usage)

# Return all results where host = *
all_results = Splunked.search("host=*")

# De-duplicate the `host` field
all_results.dedup(:host)

# Return only the `host` and `sourcetype` fields
all_results.fields(:host, :sourcetype)

# Return the first 3 results
all_results.limit(3) # all_results.head(3)

# Rename the field `sum` to `total`
all_results.rename(:sum => :total)

# Replace all instances of "127.0.0.1" in the field `host` with "localhost"
all_results.replace(:host => { "127.0.0.1" => "localhost" })

# Sorts results by total
all_results.sort(:total)

# Extracts key/value pairs
all_results.extract(:kv_delim => "=", :pair_delim => " ")

# Adds Geolocation information to IP addresses
all_results.iplocation

# Displays the most common values of a field
all_results.top(:url, :limit => 20)

# Displays the least common values of a field
all_results.rare(:url, :limit => 20)

# Timechart: http://docs.splunk.com/Documentation/Splunk/4.2.4/SearchReference/timechart
# Chart: http://docs.splunk.com/Documentation/Splunk/4.2.4/SearchReference/chart
# Stats: http://docs.splunk.com/Documentation/Splunk/4.2.4/SearchReference/stats
# Contingency: http://docs.splunk.com/Documentation/Splunk/4.2.4/SearchReference/contingency
