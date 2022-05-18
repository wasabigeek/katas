require 'minitest/autorun'

def word_wrap(string, col_num)
  lines = []

  pointer = 0
  last_break_pointer = 0
  last_word_start_pointer = 0
  while pointer < (string.size - 1)
    # check if this is start of a new word
    last_word_start_pointer = pointer if pointer.positive? && string[pointer - 1] == ' '

    pointer += 1
    if (pointer - last_break_pointer) >= col_num
      # TODO: punctuation?
      if string[pointer] != ' ' # mid-word
        if string[pointer + 1] && string[pointer + 1] != ' ' # long word - this is pretty shaky logic
          # break and hyphenate
          lines << string[last_break_pointer...pointer - 1].strip + '-'
          pointer -= 1
          last_break_pointer = pointer
        else
          # break at the end of the previous word instead
          lines << string[last_break_pointer...last_word_start_pointer].strip
          last_break_pointer = last_word_start_pointer
          pointer = last_break_pointer
        end
      else
        lines << string[last_break_pointer...pointer].strip
        last_break_pointer = pointer
      end
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
