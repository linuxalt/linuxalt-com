require 'feedzirra'

module Jekyll
  class LinuxAltFeeds < Generator
    safe true

    def generate(site)
   
       feed = Feedzirra::Feed.fetch_and_parse("http://forum.linuxalt.com/feed.php?5,type=rss")

       entries = Array.new

       feed.entries.slice!(0,4).each { |e|
           entry = Hash.new
           entry['url'] = e.url
           entry['title'] = e.title
           entries.push(entry)       
       }
       # create a template. 
       template = Liquid::Template.parse(File.new("_templates/forum-activity.liquid").read)

       File.open(File.join('_includes', 'forum-activity.html' ), 'w') do |f|
           f.write(template.render 'entries' => entries)
       end

    end

  end
end
