module ApplicationHelper
  def text_field_tag(attr,params = {},options = {})
    options[:class] = 'form-control'
    super
  end
  def shallow_args(parent,child)
    child.try(:new_record?) ? [parent,child] : child
  end
  def bootstrap_form_for(object, *args, &block)
    options = args.extract_options!
    simple_form_for(object, *(args << options.merge(builder: CustomFormBuilder)), &block)
  end
  def nav_link(txt, path)
    class_name = current_page?(path) ? 'active' : ''

    content_tag(:li, :class => class_name) do
      link_to txt,path
    end
  end
  def error_messages(errors,msg="Errors")
    return unless errors.any?
    content_tag(:div, :class => ['panel','panel-danger']) do
      content_tag(:div, msg, :class => 'panel-heading') +
      content_tag(:ul, :class => 'list-group') do
        errors.full_messages.each do |e_msg|
          concat content_tag(:li,e_msg,:class=>'list-group-item')
        end
      end
    end
  end
  def markdown(text)
    renderer_options = {hard_wrap:true,filter_html:true,table:false,prettify:true}
    options = {autolink:true,tables:true,fenced_code_blocks:true,prettify:true,superscript:true}
    renderer = Redcarpet::Render::HTML.new(renderer_options)
    Redcarpet::Markdown.new(renderer,options).render(text).html_safe
  end
  def kramdown(text)
    options = {
      coderay_css:"prittyprint"
    }
    return sanitize Kramdown::Document.new(text,options).to_html
  end
end
