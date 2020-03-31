export function addScript(url, argumentOptions = {}) {
  if (!Array.from(document.getElementsByTagName('script')).find(script => script.src === url)) {
    const script = document.createElement('script');
    const defaultOptions = {
      async: true,
    };

    const options = {
      ...defaultOptions,
      ...argumentOptions
    };

    script.src = url;

    for (const [key, value] of Object.entries(options))
      script[key] = value;

    document.body.appendChild(script);
  }
}
