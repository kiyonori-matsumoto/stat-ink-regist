# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = () ->
  exp = " "
  ranks = ["c-", "c", "c+", "b-", "b", "b+", "a-", "a", "a+", "s", "s+"]
  $('#form-main').validationEngine()

  $('#save_button').on("click", () ->
    unless (apikey = $.cookie('stat_ink_key'))
      alert 'specify your stat_ink_key on top page'
      return false
    b = $('input[name=rank_exp]').val()
    a = $('input[name=rank_exp_add]').val()
    ae = eval "#{b} #{exp} #{a}"
    ar = $('#rank').val()
    idx = $.inArray(ar, ranks)
    if ae < 0
      if (idx - 1 < 0)
        ae = 0
        ar = ranks[0]
      else
        ae = 70
        ar = ranks[idx - 1]
    else if ae >= 100
      if (idx + 1 > ranks.length - 1)
        ar = ranks[ranks.length - 1]
        ae = 100
      else
        ae = 30
        ar = ranks[idx + 1]

    $('input[name=rank_exp_after]').val(ae)
    $('input[name=rank_after]').val(ar)
    $('input[name=apikey]').val(apikey)
  )

  $('#stat_ink_id_save').on('click', ->
    $.cookie('stat_ink_id', $('#stat_ink_id').val(), { expires: 365 })
    $.cookie('stat_ink_key', $('#stat_ink_key').val(), { expires: 365 })
    )

  $('input[name=result]').change( () ->
      v = $('input[name=result]:checked').val()
      # console.log v
      exp = if v == 'win'
        "+"
      else if v == 'lose'
        "-"
      else
        " "

      $('#result_add').html(exp)
    )

  $('#form-main')
    .on 'ajax:success', (event, data, status, xhr) ->
      rank_exp = $('input[name=rank_exp_after]').val()
      rank = $('input[name=rank_after]').val()
      $('input[name=rank_exp]').val(rank_exp)
      $('input[name=rank]').val(rank)
      $.cookie('weapon', $('#weapon').val(), { expires: 14 })
      $.cookie('rank', rank, { expires: 14 })
      $.cookie('rank_exp', rank_exp, { expires: 14 })
      clear()
    .on 'ajax:error', (event, data, status, error) ->
      alert data

  $('#weapon').select2 theme: "bootstrap", placeholder: { id: '-1', text: 'Select Weapon'}
  $('#weapon').on('select2:open', ->
    if ($('body').attr('data-viewport-x') <= 1024)
      $('.select2-input').parent().remove()
      $('.select2-focusser').remove()
    )
  $('#rank_exp').val($.cookie('rank_exp'))
  $('#rank').val($.cookie('rank'))
  $('#weapon').val($.cookie('weapon'))
  $('#weapon').trigger('change')

clear = () ->
  $('input[name=death]').val(null)
  $('input[name=kill]').val(null)
  $('input[name=rank_exp_add]').val(null)
  $('input[name=my_pont]').val(null)
  $('input[name=result]').attr("checked", false)
  $('input[name=map]').attr("checked", false)
  $('label.active').removeClass("active")
  $('#result_add').html('&nbsp;')

$(document).ready(ready)
$(document).on("page:load", ready)
