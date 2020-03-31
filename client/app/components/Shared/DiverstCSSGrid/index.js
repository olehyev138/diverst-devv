import React from 'react';

import { lighten, withStyles } from '@material-ui/core/styles';
import { Grid, Cell } from 'styled-css-grid';

const DiverstCSSGrid = withStyles(theme => ({
  flex: 1
}))(Grid);

const TempDiverstCSSCell = withStyles(theme => ({
  border: '1px solid black',
  'line-height': 1,
}))(Cell);

const DiverstCSSCell = props => <TempDiverstCSSCell center {...props} />;

export {
  DiverstCSSGrid,
  DiverstCSSCell,
};
