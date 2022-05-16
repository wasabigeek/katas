require 'minitest/autorun'

def word_wrap(string, col_num)
  lines = []

  counter = 0
  wrapped = ''
  string.each_char do |char|
    wrapped += char
    counter += 1
    if counter == col_num
      lines << wrapped.lstrip
      wrapped = ''
      counter = 0
    end
  end
  lines << wrapped.lstrip if wrapped != ''

  lines.join("\n")
end

class WordWrapTest < Minitest::Test
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

  # def test_splits_do_not_break_small_words
  #   string = 'lorem ipsum dolor sit amet'
  #   wrapped = word_wrap(string, 20)
  #   assert_equal("lorem ipsum dolor\n sit amet", wrapped)
  # end
end
