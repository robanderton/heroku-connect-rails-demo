class CreateConnectGetXmlBinaryFunction < ActiveRecord::Migration
  def up
    # This is a system function used by Heroku Connect.
    # When the add-on is provisioned it will ensure the most recent version of this function
    # exists in the database. Ideally we shouldn't have to create this in a migration however
    # our triggers rely on it so we have to bend the rules!
    execute %{
      CREATE OR REPLACE FUNCTION get_xmlbinary() RETURNS varchar LANGUAGE plpgsql AS $$
        DECLARE
          xmlbin varchar;
        BEGIN
          select into xmlbin setting from pg_settings where name='xmlbinary';
          RETURN xmlbin;
        END;
      $$;
    }
  end

  def down
    execute %{
      DROP FUNCTION get_xmlbinary();
    }.squish
  end
end
