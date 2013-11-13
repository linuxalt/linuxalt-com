require 'yaml'
  
module Jekyll
  
    # The Linux Pages
    class LinuxPage < Page
    
        def initialize(site, base, dir, name)
            @site = site
            @base = base
            @dir  = dir
            @name = name


            self.process(@name)
            self.read_yaml(File.join(base, '_layouts'), 'linux-software.html')

            self.data['similar'] = Array.new()
        end

        # Setters
        def title(value)
            self.data['title'] = value
        end

        def name(value)
            self.data['name'] = value
        end

        def projecturl(value)
            self.data['projecturl'] = value
        end

        def internal_link(value)
           self.data['internal_link'] = value
        end

        def add_similar(value)
            self.data['similar'].push(value)
        end

    end

    # Window page
    class WindowsPage < Page
    
        def initialize(site, base, dir, name)
            @site = site
            @base = base
            @dir  = dir
            @name = name


            self.process(@name)
            self.read_yaml(File.join(base, '_layouts'), 'windows-software.html')

            self.data['similar'] = Array.new()
        end

        # Setters
        def title(value)
            self.data['title'] = value
        end

        def name(value)
            self.data['name'] = value
        end

        def internal_link(value)
           self.data['internal_link'] = value
        end

        def alternatives(value)
            self.data['alternatives'] = value
        end

    end

    class LinuxAlternativeProject < Generator
        safe false
 
        def generate(site)
            alts = return_alternatives

            alt_data = Array.new()
            all_linux_software = Hash.new()

            alts.each { |d|
                similar = Array.new()
                software_hash = Hash.new() # 

                # first, go through all the Linux software and create a similar hash.
                d['linux_alternatives'].each_key { |linux|
                    simsoft = Hash.new()
                    simsoft['name'] = linux 
                    simsoft['url'] = d['linux_alternatives'][linux]['url']
                    simsoft['internal_link'] = d['linux_alternatives'][linux]['internal_link']

                    similar.push( simsoft )
                }

                d['linux_alternatives'].each_key { |linux|
                    
                    page = LinuxPage.new(site, site.source, "linux-software", d['linux_alternatives'][linux]['internal_link'])
                    page.name(linux) 
                    page.title(linux) 
                    page.projecturl(d['linux_alternatives'][linux]['url'])
                    page.internal_link(d['linux_alternatives'][linux]['internal_link'])

                
                    # For the linux index page.    
                    linux_hash = Hash.new()
                    first_chr = linux[0].chr.downcase
                    all_linux_software[first_chr] ||= Array.new
                    linux_hash['name'] = linux
                    linux_hash['internal_link'] = d['linux_alternatives'][linux]['internal_link']
                    all_linux_software[first_chr].push( linux_hash )

                    similar.each { |s|

                        if s['name'] == linux
                          next
                        end 

                        page.add_similar( s )

                    }    
                
                    site.pages << page

                 }

                d['windows_software'].each_key { |win|
                    page = WindowsPage.new(site, site.source, File.join("linux-alternatives-to", "windows"), d['windows_software'][win]['internal_link'])
                    page.name(win) 
                    page.title(win) 
                    page.internal_link(d['windows_software'][win]['internal_link'])
                    page.alternatives(similar)

                    site.pages << page

                    software_hash["win_software"] = win
                    software_hash["win_internal_url"] = d['windows_software'][win]['internal_link']
                    software_hash["linux_alternatives"] = similar
     
                 }
           
                 software_hash['linux_alternatives'].sort! {|a,b| a['name'].downcase <=> b['name'].downcase } 
                 alt_data.push(software_hash)
            }

            # Sort the array. 
            alt_data.sort!{|a,b| a['win_software'].downcase <=> b['win_software'].downcase } 

            # inject the alternative data into /index.html
            index_page = site.pages.detect {|page| page.url == '/index.html'}
            index_page.data['alts'] = alt_data

            # inject the alternatve data into /alternatives-table.html
            table_page = site.pages.detect {|page| page.url == '/alternatives-table.html'}
            table_page.data['alts'] = alt_data
        
            linux_index_page = site.pages.detect {|page| page.url == '/linux-software/index.html'}
            linux_index_page.data['software'] = all_linux_software.sort
        end

        private

        def return_alternatives
            YAML::load_file('_data/linux_alternatives.yaml') 
        end
    end
end
