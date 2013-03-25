require_relative "prelude"

class Post < Ohm::Model
  include Ohm::Composite

  attribute :a
  attribute :c

  attribute :a_b
  attribute :b_c

  composite_unique [:a, :b_c]
  composite_unique [:a_b, :c]
end

scope do
  test "does not confuse names" do
    post1 = Post.create(a: "a", b_c: "b_c")

    assert_equal post1, Post.composite_with(a: "a", b_c: "b_c")
    assert_equal nil, Post.composite_with(a_b: "a_b", c: "c")

    post2 = Post.create(a_b: "a_b", c: "c")

    assert_equal post1, Post.composite_with(a: "a", b_c: "b_c")
    assert_equal post2, Post.composite_with(a_b: "a_b", c: "c")
  end
end
