module ApplicationHelper

  ### The next three helpers are great to use to add and remove nested attributes in forms.
  #  LOK AT THIS WEBPAGE FOR REFERENCE
  ## http://openmonkey.com/articles/2009/10/complex-nested-forms-with-rails-unobtrusive-jquery
=begin
EXAMPLE USAGE!!
  <% form.fields_for :properties do |property_form| %>
    <%= render :partial => '/admin/merchandise/add_property', :locals => { :f => property_form } %>
  <% end %>
  <p><%= add_child_link "New Property", :properties %></p>
  <%= new_child_fields_template(form, :properties, :partial => '/admin/merchandise/add_property')%>
=end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end

  def set_lang(lang)
    I18n.locale = lang
  end


  def site_name
    I18n.t(:company)
  end

  def remove_child_link(name, f)
    f.hidden_field(:_destroy) + link_to(name, "javascript:void(0)", :class => "remove_child")
  end

  def add_child_link(name, association)
    link_to(name, "javascript:void(0);", :class => "add_child", :"data-association" => association)
  end
  
  def add_child_button(name, association)
    link_to(name, "javascript:void(0);", :class => "add_child button", :"data-association" => association)
  end

  def new_child_fields_template(form_builder, association, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(association).klass.new
    options[:partial] ||= association.to_s.singularize
    options[:locals] ||= {}
    options[:form_builder_local] ||= :f

    content_tag(:div, :id => "#{association}_fields_template", :style => "display: none") do
      form_builder.fields_for(association, options[:object], :child_index => "new_#{association}") do |f|
        raw( render(:partial => options[:partial], :locals => {options[:form_builder_local] => f }.merge(options[:locals])) )
      end
    end
  end

  def filter_helper(params)
    keyword = []
    if params[:f]
        fields = params[:option].split('@')
        if fields[1]=="list"
           keyword = [" #{fields[0]} = ?", params[:f][fields[0]]]
        elsif fields[1]=="integer"
           if !params[:f][fields[0]].blank?
            keyword = [" #{fields[0]} = ?", params[:f][fields[0]].to_i]
           end
        elsif fields[1]=="date"
          if (params[:f].has_key?(fields[0]) and params[:f][fields[0]].has_key?('from') and !params[:f][fields[0]][:from].blank?)
            @from = params[:f][fields[0]][:from] if (params[:f].has_key?(fields[0]) and params[:f][fields[0]].has_key?('from'))
            @to = params[:f][fields[0]][:to] if (params[:f].has_key?(fields[0]) and params[:f][fields[0]].has_key?('to')and !params[:f][fields[0]][:to].blank?)
            @to ||= @from
            keyword = [" DATE(#{fields[0]}) >= ? AND DATE(#{fields[0]}) <= ? ", @from.to_date,@to.to_date]
          end
        else
          keyword = [" #{fields[0]} LIKE ?", "%#{params[:f][fields[0]]}%"]
        end
      end
      if params[:alpha_search] == 'Yes'
          keyword = [" #{params[:char_field]} LIKE ?", "#{params[:keyword]}%"]
      end
      return keyword
  end

  def get_properties_values(property_variants)
    if property_variants.present?
      property_variants =  property_variants.map { |e| [e.description] }
      return property_variants.present? ? property_variants.uniq : nil
    else
      return nil
    end
  end

  def get_count_rating(designer)
    @ratings = Rating.where('designer_id = ?',designer.id)
    if @ratings == []
      @avg_rating = 0
      @count = 0
      #@rating = Rating.new(:id => 0,:score => 0, :designer_id => @designer.id)
    else
      @count = Rating.where('designer_id = ?',designer.id).count.to_s
      @avg_rating = Rating.where('designer_id = ?',designer.id).sum(:score).to_f/@count.to_f
    end
    return @avg_rating,@count
  end

  def page_entries_info(collection, options = {})
    params[:page] ||= 1   
    %{Page %d of %d total} % [
      params[:page].to_i,        
      collection.total_pages
    ]    
  end

  def get_products(category)
    products ||= []
    if category.present? && category.is_a?(ProductType)      
      products = category.products.to_a
      category.sub_categories.each do |sub|
        products += sub.products
      end
    end
    products.uniq
  end

end
