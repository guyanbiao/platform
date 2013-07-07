mydir = angular.module("myApp", [])
mydir.controller("main", ($scope, $http) ->
  $scope.findFirstAppear = ->
    $.ajax '/query/high',
      type: 'GET'
      success: (data) ->
        window.new_word_finder = data
        $('w').each (_index, elem) ->
          console.log $(elem).text()
          if $.inArray($(elem).text(), data) == -1 and $.inArray($(elem).text().toLowerCase(), data) == -1 and $(elem).text().search(/\w/) != -1
            $(elem).addClass("first_appear")
  $scope.down_transfer = ->
    tidy_content = $('#core_editor').html().replace(/&nbsp;/g, " ")
    editor.setValue(tidy_content)
  $scope.up_transfer = ->
    $('#core_editor').html(editor.getValue())
  $scope.updateArticle = ->
    alert 'updated'
  $scope.addModule = ->
    sel = window.getSelection()
    range = sel.getRangeAt(0)
    content = range.extractContents()

    module_label = document.createElement('div')
    module_label.setAttribute('class', 'module_name_wrapper')
    real_label = document.createElement('div')
    real_label.setAttribute('class', 'module_name label label-info')
    real_label.appendChild(document.createTextNode('example'))
    module_label.appendChild(real_label)

    module_body = document.createElement('div')
    module_body.setAttribute('class', 'module_body')
    module_body.appendChild(content)

    wrapper = document.createElement('div')
    wrapper.setAttribute('class', 'module')
    wrapper.appendChild(module_label)
    wrapper.appendChild(module_body)
    range.insertNode(wrapper)
    range.collapse()
 )
###
mydir.directive("core", ->
  return {
    restrict: "A",
    require: 'ngModel'
    link : (scope, element, attrs, ctrl) ->
      get = ->
      show = ->

      scope.$watch(
        -> scope.html
        -> element.html(scope.html)
        false
        )

      element.bind 'blur', ->
        scope.$apply ->
          scope.html = element.html()
          #ctrl.$setViewValue element.html()

      ctrl.$render = (value) -> element.html(value)
  }
)

mydir.directive("origin", ->
  return {
    restrict: "A",
    require: 'ngModel'
    controller : ($scope) ->
    link : (scope, element, attrs, ctrl) ->
      scope.$watch(
        -> scope.html
        -> element.text(scope.html)
        false
        )
      element.bind 'blur', ->
        scope.$apply ->
          scope.html = element.text()
          ctrl.$setViewValue element.html()

      ctrl.$render = (value) -> element.html(value)
  }
)
###

#@editor = ($scope) ->
#  $scope.editor = 'neal'




$ ->
  keybind = {
    65: 'a'
    66: 'b'
    67: 'c'
    68: 'd'
    69: 'e'
    70: 'f'
    71: 'g'
    72: 'h'
    73: 'i'
    74: 'j'
    75: 'k'
    76: 'l'
    77: 'm'
    78: 'n'
    79: 'o'
    80: 'p'
    81: 'q'
    82: 'r'
    83: 's'
    84: 't'
    85: 'u'
    86: 'v'
    87: 'w'
    188: ','
    190: '.'
  }
  #save the text to server everytime user enter someting.
 #$('#core_editor').bind 'input', ->
 #  marked_word = $('[meaning]').map((_x, y)-> $(y).attr('meaning'))
 #  $.ajax "/articles/#{gon.article_id}",
 #    data: {sense: marked_word.get(), html: $('#core_editor').html() }
 #    type: 'POST'
 #    beforeSend: (xhr) ->
 #      xhr.setRequestHeader("X-Http-Method-Override", "PUT")

  insert_after = (ref_node, new_node) ->
    ref_node.parentNode.insertBefore(new_node, ref_node.nextSibling)

  $('#core_editor').keydown (e) ->
    console.log e
    e.preventDefault()
    sel = window.getSelection()
    ran = sel.getRangeAt(0)
    node = sel.anchorNode
    #must get move_setp here, becuase reset nodeValue will set Offset to 0
    move_step = sel.anchorOffset
    
    switch e.keyCode
      #backspace
      when 17
        console.log 'Press ctrl key'
      when 8
        if node.nodeType == 3
          if node.length == 1 and node.parentNode.nodeName == "W"
            sel.collapse(node, move_step - 1)
            node.parentNode.remove()
          else
            node.nodeValue = node.nodeValue.substring(0, move_step - 1) + node.nodeValue.substring(move_step, node.length)
            sel.collapse(node, move_step - 1)
        else
          console.log 'd'
      #space
      when 32 
        if node.parentNode.nodeName != 'W' and node.textContent.match(/\w+/)
          ran.insertNode(document.createTextNode('\u00A0'))
          sel.modify('move', 'right', 'character')
          findAndReplaceDOMText(/\w+/, node, 'w')
        else if node.parentNode.nodeName == 'W'
          if node.length > move_step
            console.log 'middle'
          else
            console.log 'sb'
            space_node = document.createTextNode('\u00A0')
            insert_after node.parentNode, document.createTextNode('\u00A0')
            sel.modify('move', 'right', 'character')

      else 
        if jQuery.inArray(e.keyCode.toString(), Object.keys(keybind)) != -1
          to_be_insert = if e.shiftKey then String.fromCharCode(e.keyCode) else String.fromCharCode(e.keyCode).toLowerCase()
          if node.nodeType == 3# and node.parentNode.nodeName != 'WORD' and node.textContent.match(/\w+/)
            #findAndReplaceDOMText(/\w+/, node, 'word')
            node.nodeValue = node.nodeValue.substring(0, move_step) +
              to_be_insert + node.nodeValue.substring(move_step, node.length)
          else
            ran.insertNode(document.createTextNode(to_be_insert))
            
          sel.collapse(node, move_step + 1)

  ###
  $('#core_editor').keydown (e) ->
    console.log e
    e.preventDefault()
    sel = window.getSelection()
    sel.modify('move', 'forward', 'character')
    this.focus

    if e.keyCode == 32
      node = sel.anchorNode.parentNode
      range = sel.getRangeAt(0)
      new_node = document.createTextNode('\u00A0')
      if node.nodeName == "WORD"
        if $.inArray(sel.anchorNode.textContent, window.new_word_finder) == -1
          $(node).addClass('first_appear')
        e.preventDefault()
        $(new_node).insertAfter(node)
        sel.collapse(new_node, 1)
  ###
    

  $.ajax '/query/high',
    type: 'GET'
    success: (data) ->
      window.new_word_finder = data
      $('word').each (_index, elem) ->
        console.log $(elem).text()
        if $.inArray($(elem).text(), data) == -1 and $.inArray($(elem).text().toLowerCase(), data) == -1 and $(elem).text().search(/\w/) != -1
          $(elem).addClass("first_appear")

  $('#core_editor').delegate 'w', 'dblclick', ->
    $('.selected_word').removeClass('selected_word')
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
            $('#attr_pick').append("[#{s_elem.cat}]</div>")
            $(s_elem.sense).each (ss_index, ss_elem ) ->
              juggle = ss_elem.id
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


        

