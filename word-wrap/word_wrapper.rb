require 'minitest/autorun'

def word_wrap(string, col_num)
  lines = []

  pointer = 0
  last_break_pointer = 0
  while pointer < (string.size - 1)
    pointer += 1
    if (pointer - last_break_pointer) > col_num
      lines << string[last_break_pointer...pointer].strip
      last_break_pointer = pointer
    end
  end
  lines << string[last_break_pointer..].strip

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
