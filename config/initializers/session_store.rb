ActionController::Base.session = {
  :key         => '_mylibrary_session',
  :secret      => Settings.session.secret
}
