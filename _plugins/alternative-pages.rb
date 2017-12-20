require 'yaml'

module Jekyll
  class AltPages < Generator
  safe false

    def generate(site)
       alts = return_alternatives

       # First, create a structure that we dump to each page, with some good information for the visitor.

       pages = Array.new()

       alts.each { |d|
	   similar = Array.new()

	   # first, go through all the Linux software and create a similar hash.
           d['linux_alternatives'].each_key { |linux|
                   simsoft = Hash.new()
                   simsoft['name'] = linux 
                   simsoft['url'] = d['linux_alternatives'][linux]['url']
                   simsoft['internal_link'] = d['linux_alternatives'][linux]['internal_link']

	           similar.push( simsoft )
           }

           # ok, we can loop through them again, but this time, create the page hash.

	   #page = Hash.new()

           d['linux_alternatives'].each_key { |linux|
                   page = Hash.new()
                   page['name'] = linux 
                   page['title'] = linux 
                   page['layout'] = 'linux-software' 
                   page['projecturl'] = d['linux_alternatives'][linux]['url']
                   page['internal_link'] = d['linux_alternatives'][linux]['internal_link']
                   if d['linux_alternatives'][linux].has_key? 'paid'
                       page['paid'] = d['linux_alternatives'][linux]['paid'] 
                   end

		   page['similar'] = Array.new()

           	   similar.each { |simsoft|

			if simsoft['name'] == linux
                          next
 			end 

			page['similar'].push( simsoft )

                   }	
		
	       pages.push( page )
           }


       }



       pages.each { |d|
	       File.open(File.join('linux-software', d['internal_link']), 'w') do |f|
#                  f.write(<<-END
#---
#layout: linux-software
#name: #{ linux }
#projecturl: #{d['linux_alternatives'][linux]['url']}
#---
#END
                  #)
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
