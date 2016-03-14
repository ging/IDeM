class Hash
  def recursive_symbolize_keys
    self.symbolize_keys!
    self.map{|k,v| 
      v.recursive_symbolize_keys if v.is_a? Hash
      v.map!{|e| (e.is_a? Hash) ? e.recursive_symbolize_keys : e } if v.is_a? Array
    }
    self
  end

  def recursive_merge(hash)
    self unless hash.is_a? Hash
    h = {}
    self.each{ |k,v|
      if hash[k].nil?
        h[k] = v
      else
        if v.is_a? Hash and hash[k].is_a? Hash
          h[k] = v.recursive_merge(hash[k])
        else
          h[k] = hash[k]
        end
      end
    }
    hash.each{ |k,v|
      h[k] = v if self[k].nil?
    }
    h
  end
end