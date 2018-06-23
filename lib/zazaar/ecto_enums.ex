import EctoEnum

defenum(UserTierEnum, :user_tier, [:viewer, :streamer])

defenum(OpenTokRoleEnum, :ot_role, [:subscriber, :publisher, :moderator])

defenum(NoticeSchemaEnum, :notice_schemas, [
  :new_follower,
  :followee_is_live,
  :new_message,
  :new_post
])
