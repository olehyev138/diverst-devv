module DiverstObject
  def send_chain(arr)
    Array(arr).inject(self) { |o, a| o.send(*a) }
  end
end

Object.include DiverstObject
