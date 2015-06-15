require "test_helper"

class BuilderTest < ::MiniTest::Test
  include ::AST::Sexp

  def test_statement_scope_0_children
    expected = s(:statement_scope, nil)
    actual = ::CSDL::Builder.new.statement_scope {}
    assert_equal(expected, actual)
  end

  def test_statement_scope_1_child
    expected = s(:statement_scope,
                 s(:filter,
                  s(:target, "foo"),
                  s(:operator, "bar"),
                  s(:argument,
                    s(:string, "baz"))))

    actual = ::CSDL::Builder.new.statement_scope do
      filter("foo", "bar", "baz")
    end

    assert_equal(expected, actual)
  end

  def test_statement_scope_2_children
    expected = s(:statement_scope,
                 s(:filter,
                  s(:target, "this"),
                  s(:operator, "is"),
                  s(:argument,
                    s(:string, "first"))),
                 s(:filter,
                  s(:target, "this"),
                  s(:operator, "is"),
                  s(:argument,
                    s(:string, "second"))))

    actual = ::CSDL::Builder.new.statement_scope do
      [
        filter("this", "is", "first"),
        filter("this", "is", "second")
      ]
    end

    assert_equal(expected, actual)
  end

  def test_logical_group_0_children
    expected = s(:logical_group, nil)
    actual = ::CSDL::Builder.new.logical_group {}
    assert_equal(expected, actual)
  end

  def test_logical_group_1_child
    expected = s(:logical_group,
                 s(:filter,
                  s(:target, "foo"),
                  s(:operator, "bar"),
                  s(:argument,
                    s(:string, "baz"))))

    actual = ::CSDL::Builder.new.logical_group do
      filter("foo", "bar", "baz")
    end

    assert_equal(expected, actual)
  end

  def test_logical_group_2_children
    expected = s(:logical_group,
                 s(:filter,
                  s(:target, "this"),
                  s(:operator, "is"),
                  s(:argument,
                    s(:string, "first"))),
                 s(:filter,
                  s(:target, "this"),
                  s(:operator, "is"),
                  s(:argument,
                    s(:string, "second"))))

    actual = ::CSDL::Builder.new.logical_group do
      [
        filter("this", "is", "first"),
        filter("this", "is", "second")
      ]
    end

    assert_equal(expected, actual)
  end

  def test_or_0_children
    expected = s(:or, nil)
    actual = ::CSDL::Builder.new._or {}
    assert_equal(expected, actual)
  end

  def test_or_1_child
    expected = s(:or,
                 s(:filter,
                  s(:target, "foo"),
                  s(:operator, "bar"),
                  s(:argument,
                    s(:string, "baz"))))

    actual = ::CSDL::Builder.new._or do
      filter("foo", "bar", "baz")
    end

    assert_equal(expected, actual)
  end

  def test_or_2_children
    expected = s(:or,
                 s(:filter,
                  s(:target, "this"),
                  s(:operator, "is"),
                  s(:argument,
                    s(:string, "first"))),
                 s(:filter,
                  s(:target, "this"),
                  s(:operator, "is"),
                  s(:argument,
                    s(:string, "second"))))

    actual = ::CSDL::Builder.new._or do
      [
        filter("this", "is", "first"),
        filter("this", "is", "second")
      ]
    end

    assert_equal(expected, actual)
  end

  def test_and_0_children
    expected = s(:and, nil)
    actual = ::CSDL::Builder.new._and {}
    assert_equal(expected, actual)
  end

  def test_and_1_child
    expected = s(:and,
                 s(:filter,
                  s(:target, "foo"),
                  s(:operator, "bar"),
                  s(:argument,
                    s(:string, "baz"))))

    actual = ::CSDL::Builder.new._and do
      filter("foo", "bar", "baz")
    end

    assert_equal(expected, actual)
  end

  def test_and_2_children
    expected = s(:and,
                 s(:filter,
                  s(:target, "this"),
                  s(:operator, "is"),
                  s(:argument,
                    s(:string, "first"))),
                 s(:filter,
                  s(:target, "this"),
                  s(:operator, "is"),
                  s(:argument,
                    s(:string, "second"))))

    actual = ::CSDL::Builder.new._and do
      [
        filter("this", "is", "first"),
        filter("this", "is", "second")
      ]
    end

    assert_equal(expected, actual)
  end

  def test_filter_with_argument
    expected = s(:filter,
                 s(:target, "this"),
                 s(:operator, "is"),
                 s(:argument,
                   s(:string, "an argument")))

    actual = ::CSDL::Builder.new.filter("this", "is", "an argument")

    assert_equal(expected, actual)
  end

  def test_filter_without_argument
    expected = s(:filter,
                 s(:target, "foo"),
                 s(:operator, "bar"))

    actual = ::CSDL::Builder.new.filter("foo", "bar")

    assert_equal(expected, actual)
  end

  def test_not_with_argument
    expected = s(:not,
                 s(:target, "this"),
                 s(:operator, "is"),
                 s(:argument,
                   s(:string, "an argument")))

    actual = ::CSDL::Builder.new._not("this", "is", "an argument")

    assert_equal(expected, actual)
  end

  def test_not_without_argument
    expected = s(:not,
                 s(:target, "foo"),
                 s(:operator, "bar"))

    actual = ::CSDL::Builder.new._not("foo", "bar")

    assert_equal(expected, actual)
  end

  def test_return
    expected = s(:return,
                 s(:statement_scope,
                   s(:filter,
                     s(:target, "foo"),
                     s(:operator, "bar"))))

    actual = ::CSDL::Builder.new._return do
      filter("foo", "bar")
    end

    assert_equal(expected, actual)
  end

  def test_tag
    expected = s(:tag,
                 s(:tag_class,
                   s(:string, "MyTag")),
                 s(:statement_scope,
                   s(:filter,
                     s(:target, "foo"),
                     s(:operator, "bar"))))

    actual = ::CSDL::Builder.new.tag("MyTag") do
      filter("foo", "bar")
    end

    assert_equal(expected, actual)
  end

  def test_tag_tree
    expected = s(:tag,
                 s(:tag_nodes,
                   s(:tag_node, "foo"),
                   s(:tag_node, "bar")),
                 s(:tag_class,
                   s(:string, "MyTag")),
                 s(:statement_scope,
                   s(:filter,
                     s(:target, "baz"),
                     s(:operator, "quux"))))

    actual = ::CSDL::Builder.new.tag_tree(["foo", "bar"], "MyTag") do
      filter("baz", "quux")
    end

    assert_equal(expected, actual)
  end

end
