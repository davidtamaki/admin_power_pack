# ⚡ Admin Power Pack ⚡

The Admin Power Pack is a tool for Looker administrators to accomplish certain management tasks more efficiently. It is a Looker add-on application built using the Looker extension framework. Currently it offers utilities for extended functionality in two main areas: **schedules** and **users**. Key features include:

- Bulk management of user accounts (select multiple users at once)
- Bulk management of dashboard schedules (edit multiple scheduled plans in one table)
- Execute actions that aren't available in the standard UI (e.g. manage user credential objects)

# Usage

## Schedules++

![scheduler++ screenshot](images/scheduler++.png)

### Features

The Schedules++ Page enables admins to execute the following operations in bulk: create / update / delete, enable / disable, resend schedules (send tests), modify filter values, modify cron / datagroups, change ownership, and prepopulate schedules.

These tasks are often time consuming for Looker admins to execute using the base UI since it requires them to sudo as each user individually. This utility allows admins to modify all schedules on a given Dashboard from a single point.

- The entire table is editable. Multiple rows can be edited at the same time. The “Revert” button will undo all local changes. **Details** contains metadata on the schedule plan, with links to System Activity and viewing the Dashboard with the schedule filters. Use the checkbox to the left to apply functions on specific rows:

  - **Create/Update** - Update an existing scheduled plan with table data, or create a new scheduled plan if it does not already exist. Common uses would be to change schedule ownership, modify filter values, update recipients
  - **Delete** - Delete the scheduled plan
  - **Run Once** - Reruns the schedule using the [scheduled_plan_run_once](https://docs.looker.com/reference/api-and-integration/api-reference/v4.0/scheduled-plan#run_scheduled_plan_once) endpoint. This is useful for testing specific schedules or if multiple schedules need to be resent immediately.
  - **Disable** - Disable the schedule and prevent the schedule from sending until it’s re-enabled. The `Disable` and `Enable` functions modify the scheduled plan's enabled state. This is only accessible via Looker's API.
  - **Enable** - Enables the schedule. Re-enabling a schedule will send (maximum 1) schedule immediately, if, while it was disabled it should have run

- **Populate Rows** - This will generate a new schedule plan for each row in the results of a Looker query. The use case would be to create distinct schedules for non-Looker users where User Attributes can not be applied.

  - Filter values will be populated if the field label matches the filter name on the Dashboard. Ensure there is a field "Email" to populate Recipients.

- **Global Actions** - These actions will be applied across all schedules across the instance.
  - **Find & Replace Email** - Update email destinations from a CSV of email address mappings.
  - **Resend Failed Schedules** - This will validate and resend any schedules that have failed on their most recent attempt, within a specified timeframe.

### Limitations

Only schedules sent to email destinations for User Defined Dashboards (UDDs) will load in the table. This extension **does not** currently support:

- LookML Dashboards / Looks
- Schedules sent to Webhooks / Actions / S3 / etc.
- [Conditional Alerts](https://docs.looker.com/sharing-and-publishing/alerts)
- [Embed themes](https://docs.looker.com/admin-options/settings/themes) are not supported

## Users++

The Users++ Page offers greater flexibility in filtering and bulk selecting user accounts, e.g. show users without email credentials or show users with duplicate names. Users can also be bulk selected based on a provided list of ids, email addresses, or a Looker query. Once users have been selected there are actions not available in the base UI, such as create email credentials and delete SSO credentials.

There is also a feature to bulk update user email addresses according to a list of mappings. This is very handy for companies that want to change email domains or SSO providers, and want to make sure that users keep their existing Looker account after the migration.

# Installation

## Requirements

This extension requires Looker release 7.8 or later. Be sure to enable the “Extension Framework” labs feature.

**Note**: Any user who has model access to the "admin_power_pack" model (possibly via the "All" model set) will be able to see the APP in the Browse dropdown menu. However:

- Extensions always run with the permissions of the currently logged-in user and can't escalate permissions or do anything a regular user can't do. A non-Admin cannot be granted additional powers via an extension.
- The APP checks the user roles and displays a friendly message page if the user is not an Admin.

However in order to avoid confusion, it is still recommended that only Looker admins have access to the admin_power_pack model. This may mean that the standard roles will need to be changed to not use the “All” model set.

- There is no need to create new model sets or roles for the APP, since Admins can always see all models.
- Refer to the documentation on [Setting Permissions for Looker Extensions](https://docs.looker.com/data-modeling/extension-framework/permissions) for more details on extension permissions.

## Option 1 - Use this git repo (easiest)

LookML Projects are backed by git repositories. This repo has been set up with all the other necessary LookML files in addition to the application javascript. You can directly point a new LookML project to this repo, however the project will be read-only so you will not be able to deploy any changes to the files.

1. Create a new database connection. This is needed purely as a stub for the new project configuration. The APP does not communicate with any of your databases. This new database will merely be a stub that does not point to a real system.
   - Navigate to Admin => Connections. Select the "New Connection" button.
   - You _must_ name the new connection "admin_power_pack_stub"
   - You can pick any dialect and fill in bogus values for the required fields. We recommend selecting PostgreSQL, host= localhost, database= "notreal", user= "notreal"
   - Uncheck the "SQL Runner Precache" and then Add Connection. Don't bother testing the connection.
1. Create a new project
   - This is found under Develop => Manage LookML Projects, then select the New LookML Project button in top right corner.
   - Give your project a name such as "admin_power_pack"
   - As the "Starting Point" select "Clone Public Git Repository"
   - Enter the git repository url and continue: `git://github.com/davidtamaki/admin_power_pack.git`
1. After the project is created, go back to the Manage LookML Projects page and select the "Configure" button for the new project. Select "admin_power_pack_stub" as the Allowed Connection for the model. The application does not actually talk to your database but needs to be permissioned to at least one connection.
1. Go back the project IDE and deploy to production. After refreshing the page you will now see "Admin Power Pack" in the Browse menu.

## Option 2 - Roll your own

The end result of this will be similar to the above, except that the git repo will be writeable.

1. Create a new project
   - This is found under Develop => Manage LookML Projects, then select the New LookML Project button in top right corner.
   - Give your project a name such as "admin_power_pack"
   - As the "Starting Point" select "Blank Project". You'll now have a new project with no files.
2. Create a project manifest based on this [example](manifest.lkml)
   - Use the `url` parameter to point to the [GitHub Pages hosted version](https://davidtamaki.github.io/admin_power_pack/looker_admin_power_pack.js) of this extension. This version will be updated regularly.
   - Alternatively, use the `file` parameter to host the application javascript in the LookML repo and include the [javascript file](looker_admin_power_pack.js) in the LookML project.
3. Create a new model file in your project named "admin_power_pack.model"
   - Provide a [connection](https://docs.looker.com/r/lookml/types/model/connection) value.
   - The connection will not be used so it does not matter which connection is selected. This is just required in order for the project to be valid.
   - Make sure to [configure the model you created](https://docs.looker.com/r/develop/configure-model) so that it has access to the connection. Develop => Manage LookML Projects => Configure button next to the new model.
4. Configure git for the project and deploy to production
   - You can use the "Create Bare Repository" option to create a repo that exists only on the Looker server. This is usually sufficient unless you have a critical need to store the code elsewhere.
   - In that case, create a new repository on GitHub or a similar service, and follow the instructions to [connect your project to git](https://docs.looker.com//r/api/pull-request).
   - [Commit your changes](https://docs.looker.com/r/develop/commit-changes) and [deploy your them to production](https://docs.looker.com/r/develop/deploy-changes) through the Projects page UI.
5. Reload the page and click the Browse dropdown menu. You should see your extension in the list.

For more detailed steps, refer to steps 5 - 10 in the [Looker Extension Template Guide](https://github.com/looker-open-source/extension-template-react).
