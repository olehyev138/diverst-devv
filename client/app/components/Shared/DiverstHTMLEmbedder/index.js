import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles, withTheme } from '@material-ui/core/styles';
import { Grid } from '@material-ui/core';
import Interweave from 'interweave';

const styles = theme => ({
});

export function DiverstHTMLEmbedder({ html, gridProps, interweaveProps }) {
  return (
    <Grid
      container
      {...gridProps}
      spacing={0}
      direction='column'
      alignItems='center'
      justify='center'
    >
      <Grid item>
        <Interweave
          content={html}
          {...interweaveProps}
        />
      </Grid>
    </Grid>
  );
}

DiverstHTMLEmbedder.propTypes = {
  gridProps: PropTypes.shape({
    spacing: PropTypes.number,
    direction: PropTypes.string,
    alignItems: PropTypes.string,
    justify: PropTypes.string,
  }),
  interweaveProps: PropTypes.shape({
    allowAttributes: PropTypes.bool,
    allowElements: PropTypes.bool,
    allowList: PropTypes.arrayOf(PropTypes.string),
    blockList: PropTypes.arrayOf(PropTypes.string),
    containerTagName: PropTypes.string,
    disableLineBreaks: PropTypes.bool,
    emptyContent: PropTypes.node,
    escapeHtml: PropTypes.bool,
    noHtml: PropTypes.bool,
    noHtmlExceptMatchers: PropTypes.bool,
    noWrap: PropTypes.bool,
    tagName: PropTypes.string,
    transform: PropTypes.func,
  }),
  html: PropTypes.string,
};

export default compose(
  memo,
  withStyles(styles),
  withTheme,
)(DiverstHTMLEmbedder);
