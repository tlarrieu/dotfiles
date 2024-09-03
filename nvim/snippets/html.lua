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
  s("h1", fmt('<h1>{}</h1>', { i(0, 'title') })),
  s("h2", fmt('<h2>{}</h2>', { i(0, 'title') })),
  s("h3", fmt('<h3>{}</h3>', { i(0, 'title') })),
  s("h4", fmt('<h4>{}</h4>', { i(0, 'title') })),
  s("h5", fmt('<h5>{}</h5>', { i(0, 'title') })),
  s("h6", fmt('<h6>{}</h6>', { i(0, 'title') })),
  s("div", fmt('<div>{}</div>', { i(0, 'content') })),
  s("span", fmt('<span>{}</span>', { i(0, 'content') })),
  s("img", fmt('<img src="{}" />', { i(0, 'src') })),
}, {
}
