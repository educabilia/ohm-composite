require_relative "prelude"

class Post < Ohm::Model
  include Ohm::Composite

  attribute :foo
  attribute :bar
  attribute :baz

  attribute :bar_baz
  attribute :baz_foo

  composite_unique [:foo, :bar_baz]
  composite_unique [:bar, :baz_foo]
end

scope do
  test "does not confuse names" do
    post1 = Post.create(foo: "foo", bar_baz: "bar_baz")

    assert_equal post1, Post.composite_with(foo: "foo", bar_baz: "bar_baz")
    assert_equal nil, Post.composite_with(bar: "bar_baz", baz_foo: "foo")

    post2 = Post.create(bar: "bar_baz", baz_foo: "foo")

    assert_equal post1, Post.composite_with(foo: "foo", bar_baz: "bar_baz")
    assert_equal post2, Post.composite_with(bar: "bar_baz", baz_foo: "foo")
  end
end
