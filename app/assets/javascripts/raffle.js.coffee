@editor = ($scope) ->
  $scope.editor = 'neal'

$ ->

  $('#core_editor').bind 'input', ->

  $('#core_editor').keypress (e) ->
    sel = window.getSelection()
    if 

    

  $.ajax '/query/high', 
    type: 'GET'
    success: (data) -> 
      window.primary_filter = data
      $('.word').each (_index, elem) ->
        console.log $(elem).text()
        if $.inArray($(elem).text(), data) == -1 and $.inArray($(elem).text().toLowerCase(), data) == -1
          $(elem).addClass("first_appear")

  $('word').bind 'dblclick', ->
    $('.selected_word').removeClass('selected_word')
    $(this).addClass('selected_word')
    $('.slected_word').removeClass('selected_word')
    $(this).addClass('selected_word')
    $('#attr_pick').html('')
    word = $(this).text()
    $.ajax 'query',
      type: 'GET'
      data: {'word': word}
      dataType: 'json'
      success: (data)->
        $(data).each (index, elem) ->
          $('#attr_pick').append("<div>#{elem.origin}<sup>#{index + 1}</sup></div>")
          $(elem.word).each (s_index, s_elem) ->
            $('#attr_pick').append("category<sup>#{s_index + 1}</sup>: </div>")
            $(s_elem.category).each (ss_index, ss_elem ) ->
              juggle ="#{index}_#{s_index}_#{ss_index}"
              if $('.selected_word').attr('meaning') == juggle
                $('#attr_pick').append("<div><input type='radio' value=#{juggle} name='radio_list' checked> #{ss_elem.description}</div>")
              else
                $('#attr_pick').append("<div><input type='radio' value=#{juggle} name='radio_list'> #{ss_elem.description}</div>")

        $('#boxes').html('')
        if $('.selected_word').hasClass('new_comer')
          $('#boxes').append('<div>new word <input name="stranger" type="checkbox" checked></div>')
        else
          $('#boxes').append('<div>new word <input name="stranger" type="checkbox"></div>')

        $('input[name=stranger]').bind 'change', ->
          $('.selected_word').toggleClass('new_comer')

        $('input[name=radio_list]').bind 'change', ->
          $.ajax "/articles/#{gon.article_id}",
            type: 'POST'
            data: { html: $('#core_editor').html() }
            dataType: 'json'
            beforeSend: (xhr) ->
              xhr.setRequestHeader("X-Http-Method-Override", "PUT")

          value = $('input[name=radio_list]:checked').val()
          $('.selected_word').removeClass('first_appear')
          $('.selected_word').addClass('marked')
          $('.selected_word').attr('meaning', value )


        

