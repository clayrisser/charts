# zentao

> open source project management software

## LDAP

1. Install the extension from the project below.

  https://gitlab.com/bitspur/rock8s/zentao/zentao-ldap-plugin

2. Configure the ldap settings in the admin panel.

3. Due to a bug, run the following command in the container to fix the ldap settings.

  ```sh
  cat extension/custom/ldap/config.php | sed '1d' >> extension/custom/user/ext/config/config.php
  ```

## Epics (User Requirements)

By default the user requirement permissions are disabled even if the feature
is enabled. To enable the permissions, go to `Admin` -> `User` -> `Privilege`.
Select the `Assign Privileges by Group` (Lock Icon) button for a group you want
to access Epics (User Requirements). View the detailed view (icon towards the top right).
Scroll down to `Story` and check the `Requirement List` checkbox.
