module.exports = (schema, options) ->
  options = { private: false } unless options

  schema.eachPath (path) ->
    # Ignore private
    return if path[0] is '_' and options.private is false

    camelCase = underscoreToCamelCase(path)
    if camelCase != path
      if schema.virtualpath(camelCase) is undefined or schema.virtualpath(camelCase).getters.length == 0
        schema.virtual(camelCase).get ->
          @[path]
      unless schema.virtualpath(camelCase).setters > []
        schema.virtual(camelCase).set (value) ->
          @[path] = value

underscoreToCamelCase = (string)->
  string = string.substr(1) if string[0] is '_'
  string.replace(/(\_[a-z])/g, (g) ->
    return g[1].toUpperCase().replace('_','')
  )