module CurrentUserHelperService
  def active_user
    Thread.current[:active_user]
  end

  def self.active_user=(user)
    Thread.current[:active_user] = user
  end
end
