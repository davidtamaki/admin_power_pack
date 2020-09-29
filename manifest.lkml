# You can point to a file right in the lookml project,
# or you can point to a url such as our github page.
application: admin_power_pack {
  label: "Admin Power Pack"
  file: "looker_admin_power_pack.js"
  #url: "https://davidtamaki.github.io/admin_power_pack/looker_admin_power_pack.js"
  entitlements: {
    local_storage: no
    navigation: yes
    new_window: yes
    allow_forms: yes
    allow_same_origin: no
    core_api_methods: [
      "all_roles", "all_users", "all_groups", "all_datagroups",
      "me", "user", "create_user", "update_user", "send_user_credentials_email_password_reset",
      "all_user_attributes", "set_user_attribute_user_value", "delete_user_attribute_user_value",
      "add_group_user", "delete_group_user", "set_user_roles",
      "all_dashboards", "dashboard", "run_query", "query_for_slug", "create_query",
      "all_scheduled_plans", "scheduled_plans_for_dashboard", "scheduled_plan_run_once",
      "create_scheduled_plan", "update_scheduled_plan", "delete_scheduled_plan",
      "create_user_credentials_email", "update_user_credentials_email",
      "delete_user_credentials_email", "delete_user_credentials_google", "delete_user_credentials_ldap", "delete_user_credentials_oidc", "delete_user_credentials_saml"
    ]
  } 
}

constant: CONNECTION_NAME {
  value: "admin_power_pack_stub"
  export: override_optional
}

constant: VERSION {
  value: "v0.1.0"
}