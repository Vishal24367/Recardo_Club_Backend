//= require jquery
//= require arctic_admin/base
//= require fancybox
//= require jquery.remotipart
//= require active_admin/searchable_select
//= require best_in_place

$(document).ready(function () {

  $(".best_in_place").best_in_place();

  $("a.fancybox").fancybox({
    minWidth: 450,
    minHeight: 150,
    closeClick: false,
    helpers: {
      overlay: { closeClick: false },
    },
  });
  var manufacture_company_state_id;
  var manufacture_district_id;
  var manufacture_city_id;
  this.autogrow = function (event) {
    var id = "#" + $(event).attr('id');
    var country_id = $(event).val();
    manufacture_company_state_id = $(id.slice(0, 46) + "state_id");
    manufacture_district_id = $(id.slice(0, 46) + "district_id");
    manufacture_district_input = $(id.slice(0, 46) + "district_input");
    manufacture_city_id = $(id.slice(0, 46) + "city_id");
    $(manufacture_company_state_id).empty();
    var manufacture_company_state_city_district = $(manufacture_company_state_id, manufacture_city_id, manufacture_district_id);
    manufacture_city_id.empty();

    //================================================================================================//
    // for getting the country code selected in manufacture comapnies master section //

    country_code_url = "/admin/countries/" + country_id + "/get_country_code";
    $.ajax({
      url: country_code_url,
      method: "GET",
      dataType: "json",
      error: function (xhr, status, error) {
        console.error("AJAX Error: " + status + error);
      },
      success: function (result, status, xhr) {
        result.country_iso_code == "IN"
          ? $(manufacture_district_input).show()
          : $(manufacture_district_input).hide();
      },
    });

    //================================================================================================//

    // for getting the states respected to the country selected in manufacture comapnies master section //

    country_id !== ""
      ? $(manufacture_company_state_city_district).prop("disabled", false)
      : $(manufacture_company_state_city_district).prop("disabled", true);

    url = "/admin/states/" + country_id + "/get_states";
    $.ajax({
      url: url,
      method: "GET",
      dataType: "json",
      error: function (xhr, status, error) {
        console.error("AJAX Error: " + status + error);
      },
      success: function (result, status, xhr) {
        result.options;
        manufacture_company_state_id.append(result.options);
      },
    });

    //================================================================================================//
    // for getting the cities & districts respected to the state selected in manufacture comapnies master section //

    $(manufacture_district_id).prop("disabled", true);
    $(manufacture_city_id).prop("disabled", true);

    $(manufacture_company_state_id).change(function () {
      manufacture_district_id.empty();
      manufacture_city_id.empty();
      var state_id = $(this).val();
      state_id !== ""
        ? $(manufacture_district_id).prop("disabled", false) &&
        $(manufacture_city_id).prop("disabled", false)
        : $(manufacture_district_id).prop("disabled", true) &&
        $(manufacture_city_id).prop("disabled", true);

      stateUrl = "/admin/cities/" + state_id + "/get_cities";
      $.ajax({
        url: stateUrl,
        method: "GET",
        dataType: "json",
        error: function (xhr, status, error) {
          console.error("AJAX Error: " + status + error);
        },
        success: function (result, status, xhr) {
          result.options;
          manufacture_city_id.append(result.options);
        },
      });

      districtUrl = "/admin/districts/" + state_id + "/get_districts";
      $.ajax({
        url: districtUrl,
        method: "GET",
        dataType: "json",
        error: function (xhr, status, error) {
          console.error("AJAX Error: " + status + error);
        },
        success: function (result, status, xhr) {
          result.options;
          manufacture_district_id.append(result.options);
        },
      });

    });

    //================================================================================================//

  }

  var city_district_input = $("#city_district_input, .district-inline");
  var city_district_id = $("#city_district_id, #vendor_address_attributes_district_id, #vendor_address_attributes_city_id");
  var city_state_id = $("#city_state_id, #vendor_address_attributes_state_id");
  var vendor_city_id = $("#vendor_address_attributes_city_id");
  var city_and_district_state_id = $("#city_state_id, #district_state_id, #vendor_address_attributes_state_id ");
  var city_and_district_state_id_and_city_district_id = $(
    "#city_state_id, #city_district_id, #district_state_id, #vendor_address_attributes_state_id, #vendor_address_attributes_district_id, #vendor_address_attributes_city_id"
  );

  if ($("#city_state_id, #district_country_id, #vendor_address_attributes_country_id, #vendor_address_attributes_state_id").val() === "")
    city_and_district_state_id_and_city_district_id.prop("disabled", true);


  $("#city_country_id, #district_country_id, #vendor_address_attributes_country_id").change(function () {
    city_and_district_state_id_and_city_district_id.empty();
    var country_id = $(this).val();
    console.log(country_id);
    country_code_url = "/admin/countries/" + country_id + "/get_country_code";
    $.ajax({
      url: country_code_url,
      method: "GET",
      dataType: "json",
      error: function (xhr, status, error) {
        console.error("AJAX Error: " + status + error);
      },
      success: function (result, status, xhr) {
        console.log(result.country_iso_code);
        result.country_iso_code == "IN"
          ? city_district_input.show()
          : city_district_input.hide();
      },
    });

    country_id !== ""
      ? city_and_district_state_id.prop("disabled", false)
      : city_and_district_state_id.prop("disabled", true);

    url = "/admin/states/" + country_id + "/get_states";
    $.ajax({
      url: url,
      method: "GET",
      dataType: "json",
      error: function (xhr, status, error) {
        console.error("AJAX Error: " + status + error);
      },
      success: function (result, status, xhr) {
        result.options;
        city_and_district_state_id.append(result.options);
      },
    });
  });

  city_state_id.change(function () {
    city_district_id.empty();
    var state_id = $(this).val();
    console.log(state_id);
    state_id !== ""
      ? city_district_id.prop("disabled", false)
      : city_district_id.prop("disabled", true);

    url = "/admin/districts/" + state_id + "/get_districts";
    $.ajax({
      url: url,
      method: "GET",
      dataType: "json",
      error: function (xhr, status, error) {
        console.error("AJAX Error: " + status + error);
      },
      success: function (result, status, xhr) {
        result.options;
        city_district_id.append(result.options);
      },
    });
  });

  city_state_id.change(function () {
    city_district_id.empty();

    var state_id = $(this).val();
    console.log(state_id);
    state_id !== ""
      ? city_district_id.prop("disabled", false)
      : city_district_id.prop("disabled", true);

    url = "/admin/cities/" + state_id + "/get_cities";
    $.ajax({
      url: url,
      method: "GET",
      dataType: "json",
      error: function (xhr, status, error) {
        console.error("AJAX Error: " + status + error);
      },
      success: function (result, status, xhr) {
        result.options;
        vendor_city_id.append(result.options);
      },
    });
  });


  $(".district-inline").hide();

});
