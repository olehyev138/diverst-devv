import { createGlobalStyle } from 'styled-components';

const GlobalStyle = createGlobalStyle`
  html,
  body {
    height: 100%;
    width: 100%;
  }

  body {
    font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
  }

  body.fontLoaded {
    font-family: 'Open Sans', 'Helvetica Neue', Helvetica, Arial, sans-serif;
  }

  #app {
    background-color: #fafafa;
    min-height: 100%;
    min-width: 100%;
  }

  p,
  label {
    font-family: Georgia, Times, 'Times New Roman', serif;
    line-height: 1.5em;
  }
  
  .extra-large-img {
    width: 200px;
    height: auto;
  }
  
  .large-img {
    width: 175px;
    height: auto;
  }
  
  .medium-img {
    width: 150px;
    height: auto;
  }
  
  .small-img {
    width: 125px;
    height: auto;
  }
  
  .tiny-img {
    width: 100px;
    height: auto;
  }
`;

export default GlobalStyle;
