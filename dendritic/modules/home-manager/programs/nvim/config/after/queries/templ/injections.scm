; extends

; Backtick raw strings:  data-on:submit={ `...` }
((attribute
   name: (attribute_name) @_attr_name
   value: (expression
     (raw_string_literal
       (raw_string_literal_content) @injection.content)))
 (#lua-match? @_attr_name "^data%-on")
 (#set! injection.language "javascript"))

; Double-quoted strings:  data-on:submit="..."
((attribute
   name: (attribute_name) @_attr_name
   value: (expression
     (interpreted_string_literal
       (interpreted_string_literal_content) @injection.content)))
 (#lua-match? @_attr_name "^data%-on")
 (#set! injection.language "javascript"))
