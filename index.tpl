<!DOCTYPE html>
<html data-theme="light">
  <head>
    <title>Helm Charts</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/2.10.0/github-markdown.min.css" />
    <style>
      :root {
        --bg-color: #eaedef;
        --text-color: #333;
        --border-color: #d7d9dd;
        --svg-filter: none;
        --link-color: #007BFF;
      }
      [data-theme="dark"] {
        --bg-color: #333;
        --text-color: #eaedef;
        --border-color: #222;
        --svg-filter: invert(100%);
        --link-color: #87CEFA;
      }
      html, body {
        margin: 0px;
        padding: 5px;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol";
        font-size: 16px;
        line-height: 1.5;
        color: var(--text-color);
        background-color: var(--bg-color);
        -webkit-font-smoothing: antialiased; /* Add for Safari */
      }
      a {
        color: var(--text-color) !important;
        text-decoration: none !important;
      }
      .header {
        text-align: center;
        margin-bottom: 2em;
      }
      .markdown-body {
        box-sizing: border-box;
        min-width: 200px;
        margin: 0 auto;
        padding: 45px;
        background-color: var(--bg-color);
        color: var(--text-color);
      }
      @media (max-width: 767px) {
        .markdown-body {
          padding: 15px;
        }
      }
      .clippy {
        margin-top: -3px;
        position: relative;
        top: 3px;
      }
      .charts {
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
      }
      .chart {
        border-radius: 8px;
        overflow: hidden;
        border: 1px solid var(--border-color);
        transition: transform .2s ease, box-shadow .2s ease;
        background-color: var(--bg-color);
        width: 300px;
        margin: 10px;
        box-shadow: 0 2px 4px 0 rgba(0,0,0,0.2);
        cursor: pointer;
        -webkit-transform: scale(1);
        -webkit-transition: -webkit-transform .2s ease, box-shadow .2s ease;
      }
      .chart:hover {
        transform: scale(1.05);
        -webkit-transform: scale(1.05);
        box-shadow: 0 8px 16px 0 rgba(0,0,0,0.2);
      }
      .chart .icon {
        display: flex;
        justify-content: center;
        width: 100%;
        height: 100px;
        background-color: #fff;
        align-items: center;
      }
      .chart .icon img {
        max-height: 80%;
      }
      .chart .body {
        position: relative;
        display: flex;
        justify-content: center;
        flex: 1;
        border-top: 1px solid var(--border-color);
        padding: 0 1em;
        flex-direction: column;
        word-wrap: break-word;
        text-align: center;
      }
      .chart .body .info {
        word-wrap: break-word;
        text-align: center;
      }
      .chart .body .description {
        text-align: left;
      }
      .chart .body .chart-title {
        font-size: 1.2em;
        font-weight: bold;
        color: var(--link-color);
        padding: 0;
        margin: 0;
      }
    </style>
  </head>

  <body>
    <section class="markdown-body">
      <div class="header">
        <h1>Rock8s Helm Charts</h1>
        <p>rock8s community helm charts</p>
      </div>
      <div class="charts">
        {{range $key, $chartEntry := .Entries }}
          <a class="chart" href="https://artifacthub.io/packages/helm/rock8s/{{ (index $chartEntry 0).Name }}" title="https://artifacthub.io/packages/helm/rock8s/{{ (index $chartEntry 0).Name }}">
            <div class="icon">
              {{ if (index $chartEntry 0).Icon }}
                <img class="{{ (index $chartEntry 0).Name }}-item-logo" alt="{{ (index $chartEntry 0).Name }}'s logo" src="{{ (index $chartEntry 0).Icon }}">
              {{ else }}
                <img class="{{ (index $chartEntry 0).Name }}-item-logo" alt="{{ (index $chartEntry 0).Name }}'s logo" src="assets/placeholder.png">
              {{ end }}
            </div>
            <div class="body">
              <p class="info">
                <p class="chart-title">{{ (index $chartEntry 0).Name }}</p>
                ({{ (index $chartEntry 0).Version }}@{{ (index $chartEntry 0).AppVersion }})
              </p>
              <p class="description">
                {{ (index $chartEntry 0).Description }}
              </p>
            </div>
          </a>
        {{end}}
      </div>
    </section>
    <script>
      const toggleTheme = () => {
        const root = document.documentElement;
        const currentTheme = root.getAttribute('data-theme');
        root.setAttribute('data-theme', currentTheme === 'light' ? 'dark' : 'light');
      };
      document.addEventListener('keydown', (e) => {
        if (e.key === 't') {
          toggleTheme();
        }
      });
    </script>
  </body>
</html>
