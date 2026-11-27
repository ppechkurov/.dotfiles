; extends

; Query("SELECT ...")
((call_expression
  function: (selector_expression
    field: (field_identifier) @_sql_method)
  arguments: (argument_list
    .
    [(interpreted_string_literal) (raw_string_literal)] @injection.content))
  (#match? @_sql_method "^(Query|QueryRow|Exec|Prepare)$")
  (#set! injection.language "sql")
  (#set! injection.include-children)
  (#offset! @injection.content 0 1 0 -1))

; QueryContext(ctx, "SELECT ...")
((call_expression
  function: (selector_expression
    field: (field_identifier) @_sql_method)
  arguments: (argument_list
    .
    (_)
    .
    [(interpreted_string_literal) (raw_string_literal)] @injection.content))
  (#match? @_sql_method "^(QueryContext|QueryRowContext|ExecContext|PrepareContext)$")
  (#set! injection.language "sql")
  (#set! injection.include-children)
  (#offset! @injection.content 0 1 0 -1))
