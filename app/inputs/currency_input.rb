class CurrencyInput < SimpleForm::Inputs::Base
  def select
    "$ #{@builder.select(attribute_name, input_html_options)}".html_safe
  end
end
