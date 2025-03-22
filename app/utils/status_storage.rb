module StatusStorage
  extend self

  TABLE_NAME = 'door_lock'.freeze

  def table_schema
    {
      table_name: TABLE_NAME,
      attribute_definitions: [
        { attribute_name: 'door', attribute_type: 'S' }
      ],
      key_schema: [
        { attribute_name: 'door', key_type: 'HASH' }
      ],
      provisioned_throughput: {
        read_capacity_units: 1,
        write_capacity_units: 1
      }
    }
  end

  def store_state(state)
    dynamodb.put_item({
                        item: { 'door' => 'front_door',
                                'lock_state' => state,
                                'updated_at' => Time.now.to_s },
                        table_name: 'door_lock'
                      })
  end

  def read_state
    dynamodb.get_item table_name: 'door_lock', key: { 'door' => 'front_door' }
  end

  def recreate_table(table_schema)
    delete_table_if_exists(TABLE_NAME)
    dynamodb.create_table(table_schema)
  rescue Aws::DynamoDB::Errors::ServiceError => e
    puts "Unable to create table: #{e.message}"
  end

  def delete_table_if_exists(table_name)
    dynamodb.delete_table(table_name: table_name)
  rescue Aws::DynamoDB::Errors::ResourceNotFoundException
    puts "#{table_name} table does not exist, unalble to delete it"
  end

  private

  def dynamodb
    Aws::DynamoDB::Client.new endpoint: ENV['STATUS_STORE_URL'],
                              region: 'eu-central-1',
                              access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                              secret_access_key: ENV['AWS_ACCESS_KEY']
  end
end
