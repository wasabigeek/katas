require 'minitest/autorun'

def word_wrap(string, col_num)
  slice_string(string, col_num).join("\n")
end

def slice_string(string, col_num)
  return [] if string.nil?
  return [string] if string.size < col_num

  line = string[0...col_num]
  remainder = string[col_num..]
  [line] + slice_string(remainder, col_num)
end

class WordWrapTest <
   Minitest::Test
  def test_does_nothing_to_string_within_col_num
    string = 'lorem ipsum'
    wrapped = word_wrap(string, 20)
    assert_equal(string, wrapped)
  end

  def test_splits_string_exceeding_col_num
    string = 'lorem ipsum dolor sit amet'
    wrapped = word_wrap(string, 21)
    assert_equal("lorem ipsum dolor sit\namet", wrapped)
  end

  def test_splits_do_not_break_small_words
    string = 'lorem ipsum dolor sit amet'
    wrapped = word_wrap(string, 20)
    assert_equal("lorem ipsum dolor\nsit amet", wrapped)
  end

  def test_large_words_are_broken_and_hyphenated
    string = 'loremipsumdolor sit amet'
    wrapped = word_wrap(string, 10)
    assert_equal("loremipsu-\nmdolor sit\namet", wrapped)
  end
end
