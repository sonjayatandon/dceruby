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
  
  
end