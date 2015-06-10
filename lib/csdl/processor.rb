require "ast"
include ::AST::Sexp

module CSDL
  class Processor < ::AST::Processor

    def on_and(node)
      initial = process(node.children.first)
      rest = node.children.drop(1)

      rest.reduce(initial) do |csdl, child|
        csdl += " AND " + process(child)
        csdl
      end
    end

    def on_argument(node)
      process(node.children.first)
    end

    def on_closure(node)
      "(" + process_all(node.children).join(" ") + ")"
    end

    def on_not(node)
      "NOT " + process(node.updated(:where))
    end

    def on_operator(node)
      node.children.first.to_s
    end

    def on_or(node)
      initial = process(node.children.first)
      rest = node.children.drop(1)

      rest.reduce(initial) do |csdl, child|
        csdl += " OR " + process(child)
        csdl
      end
    end

    def on_string(node)
      '"' + node.children.first.to_s.gsub(/"/, '\"') + '"'
    end

    def on_target(node)
      node.children.first.to_s
    end

    def on_where(node)
      target = node.children.find { |child| child.type == :target }
      operator = node.children.find { |child| child.type == :operator }
      argument = node.children.find { |child| child.type == :argument }
      process_all([ target, operator, argument ].compact).join(" ")
    end

  end
end


