require_relative "prelude"

class Post < Ohm::Model
  include Ohm::Composite

  attribute :date
  attribute :slug

  composite_index [:date, :slug]
end

class Rating < Ohm::Model
  include Ohm::Composite

  attribute :user_id
  attribute :post_id

  composite_unique [:user_id, :post_id]
end

scope do
  def assert_empty(value)
    flunk("#{value} is not empty.") unless value.empty?
    success
  end

  test "find" do
    post = Post.create(date: "2013-03-23", slug: "lorem-ipsum")

    assert_equal [post], Post.composite_find(date: "2013-03-23", slug: "lorem-ipsum").to_a
    assert_empty Post.composite_find(date: "2013-03-23", slug: "dolor-sit").to_a
  end

  test "find with different hash order" do
    post = Post.create(date: "2013-03-23", slug: "lorem-ipsum")

    assert_equal [post], Post.composite_find(slug: "lorem-ipsum", date: "2013-03-23").to_a
  end

  test "fails with unknown indices" do
    assert_raise { Post.composite_find(slug: "foo") }
  end

  test "does not confuse values when joining" do
    post1 = Post.create(date: "2013-03-23:lorem", slug: "ipsum")
    post2 = Post.create(date: "2013-03-23", slug: "lorem:ipsum")

    assert_equal [post1], Post.composite_find(date: "2013-03-23:lorem", slug: "ipsum").to_a
    assert_equal [post2], Post.composite_find(date: "2013-03-23", slug: "lorem:ipsum").to_a
  end
end

scope do
  test "unique" do
    Rating.create(user_id: 1, post_id: 2)

    assert_raise(Ohm::UniqueIndexViolation) do
      Rating.create(user_id: 1, post_id: 2)
    end

    assert_raise(Ohm::UniqueIndexViolation) do
      Rating.create(post_id: 2, user_id: 1)
    end
  end

  test "find unique" do
    rating = Rating.create(user_id: 1, post_id: 2)

    assert_equal rating, Rating.composite_with(user_id: 1, post_id: 2)
    assert_equal rating, Rating.composite_with(post_id: 2, user_id: 1)
  end
end

scope do
  test "with or create" do
    rating = Rating.composite_with_or_create(user_id: 1, post_id: 2)

    assert rating

    assert_equal rating, Rating.composite_with_or_create(user_id: 1, post_id: 2)
  end

  test "contention" do
    results = []

    threads = Array.new(10) do
      Thread.new do
        10.times do |i|
          results << Rating.composite_with_or_create(user_id: i, post_id: 2)
        end
      end
    end

    threads.each(&:join)

    assert !results.include?(nil)
    assert_equal 10, results.uniq.size
  end
end
