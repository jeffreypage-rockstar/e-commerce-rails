class ProductType < ActiveRecord::Base
  translates :name
  acts_as_nested_set  #:order => "name"
  has_many :products, dependent: :restrict_with_exception
  ACTIVE    = 1
  INACTIVE  = 0

  MAIN_MANU = {    
    1 => 'Active',
    0 => 'Inactive'
  }

  
  scope :visible
  scope :active, :conditions => "#{ProductType.table_name}.main_menu = #{ACTIVE}"
  scope :inactive, :conditions => "#{ProductType.table_name}.main_menu = #{INACTIVE}"

  def active?
    main_menu
  end

  validates :name,    presence: true, length: { :maximum => 255 }

  FEATURED_TYPE_ID = 1

  # paginated results from the admin ProductType grid
  #
  # @param [Optional params]
  # @return [ Array[ProductType] ]
  def self.admin_grid(params = {})
    grid = ProductType
    grid = grid.where("product_types.name LIKE ?", "#{params[:name]}%")              if params[:name].present?
    grid
  end

end
