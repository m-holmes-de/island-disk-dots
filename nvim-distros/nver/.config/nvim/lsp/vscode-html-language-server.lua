return {
  cmd = { "vscode-html-language-server", "--stdio" },
  filetypes = { "html", "templ" },
  root_markers = {
    "package.json",
    ".git",
    "index.html",
  },
  settings = {
    html = {
      format = {
        templating = true,
        wrapLineLength = 120,
        wrapAttributes = "auto",
        indentHandlebars = false,
        indentInnerHtml = false,
        preserveNewLines = true,
        maxPreserveNewLines = 2,
        extraLiners = "head, body, /html",
        endWithNewline = true,
        insertFinalNewline = true,
        tabSize = 2,
        insertSpaces = true,
      },
      hover = {
        documentation = true,
        references = true,
      },
      completion = {
        attributeDefaultValue = "doublequotes",
      },
      validate = true,
      autoClosingTags = true,
      mirrorCursorOnMatchingTag = false,
      suggest = {
        html5 = true,
      },
      trace = {
        server = "off",
      },
    },
  },
}
