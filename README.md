# Jekyll::KrokiTag

A plugin that add feature \`text to diagram\` to Jekyll using [kroki.io](https://kroki.io/) hosting. To experiment with that code, run `bin/console` for an interactive prompt.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add jekyll-kroki-tag

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install jekyll-kroki-tag

## Usage

Add to config.

```yaml
plugins:
  - jekyll-kroki-tag
```

Write your content.

```liquid
{% kroki type: 'plantuml' %}
actor User
usecase "Write great code" as case
User -> case
{% endkroki %}
```

A Converted HTML as below.

```html
<figure class="jekyll-kroki" data-kroki-type="plantuml" data-kroki-format="svg">
  <img src="https://kroki.io/plantuml/svg/eJzjSkwuyS9SCC1OLeIqLU5NTixOVVAKL8osSVVIL0pNLFFIzk9JVVJILFYASXGB1Cno2kE4AHFnE90%3D" alt="">
</figure>
```

Now you don't need to convert every test-diagram image into real image file and store it and write its path in Markdown or HTML flle.

### Supported attribute

 * type ( required. PlantUML, Graphviz, Mermaid, ... )
 * format ( PNG, SVG, and more. default is svg )
 * alt
 * caption

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wtnabe/jekyll-kroki-tag.
