# Configuration defaults are shown below

#AppConfig[:data_directory] = File.join(Dir.home, "ArchivesSpace")
#AppConfig[:backup_directory] = proc { File.join(AppConfig[:data_directory], "db_backups") }
#AppConfig[:solr_index_directory] = proc { File.join(AppConfig[:data_directory], "solr_index") }
#AppConfig[:solr_home_directory] = proc { File.join(AppConfig[:data_directory], "solr_home") }
#AppConfig[:solr_indexing_frequency_seconds] = 30
# The default thread count is 4. Set to 1 until the performance of solr is improved.
# Solr was in bad performance when re-index of ArchivesSpace was going.
AppConfig[:indexer_thread_count] = 1
#
#AppConfig[:default_page_size] = 10
#AppConfig[:max_page_size] = 250
#
#AppConfig[:allow_other_unmapped] = false
#
#AppConfig[:db_url] = proc { AppConfig.demo_db_url }
#AppConfig[:db_url] = ENV['ASPACE_DB_URL']
#AppConfig[:db_max_connections] = 10
## Set to true if you have enabled MySQL binary logging
#AppConfig[:mysql_binlog] = false
#
#AppConfig[:allow_unsupported_database] = false
#AppConfig[:allow_non_utf8_mysql_database] = false
#
#AppConfig[:demo_db_backup_schedule] = "0 4 * * *"
# AppConfig[:demo_db_backup_number_to_keep] = 7

# Omniauth configuration for Aspace:
# https://github.com/lyrasis/aspace-oauth
# https://github.com/dlindahl/omniauth-cas
AppConfig[:authentication_sources] = [
  {
        model: 'ASOauth',
        provider: 'cas',
        label: 'UMD Log-In',
        config: {
          url: 'https://login.umd.edu',
          host: 'login.umd.edu',
          ssl: true,
          disable_ssl_verification: false,
          login_url: '/cas/login',
          logout_url: '/cas/logout',
          service_validate_url: '/cas/serviceValidate',
          fetch_raw_info: ->(s, o, t, user_info) {  { email: "#{user_info['user']}@umd.edu" } }
        }
  }
]


#
#AppConfig[:solr_backup_directory] = proc { File.join(AppConfig[:data_directory], "solr_backups") }
#AppConfig[:solr_backup_schedule] = "0 * * * *"
#AppConfig[:solr_backup_number_to_keep] = 1
#
#AppConfig[:backend_url] = "http://#{ENV['SERVER_NAME']}:8083"
# AppConfig[:frontend_url] = "http://#{ENV['SERVER_NAME']}:8080"
# AppConfig[:solr_url] = ENV['ASPACE_SOLR_URL']
# AppConfig[:public_url] = "http://#{ENV['SERVER_NAME']}:8081"
# AppConfig[:frontend_proxy_url] = "https://#{ENV['SERVER_NAME']}"
AppConfig[:frontend_proxy_url] = 'http://localhost/staff'
# AppConfig[:public_proxy_url] = "https://#{ENV['PUBLIC_SERVER_NAME']}"
#
## Setting any of the four keys below to false will prevent the associated
## applications from starting. Temporarily disabling the frontend and public
## UIs and/or the indexer may help users who are running into memory-related
## issues during migration.
#
#AppConfig[:enable_backend] = true
#AppConfig[:enable_frontend] = true
#AppConfig[:enable_public] = true
#AppConfig[:enable_indexer] = true
# AppConfig[:enable_solr] = (ENV['ASPACE_EXTERNAL_SOLR'] != 'true')
#
## If you have multiple instances of the backend running behind a load
## balancer, list the URL of each backend instance here.  This is used by the
## real-time indexing, which needs to connect directly to each running
## instance.
##
## By default we assume you're not using a load balancer, so we just connect
## to the regular backend URL.
##
#AppConfig[:backend_instance_urls] = proc { [AppConfig[:backend_url]] }
#
#AppConfig[:frontend_theme] = "default"
#AppConfig[:public_theme] = "default"
#
#AppConfig[:session_expire_after_seconds] = 3600
#
#AppConfig[:search_username] = "search_indexer"
#
#AppConfig[:public_username] = "public_anonymous"
#
#AppConfig[:staff_username] = "staff_system"
#
#AppConfig[:authentication_sources] = []
#
#AppConfig[:realtime_index_backlog_ms] = 60000
#
#AppConfig[:notifications_backlog_ms] = 60000
#AppConfig[:notifications_poll_frequency_ms] = 1000
#
#AppConfig[:max_usernames_per_source] = 50
#
#AppConfig[:demodb_snapshot_flag] = proc { File.join(AppConfig[:data_directory], "create_demodb_snapshot.txt") }
#
#AppConfig[:locale] = :en
#
## Report Configuration
## :report_page_layout uses valid values for the  CSS3 @page directive's
## size property: http://www.w3.org/TR/css3-page/#page-size-prop
#AppConfig[:report_page_layout] = "letter landscape"
#
## Plug-ins to load. They will load in the order specified
AppConfig[:plugins] = ['local', 'aspace_feedback', 'lcnaf', 'payments_module',
                       'aspace-search-identifier', 'aspace-oauth',
                       'aspace_yale_accessions', 'default_text_for_notes',
                       'and_search', 'digitization_work_order',
                       'umd-lib-aspace-theme', 'aspace-import-excel']

unless ENV['DISABLE_AEON_REQUEST'] == 'true'
  AppConfig[:plugins] << 'aeon_fulfillment' << 'umd_aeon_fulfillment'
  AppConfig[:aeon_fulfillment] = {
    'scua' => {
      request_in_new_tab: true,
      requests_permitted_for_containers_only: true,
      aeon_web_url: 'https://aeon.lib.umd.edu/logon/',
      aeon_return_link_label: 'UMD Archives',
      aeon_site_code: 'MDRM'
    },
    'mspal' => {
      request_in_new_tab: true,
      requests_permitted_for_containers_only: true,
      aeon_web_url: 'https://aeon.lib.umd.edu/logon/',
      aeon_return_link_label: 'UMD Archives',
      aeon_site_code: 'SCPA'
    }
  }
end

AppConfig[:pui_page_actions_request] = false

# Ensure that the handle service plugin gets loaded last
AppConfig[:plugins] <<  "aspace-umd-lib-handle-service"

# by default we go to fedoradev unless we're on stage or prod.
AppConfig[:umd_handle_server_url] = case AppConfig[:backend_url] 
when /aspacestage.lib.umd.edu/
  "http://fedorastage.lib.umd.edu/handle/"
when /aspace.lib.umd.edu/
  "http://fedora.lib.umd.edu/handle/"
else
  "http://fedoradev.lib.umd.edu/handle/"
end

# Handles will be minted with the PUI Url to a resource and its PID. 
# A pid is the resource's identifier, with this namespace prefix
AppConfig[:umd_handle_namespace] = "archives"



## Allow an unauthenticated user to create an account
#AppConfig[:allow_user_registration] = true
#
## Help Configuration
#AppConfig[:help_enabled] = true
#AppConfig[:help_url] = "http://docs.archivesspace.org"
#AppConfig[:help_topic_prefix] = "/Default_CSH.htm#"

# AppConfig[:resequence_on_startup] = false # JAW 2015-01-09 set to true for upgrade; false for normal restarts

# container plugin migration -- 06-04-2016 //JAW
# AppConfig[:migrate_to_container_management] = false

# AppConfig[:enable_jasper] = true
# AppConfig[:compile_jasper] = true

AppConfig[:pui_hide][:accessions] = true
AppConfig[:pui_hide][:classifications] = true
AppConfig[:pui_hide][:subjects] = true
AppConfig[:pui_hide][:agents] = true
AppConfig[:pui_hide][:search_tab] = true
AppConfig[:public_theme] = 'umd-lib-aspace-theme'

AppConfig[:public_google_analytics_code] = ENV['PUBLIC_GOOGLE_ANALYTICS_CODE']


AppConfig[:record_inheritance] = {
  :archival_object => {
    :inherited_fields => [
                          {
                            :property => 'title',
                            :inherit_directly => true
                          },
                          {
                            :property => 'component_id',
                            :inherit_directly => false
                          },
                          {
                            :property => 'language',
                            :inherit_directly => true
                          },
                          {
                            :property => 'dates',
                            :inherit_directly => true
                          },
                          {
                            :property => 'linked_agents',
                            :inherit_if => proc {|json| json.select {|j| j['role'] == 'creator'} },
                            :inherit_directly => false
                          },
                          {
                            :property => 'notes',
                            :inherit_if => proc {|json| json.select {|j| j['type'] == 'accessrestrict'} },
                            :inherit_directly => true
                          },
                          {
                            :property => 'notes',
                            :inherit_if => proc {|json| json.select {|j| j['type'] == 'langmaterial'} },
                            :inherit_directly => false
                          },
                         ]
  }
}
