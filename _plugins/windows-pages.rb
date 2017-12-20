require 'yaml'

module Jekyll
  class WinPages < Generator
  safe false

    def generate(site)
       alts = return_alternatives

       # First, create a structure that we dump to each page, with some good information for the visitor.

       pages = Array.new()

       alts.each { |d|
	   alternatives = Array.new()

	   # first, go through all the Linux software and create a similar hash.
           d['linux_alternatives'].each_key { |linux|
                   a = Hash.new()
                   a['name'] = linux 
                   a['url'] = d['linux_alternatives'][linux]['url']
                   a['internal_link'] = d['linux_alternatives'][linux]['internal_link']
                   if d['linux_alternatives'][linux].has_key? 'paid'
                       a['paid'] = d['linux_alternatives'][linux]['paid']
                   end

	           alternatives.push( a )
           }

           d['windows_software'].each_key { |win|
                   page = Hash.new()
                   page['name'] = win 
                   page['title'] = win 
                   page['layout'] = 'windows-software' 
                   page['internal_link'] = d['windows_software'][win]['internal_link']
		   page['alternatives'] = alternatives
		
	           pages.push( page )
           }
       }

       pages.each { |d|
	       File.open(File.join('linux-alternatives-to/windows/', d['internal_link']), 'w') do |f|
                   f.write(YAML.dump(d))
                   f.write("---\n")
               end
       }

    end

    private

    def return_alternatives
        YAML::load_file('_data/linux_alternatives.yaml') 
    end

  end
end
