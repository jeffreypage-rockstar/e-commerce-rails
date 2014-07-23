var Hadean = window.Hadean || {};


Hadean.Utility = {
  registerOnLoadHandler : function(callback) {
    jQuery(window).ready(callback);
  }
}


Hadean.AdminMerchandiseProductForm = {

    productCheckboxesDiv  : '#product_properties',
    prototypeSelectId     : '#product_prototype_id',
    formController        : '/admin/merchandise/products',
    productId             : null,

    initialize : function(product_Id) {

      this.productId  = product_Id;
      var prototype       = jQuery(Hadean.AdminMerchandiseProductForm.prototypeSelectId);
      prototype.
              bind('change',
                function() {

                  Hadean.AdminMerchandiseProductForm.addProperties(
                    jQuery(Hadean.AdminMerchandiseProductForm.prototypeSelectId + " option:selected").first().val()
                  );
                }
              );
    },
    addProperties : function(id1) {
      console.log(id1);
      if ( (typeof id1 == 'undefined') || (id1 == 0) || (id1.toString() == '') ) {
        //  show all properties...
$('#product_properties').children().fadeIn();
alert('1');
        jQuery(Hadean.AdminMerchandiseProductForm.productCheckboxesDiv).html('');
      }
      else {
        jQuery.ajax( {
           type : "GET",
           url : MerchProductForm.formController+'/'+id1+"/add_properties",
           data : { product_id : Hadean.AdminMerchandiseProductForm.productId },
           complete : function(json) {
             // open dialog with html
             Hadean.AdminMerchandiseProductForm.refreshProductForm(json);
             alert('2');
             alert(json);
            // STOP  WAIT INDICATOR...
           },
           dataType : 'json'
        });
      }
    },
    refreshProductForm : function(json) {
      // SHow the properties that are associated to this product

      //jQuery(MerchProductForm.productCheckboxesDiv).html(htmlText.responseText);
      // Show the save button
      //alert(json.responseText);
      properties = JSON.parse(json.responseText);
      //alert(properties.property[0])
      console.log("properties = "+properties)
      jQuery.each (properties.active, function(p,value) {
        jQuery('#property_' + value ).fadeIn();
      });

      jQuery.each (properties.inactive, function(p,value) {
        propertyId = '#property_' + value;
        jQuery(propertyId ).hide();
        jQuery(propertyId + ' input:text')[0].value = '';
        alert('3');
      });
    }
};

MerchProductForm = Hadean.AdminMerchandiseProductForm