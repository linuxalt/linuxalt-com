
module Jekyll
    class Site

        def process
            self.reset
            # switch generate and read
            self.generate
            self.read

            self.render
            self.write
        end

     end
end
