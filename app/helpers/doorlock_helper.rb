module DoorlockHelper
  def lock_state(last_lock_state)
    if last_lock_state.updated_at < 2.minutes.ago
      'error'
    else
      last_lock_state.lock_state
    end
  end

  def background_color(last_lock_state)
    case last_lock_state
    when 'open'
      'bg-warning'
    when 'locked'
      'bg-info'
    else
      'bg-danger'
    end
  end

  def translate(last_lock_state)
    if last_lock_state.updated_at < 2.minutes.ago
      I18n.t('states.error', timestamp: Date.strptime(last_lock_state.updated_at, '%F %R'))
    else
      I18n.t "states.#{last_lock_state.lock_state}"
    end
  end
end
