module Jekyll

  class Archive < Page
    # Initialize a new Archive.
    #   +base+ is the String path to the <source>
    #   +dir+ is the String path between <source> and the file
    #
    # Returns <Archive>
    def initialize(site, base, dir, type)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)

      self.read_yaml(File.join(base, '_layouts'), type + '.html')

      year, month, day = dir.split('/')
      self.data['year'] = year.to_i
      month and self.data['month'] = month.to_i
      day and self.data['day'] = day.to_i
    end
  end

end
