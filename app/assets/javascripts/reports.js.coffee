$(document).on 'click', '#report-columns', ->
  $('#column-fields').toggle()
  return

$(document).on 'click', '#report-networks', ->
  $('#network-fields').toggle()
  return

$(document).on 'click', '#report-hostings', ->
  $('#hosting-fields').toggle()
  return

$(document).on 'click', '#report-storages', ->
  $('#storage-fields').toggle()
  return

$(document).on 'change', 'input[type=radio][name*=network]', ->
  if this.value == 'true'
    $('#network-checkbox').toggle()
  else if this.value == 'false'
    $('#network-checkbox').toggle()
    $('input[type=checkbox][name*=network]').removeAttr('checked')

$(document).on 'change', 'input[type=radio][name*=hosting]', ->
  if this.value == 'true'
    $('#hosting-checkbox').toggle()
  else if this.value == 'false'
    $('#hosting-checkbox').toggle()
    $('input[type=checkbox][name*=hosting]').removeAttr('checked')

$(document).on 'change', 'input[type=radio][name*=storage]', ->
  if this.value == 'true'
    $('#storage-checkbox').toggle()
  else if this.value == 'false'
    $('#storage-checkbox').toggle()
    $('input[type=checkbox][name*=storage]').removeAttr('checked')