# keycloak

> an open source identity and access management solution

## Restore

Sometimes when restoring the system, if the users come from a federated
provider, the user id's get regenerated. To change the user id back, you
can run the following script.

```sql
DO $$
DECLARE
    v_username varchar := 'username'; -- Replace with the username
    new_id varchar := 'new-user-id'; -- Replace with the new user ID
    original_id varchar;
    rec record;
BEGIN
    -- Get the original user ID
    SELECT id INTO original_id FROM user_entity WHERE username = v_username;

    -- Disable relevant foreign key constraints
    FOR rec IN SELECT tc.constraint_name, tc.table_name
               FROM information_schema.table_constraints AS tc 
               JOIN information_schema.constraint_column_usage AS ccu 
               ON ccu.constraint_name = tc.constraint_name
               WHERE tc.constraint_type = 'FOREIGN KEY' AND ccu.table_name = 'user_entity'
    LOOP
        EXECUTE 'ALTER TABLE ' || rec.table_name || ' DROP CONSTRAINT ' || rec.constraint_name;
    END LOOP;

    -- Update user_entity
    UPDATE user_entity
    SET id = new_id
    WHERE id = original_id;

    -- Update user_role_mapping
    UPDATE user_role_mapping
    SET user_id = new_id
    WHERE user_id = original_id;

    -- Update user_attribute
    UPDATE user_attribute
    SET user_id = new_id
    WHERE user_id = original_id;

    -- Update user_consent
    UPDATE user_consent
    SET user_id = new_id
    WHERE user_id = original_id;

    -- Update user_group_membership
    UPDATE user_group_membership
    SET user_id = new_id
    WHERE user_id = original_id;

    -- Update user_required_action
    UPDATE user_required_action
    SET user_id = new_id
    WHERE user_id = original_id;

    -- Update user_session
    UPDATE user_session
    SET user_id = new_id
    WHERE user_id = original_id;

    -- Re-enable the foreign key constraints
    FOR rec IN SELECT tc.constraint_name, tc.table_name
               FROM information_schema.table_constraints AS tc 
               JOIN information_schema.constraint_column_usage AS ccu 
               ON ccu.constraint_name = tc.constraint_name
               WHERE tc.constraint_type = 'FOREIGN KEY' AND ccu.table_name = 'user_entity'
    LOOP
        EXECUTE 'ALTER TABLE ' || rec.table_name || ' ADD CONSTRAINT ' || rec.constraint_name || ' FOREIGN KEY (' || ccu.column_name || ') REFERENCES user_entity(id)';
    END LOOP;
END $$;
