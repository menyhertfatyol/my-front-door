RSpec.shared_context 'dynamodb user' do
  around do |example|
    StatusStorage.recreate_table(StatusStorage.table_schema)
    example.run
    StatusStorage.delete_table_if_exists('door_lock')
  end
end
