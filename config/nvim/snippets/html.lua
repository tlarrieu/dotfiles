---@diagnostic disable: undefined-global

return {
  s("index", fmt([[
  <!doctype html>
  <html lang="en">
    <head>
      <meta charset="UTF-8" />
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <meta name="viewport" content="width=device-width,initial-scale=1.0" />
      <title>{}</title>
    </head>
    <body>
      {}
    </body>
  </html>
  ]], { i(1, 'title'), i(0, 'content') })),

  s("meta", fmt('<meta {}="{}" />', { i(1, 'key'), i(0, 'value') })),
  s("title", fmt('<title>{}</title>', { i(0, 'title') })),
  s("h1", fmt('<h1>{}{}</h1>', { sel(), i(0) })),
  s("h2", fmt('<h2>{}{}</h2>', { sel(), i(0) })),
  s("h3", fmt('<h3>{}{}</h3>', { sel(), i(0) })),
  s("h4", fmt('<h4>{}{}</h4>', { sel(), i(0) })),
  s("h5", fmt('<h5>{}{}</h5>', { sel(), i(0) })),
  s("h6", fmt('<h6>{}{}</h6>', { sel(), i(0) })),
  s("p", fmt('<p>{}{}</p>', { sel(), i(0) })),
  s("div", fmt('<div>{}{}</div>', { sel(), i(0) })),
  s("span", fmt('<span>{}{}</span>', { sel(), i(0) })),
  s("ol", fmt('<ol>{}{}</ol>', { sel(), i(0) })),
  s("ul", fmt('<ul>{}{}</ul>', { sel(), i(0) })),
  s("li", fmt('<li>{}{}</li>', { sel(), i(0) })),
  s("img", fmt('<img src="{}" />', { i(0, 'src') })),
}, {
}
