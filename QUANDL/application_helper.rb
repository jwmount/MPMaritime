module ApplicationHelper

  class Utls
  # A panel will be rendered for each of these behaviors.  These MUST match :attribute method
  # names in DevelopmentalLevels.
  def behaviors
    ['facilitated_by_adult', 'initiated_by_child', 'sensory_motor', 'pleasure',
      'displeasure', 'with_object', 'sensory_motor_play', 'representational_play',
      'with_adult_support', 'independently', 'cross_context_1', 'cross_context_2',
      'cross_context_3', 'cross_context_4']
  end

  end
end