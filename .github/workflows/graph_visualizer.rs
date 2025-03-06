const HTML_PREFIX: &str = r#"
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Graph</title>
</head>
<body>
  <script src="https://cdn.jsdelivr.net/npm/viz.js@2.1.2-pre.1/viz.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/viz.js@2.1.2-pre.1/full.render.js"></script>
  <script>
"#;
const HTML_SUFFIX: &str = r#"
  </script>
</body>
</html>
"#;

fn render_html(
    filename: &AbsoluteSystemPath,
    engine: &Engine,
    single_package: bool,
) -> Result<(), Error> {
    let mut opts = OpenOptions::new();
    opts.truncate(true).create(true).write(true);
    let mut file = filename
        .open_with_options(opts)
        .map_err(Error::GraphOutput)?;
    let mut graph_buffer = Vec::new();
    render_dot_graph(&mut graph_buffer, engine, single_package)?;
    let graph_string = String::from_utf8(graph_buffer).expect("graph rendering should be UTF-8");

    file.write_all(HTML_PREFIX.as_bytes())
        .map_err(Error::GraphOutput)?;
    write!(
        &mut file,
        "const s = `{graph_string}`.replace(/\\_\\_\\_ROOT\\_\\_\\_/g, \
         \"Root\").replace(/\\[root\\]/g, \"\");new Viz().renderSVGElement(s).then(el => \
         document.body.appendChild(el)).catch(e => console.error(e));"
    )
    .map_err(Error::GraphOutput)?;
    file.write_all(HTML_SUFFIX.as_bytes())
        .map_err(Error::GraphOutput)?;
    Ok(())
}
