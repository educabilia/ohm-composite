require "ohm"

module Ohm::Composite
  VERSION = "0.1.0"

  def self.included(model)
    model.extend(Macros)
  end

  def self.method_name(attrs)
    :"_composite_#{join(attrs, "_")}"
  end

  def self.values(values)
    join(values, ":")
  end

  def self.join(elements, char)
    replacement = char * 2

    elements.map { |e| e.to_s.gsub(char, replacement) }.join(char)
  end

  module Macros
    def composite_unique(attrs)
      unique(_composite(attrs))
    end

    def composite_index(attrs)
      index(_composite(attrs))
    end

    def composite_with(hash)
      keys = hash.keys.sort
      values = keys.map { |k| hash[k] }

      with(Ohm::Composite.method_name(keys), Ohm::Composite.values(values))
    end

    def composite_find(hash)
      keys = hash.keys.sort
      values = keys.map { |k| hash[k] }

      find(Ohm::Composite.method_name(keys) => Ohm::Composite.values(values))
    end

    def composite_with_or_create(hash)
      composite_with(hash) ||
        begin
          create(hash)
        rescue Ohm::UniqueIndexViolation
          composite_with(hash)
        end
    end

    def _composite(attrs)
      attrs = attrs.sort

      method_name = Ohm::Composite.method_name(attrs)

      define_method(method_name) { Ohm::Composite.values(attrs.map { |att| send(att) }) }

      method_name
    end
  end
end
