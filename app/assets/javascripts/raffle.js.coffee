$ ->
  $('word').bind 'click', ->
    $('.slected_word').removeClass('selected_word')
    $(this).addClass('selected_word')
    $('#attr_pick').html('')
    word = $(this).text()
    $.ajax 'query',
      type: 'GET'
      data: {'word': word}
      dataType: 'json'
      success: (data)->
        $(data.result).each (index, elem)->
          $('#attr_pick').append("<div><input type='radio' name='meaning' value=#{index}/>#{elem}</div>")
        $('#attr_pick').append('<a id="save_class" class="btn btn-success">保存</a>')
        $('#save_class').bind 'click', ->
          alert 'sb'

