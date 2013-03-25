Ohm::Composite
==============

Provides composite regular and unique indices for [Ohm][1].

Usage
-----

```ruby
require "ohm/composite"

class Post
  include Ohm::Composite

  attribute :user_id
  attribute :date
  attribute :slug

  composite_index [:user_id, :date]
  composite_unique [:user_id, :slug]
end

Post.composite_find(user_id: 1, date: Date.today)
Post.composite_with(user_id: 1, slug: "lorem-ipsum")
```

License
-------

See `UNLICENSE`. With love, from [Educabilia](http://educabilia.com).

[1]: https://github.com/soveran/ohm
