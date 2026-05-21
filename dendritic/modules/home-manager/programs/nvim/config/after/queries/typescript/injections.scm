; extends

; queryRunner.query(`...`) — template literal
(call_expression
  function: (member_expression
    object: (identifier) @_obj
    property: (property_identifier) @_prop
    (#eq? @_obj "queryRunner")
    (#eq? @_prop "query"))
  arguments: [
    (arguments
      (template_string) @injection.content)
    (template_string) @injection.content
  ]
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children)
  (#set! injection.language "sql"))

; queryRunner.query('...') — single/double-quoted string
(call_expression
  function: (member_expression
    object: (identifier) @_obj
    property: (property_identifier) @_prop
    (#eq? @_obj "queryRunner")
    (#eq? @_prop "query"))
  arguments: [
    (arguments
      (string
        (string_fragment) @injection.content))
    (string
      (string_fragment) @injection.content)
  ]
  (#set! injection.language "sql"))
