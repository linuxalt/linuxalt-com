require 'yaml'

module Jekyll
  class LinuxIndex < Generator
    safe true

    def generate(site)

       alts = return_alternatives
     
       # Create a new array of hashes of all the windows programs to the linux software.

       all_linux_software = Hash.new()

       alts.each { |d|

           d['linux_alternatives'].each_key { |linux|

                   linux_hash = Hash.new()

                   first_chr = linux[0].chr.downcase
                   all_linux_software[first_chr] ||= Array.new

                   linux_hash['name'] = linux
                   linux_hash['internal_link'] = d['linux_alternatives'][linux]['internal_link']

                   all_linux_software[first_chr].push( linux_hash )

           }
       }


       # sort the windows software
       #puts YAML.dump(all_linux_software)

       # create a template. 
       template = Liquid::Template.parse(File.new("_templates/software-index.liquid").read)

       File.open(File.join('_includes', 'software-index.html' ), 'w') do |f|
           f.write(template.render 'software' => all_linux_software.sort)
       end

       # ok, lets do it again for the site map!
       sitemap_template = Liquid::Template.parse(File.new("_templates/sitemap.liquid").read)

       File.open(File.join('_includes', 'sitemap.html' ), 'w') do |f|
           f.write(sitemap_template.render 'software' => all_linux_software.sort)
       end



    end

    private

    def return_alternatives
        YAML::load_file('_data/linux_alternatives.yaml') 
    end

  end
end
