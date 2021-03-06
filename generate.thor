require 'pry'
require 'redcarpet'

class Generate < Thor
  include Thor::Actions

  desc "index", "generate index.html from README.md"
  def index
    puts "Processing README.md to generate a new index.html..."

    relative_path_to_readme = "README.md"
    relative_path_to_index = "index.html"

    # `r` means we're using the "read" mode with the file
    # we need a String for Redcarpet, it doesn't accept File objects.
    string = File.open(relative_path_to_readme, 'r') { |file| file.read }
    markdown = ::Redcarpet::Markdown.new(Redcarpet::Render::HTML, extensions = {})

    rendered_markdown = markdown.render(string)

    html_output = template { rendered_markdown }

    File.open(relative_path_to_index, 'w') { |file| file.write(html_output) }

    puts "All done!"
  end

  private

  def template(&block)
    <<-HTML.gsub /^\s+/, ""
      <html>
        <head>
          <title>Keep a Changelog</title>
          <link rel="stylesheet" href="assets/stylesheets/normalize.css" media="screen" charset="utf-8">
          <link rel="stylesheet" href="assets/stylesheets/style.css" media="screen" charset="utf-8">
          <script type="text/javascript" src="//use.typekit.net/tng8liq.js"></script>
          <script type="text/javascript">try{Typekit.load();}catch(e){}</script>
        </head>
        <body>
          <article>
            #{yield}
            <footer class="clearfix">
              <p class="license">This project is <a href="http://choosealicense.com/licenses/mit/">MIT Licensed</a>.</p>
              <p class="about"><a href="https://github.com/olivierlacan/keep-a-changelog/">Typed</a> with trepidation by <a href="http://olivierlacan.com">Olivier Lacan</a> from <a href="http://codeschool.com">Code School</a>.</p>
            </footer>
          </article>
          <script type="text/javascript">
            var _gauges = _gauges || [];
            (function() {
              var t   = document.createElement('script');
              t.type  = 'text/javascript';
              t.async = true;
              t.id    = 'gauges-tracker';
              t.setAttribute('data-site-id', '5389808eeddd5b055a00440d');
              t.src = '//secure.gaug.es/track.js';
              var s = document.getElementsByTagName('script')[0];
              s.parentNode.insertBefore(t, s);
            })();
          </script>
        </body>
      </html>
    HTML
  end
end
