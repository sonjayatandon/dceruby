class GameComponent
  def initialize(name,session,parent,prototype)
    @name=name
    @session=session
    @parent=parent
    @tokens={}
    @children={}
    @prototype=prototype
    @actions={}
  end
  
  def name
    @name
  end

  def []= (key, value)
    @tokens[key]=value 
  end
  
  def [] (key)
    value = @tokens[key]
    if value == nil && @prototype != nil
      return @prototype[key]
    end
    value
  end
  
  def add_child(key, value)
    @children[key]=value
  end
  
  def child(key)
    return @children[key]
  end
  
  def add_action(trigger, action)
    
    @actions[trigger] = [] unless @actions[trigger]
    
    action_list = @actions[trigger]
    action_list << action
    
  end
  
  def pp
    out = [] 
    out << '{'
    @tokens.each do |key,value|
      value = @tokens[key]
      out << " [#{key} => #{value}]" unless key == 'action'
    end
    out << '}'
    
    out << " actions: "
    @actions.each do |key, value|
      out << "    #{key}:"
      value.each do |action|
        out << "        #{action}"
      end
    end
    
    return out
  end
  
end