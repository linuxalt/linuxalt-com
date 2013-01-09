module Jekyll
  # Specify the time for a post in the YAML front matter, not just the date.
  # Time must be a string!
  # time: "22:16"
  class PostTimeGenerator < Generator
    safe true
    
    def generate(site)
      site.posts.each do |post|
        if post.data.has_key?('time')
          post.date = Time.parse("#{post.date.strftime('%Y-%m-%d')} #{post.data['time']}")
        end
      end
    end
  end
end
