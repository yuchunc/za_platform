# -*- encoding: utf-8 -*-
# stub: opentok 3.0.3 ruby lib

Gem::Specification.new do |s|
  s.name = "opentok".freeze
  s.version = "3.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Stijn Mathysen".freeze, "Karmen Blake".freeze, "Song Zheng".freeze, "Patrick Quinn-Graham".freeze, "Ankur Oberoi".freeze]
  s.date = "2018-09-12"
  s.description = "OpenTok is an API from TokBox that enables websites to weave live group video communication into their online experience. With OpenTok you have the freedom and flexibility to create the most engaging web experience for your users. This gem lets you generate sessions and tokens for OpenTok applications. It also includes support for working with OpenTok 2.0 archives. See <http://tokbox.com/opentok/platform> for more details.".freeze
  s.email = ["stijn@skylight.be".freeze, "karmenblake@gmail.com".freeze, "song@tokbox.com".freeze, "pqg@tokbox.com".freeze, "ankur@tokbox.com".freeze]
  s.files = [".gitignore".freeze, ".travis.yml".freeze, ".yardopts".freeze, "CONTRIBUTING.md".freeze, "DEVELOPING.md".freeze, "Gemfile".freeze, "LICENSE".freeze, "README.md".freeze, "Rakefile".freeze, "lib/opentok.rb".freeze, "lib/opentok/archive.rb".freeze, "lib/opentok/archive_list.rb".freeze, "lib/opentok/archives.rb".freeze, "lib/opentok/client.rb".freeze, "lib/opentok/constants.rb".freeze, "lib/opentok/exceptions.rb".freeze, "lib/opentok/extensions/hash.rb".freeze, "lib/opentok/opentok.rb".freeze, "lib/opentok/session.rb".freeze, "lib/opentok/sip.rb".freeze, "lib/opentok/token_generator.rb".freeze, "lib/opentok/version.rb".freeze, "opentok.gemspec".freeze, "sample/Archiving/Gemfile".freeze, "sample/Archiving/README.md".freeze, "sample/Archiving/archiving_sample.rb".freeze, "sample/Archiving/public/css/sample.css".freeze, "sample/Archiving/public/img/archiving-off.png".freeze, "sample/Archiving/public/img/archiving-on-idle.png".freeze, "sample/Archiving/public/img/archiving-on-message.png".freeze, "sample/Archiving/public/js/host.js".freeze, "sample/Archiving/public/js/participant.js".freeze, "sample/Archiving/views/history.erb".freeze, "sample/Archiving/views/host.erb".freeze, "sample/Archiving/views/index.erb".freeze, "sample/Archiving/views/layout.erb".freeze, "sample/Archiving/views/participant.erb".freeze, "sample/HelloWorld/Gemfile".freeze, "sample/HelloWorld/README.md".freeze, "sample/HelloWorld/hello_world.rb".freeze, "sample/HelloWorld/public/js/helloworld.js".freeze, "sample/HelloWorld/views/index.erb".freeze, "spec/cassettes/OpenTok_Archives/should_create_archives.yml".freeze, "spec/cassettes/OpenTok_Archives/should_create_audio_only_archives.yml".freeze, "spec/cassettes/OpenTok_Archives/should_create_individual_archives.yml".freeze, "spec/cassettes/OpenTok_Archives/should_create_named_archives.yml".freeze, "spec/cassettes/OpenTok_Archives/should_delete_an_archive_by_id.yml".freeze, "spec/cassettes/OpenTok_Archives/should_find_archives_by_id.yml".freeze, "spec/cassettes/OpenTok_Archives/should_find_archives_with_unknown_properties.yml".freeze, "spec/cassettes/OpenTok_Archives/should_find_expired_archives.yml".freeze, "spec/cassettes/OpenTok_Archives/should_find_paused_archives_by_id.yml".freeze, "spec/cassettes/OpenTok_Archives/should_stop_archives.yml".freeze, "spec/cassettes/OpenTok_Archives/when_many_archives_are_created/should_return_all_archives.yml".freeze, "spec/cassettes/OpenTok_Archives/when_many_archives_are_created/should_return_archives_with_an_offset.yml".freeze, "spec/cassettes/OpenTok_Archives/when_many_archives_are_created/should_return_count_number_of_archives.yml".freeze, "spec/cassettes/OpenTok_Archives/when_many_archives_are_created/should_return_part_of_the_archives_when_using_offset_and_count.yml".freeze, "spec/cassettes/OpenTok_Archives/when_many_archives_are_created/should_return_session_archives.yml".freeze, "spec/cassettes/OpenTok_OpenTok/when_initialized_properly/_create_session/creates_always_archived_sessions.yml".freeze, "spec/cassettes/OpenTok_OpenTok/when_initialized_properly/_create_session/creates_default_sessions.yml".freeze, "spec/cassettes/OpenTok_OpenTok/when_initialized_properly/_create_session/creates_relayed_media_sessions.yml".freeze, "spec/cassettes/OpenTok_OpenTok/when_initialized_properly/_create_session/creates_relayed_media_sessions_for_invalid_media_modes.yml".freeze, "spec/cassettes/OpenTok_OpenTok/when_initialized_properly/_create_session/creates_relayed_media_sessions_with_a_location_hint.yml".freeze, "spec/cassettes/OpenTok_OpenTok/when_initialized_properly/_create_session/creates_routed_media_sessions.yml".freeze, "spec/cassettes/OpenTok_OpenTok/when_initialized_properly/_create_session/creates_routed_media_sessions_with_a_location_hint.yml".freeze, "spec/cassettes/OpenTok_OpenTok/when_initialized_properly/_create_session/creates_sessions_with_a_location_hint.yml".freeze, "spec/cassettes/OpenTok_OpenTok/when_initialized_properly/with_an_addendum_to_the_user_agent_string/should_append_the_addendum_to_the_user_agent_header.yml".freeze, "spec/cassettes/OpenTok_Sip/receives_a_valid_response.yml".freeze, "spec/matchers/token.rb".freeze, "spec/opentok/archives_spec.rb".freeze, "spec/opentok/opentok_spec.rb".freeze, "spec/opentok/session_spec.rb".freeze, "spec/opentok/sip_spec.rb".freeze, "spec/shared/opentok_generates_tokens.rb".freeze, "spec/shared/session_generates_tokens.rb".freeze, "spec/spec_helper.rb".freeze]
  s.homepage = "https://opentok.github.io/opentok-ruby-sdk".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.6".freeze
  s.summary = "Ruby gem for the OpenTok API".freeze
  s.test_files = ["spec/cassettes/OpenTok_Archives/should_create_archives.yml".freeze, "spec/cassettes/OpenTok_Archives/should_create_audio_only_archives.yml".freeze, "spec/cassettes/OpenTok_Archives/should_create_individual_archives.yml".freeze, "spec/cassettes/OpenTok_Archives/should_create_named_archives.yml".freeze, "spec/cassettes/OpenTok_Archives/should_delete_an_archive_by_id.yml".freeze, "spec/cassettes/OpenTok_Archives/should_find_archives_by_id.yml".freeze, "spec/cassettes/OpenTok_Archives/should_find_archives_with_unknown_properties.yml".freeze, "spec/cassettes/OpenTok_Archives/should_find_expired_archives.yml".freeze, "spec/cassettes/OpenTok_Archives/should_find_paused_archives_by_id.yml".freeze, "spec/cassettes/OpenTok_Archives/should_stop_archives.yml".freeze, "spec/cassettes/OpenTok_Archives/when_many_archives_are_created/should_return_all_archives.yml".freeze, "spec/cassettes/OpenTok_Archives/when_many_archives_are_created/should_return_archives_with_an_offset.yml".freeze, "spec/cassettes/OpenTok_Archives/when_many_archives_are_created/should_return_count_number_of_archives.yml".freeze, "spec/cassettes/OpenTok_Archives/when_many_archives_are_created/should_return_part_of_the_archives_when_using_offset_and_count.yml".freeze, "spec/cassettes/OpenTok_Archives/when_many_archives_are_created/should_return_session_archives.yml".freeze, "spec/cassettes/OpenTok_OpenTok/when_initialized_properly/_create_session/creates_always_archived_sessions.yml".freeze, "spec/cassettes/OpenTok_OpenTok/when_initialized_properly/_create_session/creates_default_sessions.yml".freeze, "spec/cassettes/OpenTok_OpenTok/when_initialized_properly/_create_session/creates_relayed_media_sessions.yml".freeze, "spec/cassettes/OpenTok_OpenTok/when_initialized_properly/_create_session/creates_relayed_media_sessions_for_invalid_media_modes.yml".freeze, "spec/cassettes/OpenTok_OpenTok/when_initialized_properly/_create_session/creates_relayed_media_sessions_with_a_location_hint.yml".freeze, "spec/cassettes/OpenTok_OpenTok/when_initialized_properly/_create_session/creates_routed_media_sessions.yml".freeze, "spec/cassettes/OpenTok_OpenTok/when_initialized_properly/_create_session/creates_routed_media_sessions_with_a_location_hint.yml".freeze, "spec/cassettes/OpenTok_OpenTok/when_initialized_properly/_create_session/creates_sessions_with_a_location_hint.yml".freeze, "spec/cassettes/OpenTok_OpenTok/when_initialized_properly/with_an_addendum_to_the_user_agent_string/should_append_the_addendum_to_the_user_agent_header.yml".freeze, "spec/cassettes/OpenTok_Sip/receives_a_valid_response.yml".freeze, "spec/matchers/token.rb".freeze, "spec/opentok/archives_spec.rb".freeze, "spec/opentok/opentok_spec.rb".freeze, "spec/opentok/session_spec.rb".freeze, "spec/opentok/sip_spec.rb".freeze, "spec/shared/opentok_generates_tokens.rb".freeze, "spec/shared/session_generates_tokens.rb".freeze, "spec/spec_helper.rb".freeze]

  s.installed_by_version = "2.7.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.5"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.1.1"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 2.14.1"])
      s.add_development_dependency(%q<webmock>.freeze, ["~> 2.3.2"])
      s.add_development_dependency(%q<vcr>.freeze, ["~> 2.8.0"])
      s.add_development_dependency(%q<yard>.freeze, ["~> 0.9.11"])
      s.add_runtime_dependency(%q<addressable>.freeze, ["~> 2.3"])
      s.add_runtime_dependency(%q<httparty>.freeze, ["~> 0.15.5"])
      s.add_runtime_dependency(%q<activesupport>.freeze, [">= 2.0"])
      s.add_runtime_dependency(%q<jwt>.freeze, ["~> 1.5.6"])
    else
      s.add_dependency(%q<bundler>.freeze, ["~> 1.5"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.1.1"])
      s.add_dependency(%q<rspec>.freeze, ["~> 2.14.1"])
      s.add_dependency(%q<webmock>.freeze, ["~> 2.3.2"])
      s.add_dependency(%q<vcr>.freeze, ["~> 2.8.0"])
      s.add_dependency(%q<yard>.freeze, ["~> 0.9.11"])
      s.add_dependency(%q<addressable>.freeze, ["~> 2.3"])
      s.add_dependency(%q<httparty>.freeze, ["~> 0.15.5"])
      s.add_dependency(%q<activesupport>.freeze, [">= 2.0"])
      s.add_dependency(%q<jwt>.freeze, ["~> 1.5.6"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.5"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.1.1"])
    s.add_dependency(%q<rspec>.freeze, ["~> 2.14.1"])
    s.add_dependency(%q<webmock>.freeze, ["~> 2.3.2"])
    s.add_dependency(%q<vcr>.freeze, ["~> 2.8.0"])
    s.add_dependency(%q<yard>.freeze, ["~> 0.9.11"])
    s.add_dependency(%q<addressable>.freeze, ["~> 2.3"])
    s.add_dependency(%q<httparty>.freeze, ["~> 0.15.5"])
    s.add_dependency(%q<activesupport>.freeze, [">= 2.0"])
    s.add_dependency(%q<jwt>.freeze, ["~> 1.5.6"])
  end
end
