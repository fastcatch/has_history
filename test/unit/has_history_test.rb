require 'test_helper'

# NB: User model is not set up for has_history, the Post model is

class HasHistoryTest < ActiveSupport::TestCase

  def test_ar_extension_available
    assert_respond_to ActiveRecord::Base, :has_history, "ActiveRecord has_history extension is missing"
  end

  def test_if_models_are_valid
    assert_nothing_raised { Post.new }
    assert_nothing_raised { User.new }
    assert_nothing_raised { HistoryEntry.new }
  end

  def test_no_history_case
    user = User.create(:name => "Test User")
    assert_not_nil user, "User not created"
    user.email = "testuser@example.com"
    history_count = HistoryEntry.count
    assert user.save, "User not updated"
    assert_equal HistoryEntry.count, history_count, "A history entry is generated when none should have been"
  end

  def test_base_case
    history_count = HistoryEntry.count

    user = User.create(:name => "Test User")
    assert_not_nil user, "User not created"
    post = Post.create(:title => "Test title", :body => "Test body", :user => user)
    assert_not_nil post, "Post not created"
    post.body = "New body"
    assert post.save, "Post not updated"

    assert_equal HistoryEntry.count, history_count+1, "History entry not generated"
    
    history_entry = HistoryEntry.last
    assert_equal Post.first, history_entry.entity, "History entry points to a wrong entity"
    assert_equal -1, history_entry.modified_by_id, "History entry does not reference the modifier properly"
    
    assert_equal 1, history_entry.modifications.size, "History entry modifications count is off"
    modification = history_entry.modifications.first
    assert modification.has_key?("body"), "History entry modifications does not contain change"
    assert_equal "Test body", modification["body"][:before], "History entry modifications has a before value off"
    assert_equal "New body", modification["body"][:after], "History entry modifications has an after value off"
  end

  def test_reference_resolution
    history_count = HistoryEntry.count

    user = User.create(:name => "Test User")
    assert_not_nil user, "User not created"
    post = Post.create(:title => "Test title", :body => "Test body", :user => user)
    assert_not_nil post, "Post not created"
    post.user = nil
    assert post.save, "Post not updated"

    assert_equal HistoryEntry.count, history_count+1, "History entry not generated"
    
    history_entry = HistoryEntry.last
    modification = history_entry.modifications.first
    assert modification.has_key?("user"), "History entry modifications does not contain change"
    assert_equal "Test User", modification["user"][:before], "History entry modifications has a before value off"
    assert_equal nil, modification["user"][:after], "History entry modifications has an after value off"
  end
  
end
