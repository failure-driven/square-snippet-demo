module ArrayToEnumHash
  extend ActiveSupport::Concern

  def array_to_enum_hash(array)
    result = {}
    v = array.to_enum
    w = array.map(&:to_sym).to_enum
    loop do
      result[w.next] = v.next
    end
    result
  end
end
