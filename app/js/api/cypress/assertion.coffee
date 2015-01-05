## attach to Cypress global

do (Cypress, _) ->

  bRe          = /(\[b\])(.+)(\[\\b\])/
  bTagOpen     = /\[b\]/g
  bTagClosed   = /\[\\b\]/g

  Cypress.Assertion = {
    assert: (passed, message, value, actual, expected) ->
      ## if this is a jquery object and its true
      ## then remove all the 'but's and replace with 'and'
      ## also just think about slicing off everything after a comma?
      message = message.split("but").join("and") if message and passed

      obj = @parseValueActualAndExpected(value, actual, expected)

      if value and value[0] and _.isElement(value[0])
        obj.$el = value

      _.extend obj,
        name:     "assert"
        type:     "assertion"
        message:  message
        passed:   passed
        selector: value.selector
        onRender: ($row) =>
          klass = if passed then "passed" else "failed"
          $row.addClass "command-assertion-#{klass}"

          ## converts [b] string tags into real elements
          @convertTags($row)

      ## think about completely gutting the whole object toString
      ## which chai does by default, its so ugly and worthless

      Cypress.log obj

      return Cypress

    convertTags: ($row) ->
      html = $row.html()

      ## if matches were found
      if bRe.test(html)
        html = html
          .replace(bTagOpen, ": <strong>")
          .replace(bTagClosed, "</strong>")
          .split(" :").join(":")

        $row.html(html)

    ## Rules:
    ## 1. always remove value
    ## 2. if value is a jquery object set a subject
    ## 3. if actual is undefined or its not expected remove both actual + expected
    parseValueActualAndExpected: (value, actual, expected) ->
      obj = {actual: actual, expected: expected}

      if value instanceof $
        obj.subject = value

        if _.isUndefined(actual) or actual isnt expected
          delete obj.actual
          delete obj.expected

      obj
  }

  ## method proxy shortcut
  Cypress.assert = ->
    Cypress.Assertion.assert.apply(Cypress.Assertion, arguments)