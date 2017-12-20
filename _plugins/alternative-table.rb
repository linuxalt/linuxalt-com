require 'yaml'

module Jekyll
  class AltTable < Generator
    safe false

    def generate(site)

       alts = return_alternatives
     
       # Create a new array of hashes of all the windows programs to the linux software.

       alt_data = Array.new()

       alts.each { |d|
           software_hash = Hash.new()

           d['windows_software'].each_key { |win|
               software_hash["win_software"] = win
               software_hash["win_internal_url"] = d['windows_software'][win]['internal_link']
               software_hash["linux_alternatives"] = Array.new 
               d['linux_alternatives'].each_key { |linux|
		   linux_hash = Hash.new
                   linux_hash['name'] = linux
                   linux_hash['url'] = d['linux_alternatives'][linux]['url']
                   if d['linux_alternatives'][linux].has_key? 'paid'
                        linux_hash['paid'] = d['linux_alternatives'][linux]['paid']
                   end 
                   linux_hash['internal_link'] = d['linux_alternatives'][linux]['internal_link']
                   software_hash["linux_alternatives"].push( linux_hash )
               }
           }
           # sort the linux alternatives
           software_hash['linux_alternatives'].sort! {|a,b| a['name'].downcase <=> b['name'].downcase } 
	   alt_data.push(software_hash)
       }
       # sort the windows software
       alt_data.sort!{|a,b| a['win_software'].downcase <=> b['win_software'].downcase }	

       # create a copy of the alt_data array, randomized and only 5 elements.  This is for the front page.
       random_data = alt_data.sort_by{rand}[0..2]
 
       # create a template. 
       template = Liquid::Template.parse(File.new("_templates/alternative-table.liquid").read)

       File.open(File.join('_includes', 'alternative-table.html' ), 'w') do |f|
           f.write(template.render 'alts' => alt_data)
       end

       File.open(File.join('_includes', 'alternative-table-random-fp.html' ), 'w') do |f|
           f.write(template.render 'alts' => random_data)
       end

       # now we need to generate the sitemap data for inclusion in sitemap.xml

    end

    private

    def return_alternatives
        YAML::load_file('_data/linux_alternatives.yaml') 
    end

  end
end
