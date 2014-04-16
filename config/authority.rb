Authority.configure do |config|

  config.controller_action_map = {
     :index   => 'read',
     :show    => 'read',
     :new     => 'create',
     :create  => 'create',
     :edit    => 'update',
     :update  => 'update',
     :destroy => 'delete',
     :agree   => 'agree',
     :disagree => 'disagree',
     :realize => 'realize',
     :unrealize => 'unrealize',
     :set_seen => 'set_seen',
     :recent => 'recent',
     :bs => 'bs',
     :comment => 'comment'
     
  }
end
