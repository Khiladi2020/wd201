def get_domain
  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
  ARGV.first
end

def parse_dns(dns)
  result = {}
  dns.each do |record|
    record = record.strip
    if (not(record[0] == "#" || record == ""))
      # puts "-------"+record[1]
      record = record.split(",")
      record = record.map { |x| x.strip }
      temp_hash = {
        :type => record[0],
        :destination => record[2],
      }
      result[record[1]] = temp_hash
    end
  end
  result
end

def resolve(dns_data, lookup_chain, domain)
  dns_data.each do |data, val|
    if data == domain && val[:type] == "A"
      #   puts "found match"
      lookup_chain.push(val[:destination])
      return lookup_chain
    elsif data == domain && val[:type] == "CNAME"
      #   puts "cname match found"
      lookup_chain.push(val[:destination])
      return resolve(dns_data, lookup_chain, val[:destination])
    end
  end
  return ["Error: record not found for #{domain}"]
end

domain = get_domain
dns_raw = File.readlines("zone")
# pp dns_raw

dns_records = parse_dns(dns_raw)
# pp dns_records
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)

#output
puts lookup_chain.join(" => ")
