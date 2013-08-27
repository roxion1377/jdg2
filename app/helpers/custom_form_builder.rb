class CustomFormBuilder < SimpleForm::FormBuilder
  def select(method, choices, options = {}, html_options = {})
    html_options[:class] = 'form-control'
    super
    #super(attribute_name,options,block)
  end
  def text_area(attribute_name, options = {}, &block)
    options[:class] = 'form-control'
    options[:rows] = 12
    super
  end
  def text_field(attr,options = {})
    options[:class] = 'form-control'
    super
  end
  def password_field(attr,options = {})
    options[:class] = 'form-control'
    super
  end
  def number_field(attr,options = {})
    options[:class] = 'form-control'
    super
  end
  def input(attr,options = {},&block)
    options[:error] = false
    super
  end
#  def datetime_select(attr,options = {},html = {})
#    html[:class] = 'form-control'
#    super
#  end
  def submit(attr = "",html = {})
    html[:class] = ["btn","btn-default"]
    super
  end
end
