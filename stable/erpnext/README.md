# erpnext

> free and open source erp

### Integrations

#### LDAP

```json
{
  "name": "LDAP Settings",
  "owner": "Administrator",
  "docstatus": 0,
  "idx": "0",
  "enabled": 1,
  "ldap_directory_server": "OpenLDAP",
  "ldap_server_url": "<OPENLDAP HOST>",
  "base_dn": "cn=admin,dc=example,dc=com",
  "password": "************************",
  "ldap_search_path_user": "ou=people,dc=example,dc=com",
  "ldap_search_string": "(&(objectclass=inetOrgPerson)(uid={0}))",
  "ldap_search_path_group": "ou=groups,dc=example,dc=com",
  "ldap_email_field": "mail",
  "ldap_username_field": "uid",
  "ldap_first_name_field": "givenName",
  "ssl_tls_mode": "Off",
  "require_trusted_certificate": "No",
  "default_user_type": "System User",
  "default_role": "Administrator",
  "doctype": "LDAP Settings",
  "ldap_groups": []
}
```
