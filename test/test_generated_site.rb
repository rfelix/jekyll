require File.dirname(__FILE__) + '/helper'

class TestGeneratedSite < Test::Unit::TestCase
  context "generated sites" do
    setup do
      clear_dest
      stub(Jekyll).configuration do
        Jekyll::DEFAULTS.merge({'source' => source_dir, 'destination' => dest_dir})
      end

      @site = Site.new(Jekyll.configuration)
      @site.process
      @index = File.read(dest_dir('index.html'))
    end

    should "ensure post count is as expected" do
      assert_equal 24, @site.posts.size
    end

    should "insert site.posts into the index" do
      assert @index.include?("#{@site.posts.size} Posts")
    end

    should "render latest post's content" do
      assert @index.include?(@site.posts.last.content)
    end

    should "hide unpublished posts" do
      published = Dir[dest_dir('publish_test/2008/02/02/*.html')].map {|f| File.basename(f)}

      assert_equal 1, published.size
      assert_equal "published.html", published.first
    end

    should "not copy _posts directory" do
      assert !File.exist?(dest_dir('_posts'))
    end

    should "process other static files and generate correct permalinks" do
      assert File.exists?(dest_dir('/about/index.html'))
      assert File.exists?(dest_dir('/contacts.html'))
    end
    
    should "render all categories and corresponding posts" do
      category_listing = File.read(dest_dir('category_listing.html'))
      @site.categories.each do |c, posts|
        assert category_listing.include?(c)
        posts.each { |p| assert category_listing.include?(p.to_liquid['title']) }
      end
    end
    
    should "create yearly archive for 2008" do
      filename = File.join(dest_dir, '2008', 'index.html')
      assert File.exists?(filename)
      assert File.read(filename).include?("<h1>2008</h1>")
    end

    should "create monthly archive for 2008/02" do
      filename = File.join(dest_dir, '2008', '02', 'index.html')
      assert File.exists?(filename)
      assert File.read(filename).include?("<h1>February 2008</h1>")
    end

    should "create daily archive for 2008/02/02" do
      filename = File.join(dest_dir, '2008', '02', '02', 'index.html')
      assert File.exists?(filename)
      assert File.read(filename).include?("<h1>February 2, 2008</h1>")
    end
  end
end
