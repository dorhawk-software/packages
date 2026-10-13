"""The start page (site/index.html) with each app of apps.json in its list,
and how to install it, on stdout. Used by scripts/build-repo.sh."""
import html
import json
import pathlib

root = pathlib.Path(__file__).resolve().parent.parent
apps = json.loads((root / "apps.json").read_text())
items = "\n".join(
    f'      <li><b>{html.escape(a["package"])}</b><span><a href="{html.escape(a["url"])}">'
    f'{html.escape(a["name"])}</a>: {html.escape(a["summary"])}<br>'
    f'<code>sudo apt install {html.escape(a["package"])}</code> or '
    f'<code>sudo dnf install {html.escape(a["package"])}</code></span></li>'
    for a in apps
)
page = (root / "site" / "index.html").read_text()
assert "<!-- apps -->" in page, "the page's list has no <!-- apps --> mark"
print(page.replace("<!-- apps -->", items), end="")
