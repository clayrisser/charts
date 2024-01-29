# nextcloud

> a safe home for all your data

## Maintenance

Use the following to run the `occ` command

```sh
su -p www-data -s /bin/sh -c "./occ"
```

### Upgrade App

_upgrade single app_
```sh
su -p www-data -s /bin/sh -c "./occ app:update -vvv --no-interaction <APP_NAME>"
su -p www-data -s /bin/sh -c "./occ app:update -vvv maintenance:repair"
```

_upgrade all apps_

```sh
su -p www-data -s /bin/sh -c "./occ app:update -vvv --no-interaction --all"
su -p www-data -s /bin/sh -c "./occ maintenance:repair -vvv"
```

## Default Apps

the following apps recommended

```
admin_audit
announcementcenter
appointments
approval
checksum
cloud_py_api
drawio
externalportal
files_accesscontrol
files_archive
files_downloadlimit
files_external
files_linkeditor
files_lock
files_zip
forms
group_everyone
guests
holiday_calendars
imageconverter
libresign
metadata
occweb
passwords
previewgenerator
user_migration
video_converter
```

the following apps are useful but not necessary in a default setup

```
camerarawpreviews
files_3d
files_photospheres
mediadc
```

the following apps work but the occ install doesn't work

```
backup
calendar
contacts
external
mail
```

the following apps work, but are buggy

```
bookmarks
flowupload
```

the following apps are broken but may work in the future

```
apporder
epubreader
pdfdraw
printer
```

## Restore

You may need to run the following SQL script to fix the permission for
the postgres database user after restoring a sqldump directly to postgres.

```sql
DO $$ 
DECLARE
  r RECORD;
  username_role VARCHAR := 'oc_admin22'; -- Set the username role here
BEGIN
  -- Change ownership of all tables
  FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') LOOP
    EXECUTE 'ALTER TABLE ' || quote_ident(r.tablename) || ' OWNER TO ' || quote_literal(username_role) || ';';
  END LOOP;
  -- Change ownership of all sequences
  FOR r IN (SELECT sequencename FROM pg_sequences WHERE schemaname = 'public') LOOP
    EXECUTE 'ALTER SEQUENCE ' || quote_ident(r.sequencename) || ' OWNER TO ' || quote_literal(username_role) || ';';
  END LOOP;
  -- Change ownership of all views
  FOR r IN (SELECT table_name FROM information_schema.views WHERE table_schema = 'public') LOOP
    EXECUTE 'ALTER VIEW ' || quote_ident(r.table_name) || ' OWNER TO ' || quote_literal(username_role) || ';';
  END LOOP;
  -- Change ownership of all indexes
  FOR r IN (SELECT indexname FROM pg_indexes WHERE schemaname = 'public') LOOP
    EXECUTE 'ALTER INDEX ' || quote_ident(r.indexname) || ' OWNER TO ' || quote_literal(username_role) || ';';
  END LOOP;
  -- Change ownership of all functions
  FOR r IN (SELECT proname FROM pg_proc WHERE pronamespace = 'public'::regnamespace) LOOP
    EXECUTE 'ALTER FUNCTION ' || quote_ident(r.proname) || ' OWNER TO ' || quote_literal(username_role) || ';';
  END LOOP;
  -- Change ownership of all materialized views
  FOR r IN (SELECT matviewname FROM pg_matviews WHERE schemaname = 'public') LOOP
    EXECUTE 'ALTER MATERIALIZED VIEW ' || quote_ident(r.matviewname) || ' OWNER TO ' || quote_literal(username_role) || ';';
  END LOOP;
END $$;
GRANT CONNECT ON DATABASE i_nextcloud_0 TO oc_admin22;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO oc_admin22;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO oc_admin22;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO oc_admin22;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO oc_admin22;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON SEQUENCES TO oc_admin22;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON FUNCTIONS TO oc_admin22;
```
