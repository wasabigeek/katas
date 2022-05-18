require 'minitest/autorun'

def word_wrap(string, col_num)
  words = string.split(' ')
  lines = []

  current_line = []
  while words.size > 0
    current_word = words.first
    sentence = (current_line + [current_word]).join(' ')

    if current_word.size >= col_num # long word
      lines << sentence[0...col_num - 1] + '-'
      words.shift
      words.unshift(sentence[col_num - 1..])
      current_line = []
    elsif sentence.size > col_num
      lines << current_line.join(' ')
      current_line = []
    else
      current_line << current_word
      words.shift
    end
  end
  lines << current_line.join(' ') if current_line.any?

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
