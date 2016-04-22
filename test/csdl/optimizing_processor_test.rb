require "test_helper"

class OptimizingProcessorTest < ::MiniTest::Test
  include ::AST::Sexp

  def test_converts_multiple_anded_contains_into_contains_all
    sexp = s(:and,
             s(:condition,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "apple"))),
             s(:condition,
               s(:target, "interaction.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "apple"))),
             s(:condition,
               s(:target, "tumblr.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "cat"))),
             s(:condition,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "book"))),
             s(:condition,
               s(:target, "interaction.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "book"))))
    expected = s(:and,
                 s(:condition,
                   s(:target, "fb.content"),
                   s(:operator, :contains_all),
                   s(:argument,
                     s(:string, "apple,book"))),
                 s(:condition,
                   s(:target, "interaction.content"),
                   s(:operator, :contains_all),
                   s(:argument,
                     s(:string, "apple,book"))),
                 s(:condition,
                   s(:target, "tumblr.content"),
                   s(:operator, :contains),
                   s(:argument,
                     s(:string, "cat"))))
    actual = CSDL::OptimizingProcessor.new.process(sexp)
    assert_equal(expected, actual)
  end

  def test_converts_multiple_anded_not_contains_into_not_contains_any
    sexp = s(:and,
             s(:not,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "apple"))),
             s(:not,
               s(:target, "interaction.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "apple"))),
             s(:not,
               s(:target, "tumblr.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "cat"))),
             s(:not,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "book"))),
             s(:not,
               s(:target, "interaction.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "book"))))
    expected = s(:and,
                 s(:not,
                   s(:target, "fb.content"),
                   s(:operator, :contains_any),
                   s(:argument,
                     s(:string, "apple,book"))),
                 s(:not,
                   s(:target, "interaction.content"),
                   s(:operator, :contains_any),
                   s(:argument,
                     s(:string, "apple,book"))),
                 s(:not,
                   s(:target, "tumblr.content"),
                   s(:operator, :contains),
                   s(:argument,
                     s(:string, "cat"))))
    actual = CSDL::OptimizingProcessor.new.process(sexp)
    assert_equal(expected, actual)
  end

  def test_converts_multiple_ored_contains_into_contains_any
    sexp = s(:or,
             s(:condition,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "apple"))),
             s(:condition,
               s(:target, "interaction.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "apple"))),
             s(:condition,
               s(:target, "tumblr.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "cat"))),
             s(:condition,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "book"))),
             s(:condition,
               s(:target, "interaction.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "book"))))
    expected = s(:or,
                 s(:condition,
                   s(:target, "fb.content"),
                   s(:operator, :contains_any),
                   s(:argument,
                     s(:string, "apple,book"))),
                 s(:condition,
                   s(:target, "interaction.content"),
                   s(:operator, :contains_any),
                   s(:argument,
                     s(:string, "apple,book"))),
                 s(:condition,
                   s(:target, "tumblr.content"),
                   s(:operator, :contains),
                   s(:argument,
                     s(:string, "cat"))))
    actual = CSDL::OptimizingProcessor.new.process(sexp)
    assert_equal(expected, actual)
  end

  def test_converts_multiple_ored_not_contains_into_not_contains_all
    sexp = s(:or,
             s(:not,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "apple"))),
             s(:not,
               s(:target, "interaction.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "apple"))),
             s(:not,
               s(:target, "tumblr.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "cat"))),
             s(:not,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "book"))),
             s(:not,
               s(:target, "interaction.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "book"))))
    expected = s(:or,
                 s(:not,
                   s(:target, "fb.content"),
                   s(:operator, :contains_all),
                   s(:argument,
                     s(:string, "apple,book"))),
                 s(:not,
                   s(:target, "interaction.content"),
                   s(:operator, :contains_all),
                   s(:argument,
                     s(:string, "apple,book"))),
                 s(:not,
                   s(:target, "tumblr.content"),
                   s(:operator, :contains),
                   s(:argument,
                     s(:string, "cat"))))
    actual = CSDL::OptimizingProcessor.new.process(sexp)
    assert_equal(expected, actual)
  end

  def test_collapses_and_into_condition
    sexp = s(:and,
             s(:condition,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "apple"))),
             s(:condition,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "apple"))))
    expected = s(:condition,
                 s(:target, "fb.content"),
                 s(:operator, :contains),
                 s(:argument,
                   s(:string, "apple")))
    actual = CSDL::OptimizingProcessor.new.process(sexp)
    assert_equal(expected, actual)
  end

  def test_keeps_other_operators
    sexp = s(:or,
             s(:condition,
               s(:target, "fb.content"),
               s(:operator, :contains),
               s(:argument,
                 s(:string, "apple"))),
             s(:condition,
               s(:target, "fb.content"),
               s(:operator, "=="),
               s(:argument,
                 s(:string, "book"))))
    expected = s(:or,
                 s(:condition,
                   s(:target, "fb.content"),
                   s(:operator, "=="),
                   s(:argument,
                     s(:string, "book"))),
                 s(:condition,
                   s(:target, "fb.content"),
                   s(:operator, :contains),
                   s(:argument,
                     s(:string, "apple"))))
    actual = CSDL::OptimizingProcessor.new.process(sexp)
    assert_equal(expected, actual)
  end
end
