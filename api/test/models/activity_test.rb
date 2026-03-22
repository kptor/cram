require "test_helper"

class ActivityTest < ActiveSupport::TestCase
  test "requires a title" do
    activity = Activity.new(user: create(:user))
    assert_not activity.valid?
    assert_includes activity.errors[:title], "can't be blank"
  end

  test "creates with parts and choices" do
    user = create(:user)
    activity = Activity.create!(title: "Test", user: user)

    mc = Activity::MultipleChoice.create!(prompt: "What is 1+1?")
    Activity::Part.create!(activity: activity, partable: mc, position: 0)
    Activity::MultipleChoice::Choice.create!(multiple_choice: mc, label: "2", correct: true, position: 0)
    Activity::MultipleChoice::Choice.create!(multiple_choice: mc, label: "3", correct: false, position: 1)

    assert_equal 1, activity.parts.count
    assert_equal 2, mc.choices.count
    assert_equal "Activity::MultipleChoice", activity.parts.first.partable_type
  end
end
