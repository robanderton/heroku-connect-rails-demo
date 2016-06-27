class CreateSalesforceExternalIdUuidProc < ActiveRecord::Migration
  def up
    execute %{
      CREATE OR REPLACE FUNCTION externalid_uuid_proc() RETURNS TRIGGER LANGUAGE plpgsql AS $$
        DECLARE
          externalid_column varchar;
          oldxmlbinary varchar;
        BEGIN
          -- Get external ID column name
          IF TG_ARGV[0] IS NOT NULL THEN
            externalid_column := TG_ARGV[0]::text;
          ELSE
            externalid_column := 'externalid__c';
          END IF;

          -- Save old value
          oldxmlbinary := get_xmlbinary();

          -- Change value to ensure writing to _trigger_log is enabled
          EXECUTE format('SET SESSION xmlbinary TO base64');

          -- Update the external ID
          EXECUTE format('UPDATE %I.%I SET %I = %L WHERE %I = %L', TG_TABLE_SCHEMA, TG_TABLE_NAME, externalid_column, uuid_generate_v4(), 'id', NEW.id);

          -- Reset the value
          EXECUTE format('SET SESSION xmlbinary TO %L', oldxmlbinary);

          RETURN NEW;
        END;
      $$;
    }
  end

  def down
    execute %{
      DROP FUNCTION externalid_uuid_proc();
    }.squish
  end
end
