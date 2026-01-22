GBLADMIN.SetDateRangeInputs = function(startDate, endDate) {
  // Set input start and end dates
  // Try to reload
  $('input#start-date').attr(
    'value',
    startDate.format(I18n.t('date.formats.momentjs_datepicker')
    )
  );

  $('input#end-date').attr(
    'value',
    endDate.format(
      I18n.t('date.formats.momentjs_datepicker')
    )
  );
}

GBLADMIN.SetCompareRangeInputs = function(startDate, endDate) {
  $('input#compare-start-date').attr(
    'value',
    startDate.format(
      I18n.t('date.formats.momentjs_datepicker')
    )
  );

  $('input#compare-end-date').attr(
    'value',
    endDate.format(
      I18n.t('date.formats.momentjs_datepicker')
    )
  );
}

// Use with moment.js subtract function
GBLADMIN.DateRangePeriod = function(opt) {
  switch(opt){
    case 'custom':
      break;
    case 'today':
      return [0, 'days'];
    case 'yesterday':
      return [1, 'days'];
    case 'lastweek':
      return [1, 'weeks'];
    case 'lastmonth':
      return [1, 'months'];
    case 'lastyear':
      return [1, 'years'];
    case 'last7days':
      return [7, 'days'];
    case 'last4weeks':
      return [28, 'days'];
    case 'last30days':
      return [30, 'days'];
    case 'last365days':
      return [365, 'days'];
  }
}

GBLADMIN.DateRangeSelect = function() {
  var opt, startDate, endDate;
  opt = $('#date-range').val();

  switch(opt) {
    case 'custom':
      break;
    case 'today':
      startDate = moment().startOf('day');
      endDate = moment().endOf('day');
      break;
    case 'yesterday':
      startDate = moment().subtract(1, 'days').startOf('day');
      endDate = moment().subtract(1, 'days').endOf('day');
      break;
    case 'lastweek':
      startDate = moment().subtract(1, 'weeks').startOf('week');
      endDate = moment().subtract(1, 'weeks').endOf('week');
      break;
    case 'lastmonth':
      startDate = moment().subtract(1, 'months').startOf('month');
      endDate = moment().subtract(1, 'months').endOf('month');
      break;
    case 'lastyear':
      startDate = moment().subtract(1, 'years').startOf('year');
      endDate = moment().subtract(1, 'years').endOf('year');
      break;
    case 'last7days':
      startDate = moment().subtract(7, 'days').startOf('day');
      endDate = moment().subtract(1, 'days').endOf('day');
      break;
    case 'last4weeks':
      startDate = moment().subtract(28, 'days').startOf('day');
      endDate = moment().subtract(1, 'days').endOf('day');
      break;
    case 'last30days':
      startDate = moment().subtract(30, 'days').startOf('day');
      endDate = moment().subtract(1, 'days').endOf('day');
      break;
    case 'last365days':
      startDate = moment().subtract(365, 'days').startOf('day');
      endDate = moment().subtract(1, 'days').endOf('day');
      break;
  }

  GBLADMIN.SetDateRangeInputs(startDate, endDate);
}

// @TODO: need to calculate display periodicity
// - might be day, week, month, year (custom range?)
// - calc display start-date, period (select opt)
// -
GBLADMIN.CompareRangeSelect = function(event) {
  var dateOpt, compareOpt, period, startDate, endDate;
  dateOpt = $('#date-range').val();
  compareOpt = $('#compare-options').val();
  period = GBLADMIN.DateRangePeriod(dateOpt);

  startDate = moment(
    $('#start-date').val(),
    I18n.t('date.formats.momentjs_iso')
  );

  endDate = moment(
    $('#end-date').val(),
    I18n.t('date.formats.momentjs_iso')
  );

  switch(compareOpt) {
    case 'custom':
      break;
    case 'previous_period':
      startDate = moment(startDate).subtract(period[0], period[1]).startOf('day');
      // console.log(startDate);
      endDate = moment(endDate).subtract(period[0], period[1]).endOf('day');
      // console.log(endDate);
      break;
    case 'previous_year':
      startDate = moment(startDate).subtract(1, 'years').startOf('day');
      endDate = moment(endDate).subtract(1, 'years').endOf('day');
      break;
    }

  GBLADMIN.SetCompareRangeInputs(startDate, endDate);
}

GBLADMIN.DisplayCompareDateRange = function() {
  if ($('#compare').prop('checked')) {
    $("#compare-range").show();
    $("#compare-options").prop('disabled', false);
    $("#compare-start-date").prop('disabled', false);
    $("#compare-end-date").prop('disabled', false);
  } else {
    $("#compare-range").hide();
    $("#compare-options").prop('disabled', true);
    $("#compare-start-date").prop('disabled', true);
    $("#compare-end-date").prop('disabled', true);
  }
}

GBLADMIN.ToggleDataTable = function(elm) {
  var toggle;
  $('.search-facet').hide();
  toggle = $(elm).data('toggle');
  $('#' + toggle).show();
};

GBLADMIN.ToggleCompare = function(elm) {
  if ($('#compare').prop('checked')) {
    $("input[name=compare]").val("true");
  } else {
    $("input[name=compare]").val("false");
  }
}
