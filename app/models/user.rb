class User < ActiveRecord::Base

  validates_presence_of :cat, message: ':You. Must. Be. A. Cat. To. Signup.'
  # RAW
  def set_sekret(value = 'lol', key = 'sekret')
    escape_and_execute(["SELECT pgp_sym_encrypt(?, ?)", value.to_s, key])['pgp_sym_encrypt']
  end

  def get_sekret(value = 'lol', key = '\xc30d04070302ead63c9e04cc6e3e7ed23401ba88bf7a71d971f1a58dcd4389ecfc0d17fb7b7d72d924a953efb432a44fdeca57a2046ea3276b7d7e77543a335c5d126913bb')
    escape_and_execute(["SELECT pgp_sym_decrypt(?, ?)", value, key])['pgp_sym_decrypt']
  rescue
    raise 'lol; get it right bro'
  end

  def escape_and_execute(query)
    query = ::ActiveRecord::Base.send :sanitize_sql_array, query
    ::ActiveRecord::Base.connection.execute(query).first
  end

  #Arel
  def arel_sekret(value = 'lol', key = 'sekret')
    select_from_table pgp_sym_encrypt(value, key)
  end

  def pgp_sym_encrypt(value = 'lol', key = 'sekret')
    Arel::Nodes::NamedFunction.new('pgp_sym_encrypt', [value, key])
  end

  def select_from_table arel_nodes
    User.arel_table.project arel_nodes
  end
end
