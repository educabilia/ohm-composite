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

"Find or create"
----------------

Often times you need to find an instance by its uniqueness, or create
it if it's not found.

For this purpose there's `composite_with_or_create`:

```ruby
Post.composite_with_or_create(user_id: 1, slug: "lorem-ipsum")
```

This is guaranteed to be contention-safe: if two competing threads or
processes end up in the create branch, only one will win and the other
will receive the created instance. None of them will raise exceptions
nor receive nils.

License
-------

See `UNLICENSE`. With love, from [Educabilia](http://educabilia.com).

[1]: https://github.com/soveran/ohm
