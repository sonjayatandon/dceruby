class GameComponentStack
  def initialize(name,session,parent)
    @name=name
    @session=session
    @parent=parent
    @component_list=[]
  end
  
  def name
    @name
  end

  def []= (key, value)
    # unsupported 
  end
  
  def << (value)
    @component_list << value
  end
  
  def [] (index)
    return @component_list[index]
  end
  
  def length
    return @component_list.length
  end
  
  def add_child(key, value)
    # unsupported
  end
  
  def child(key)
    # unsupported
    return nil
  end
  
  def add_action(trigger, action)
    # unsupported
    
  end
  
  
  
  def pp
    out = [] 
    out << '['
    @component_list.each do |value|
      out <<  value.pp
    end
    out << ']'
    
    return out
  end
  
end