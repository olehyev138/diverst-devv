/**
 *
 * Region Home Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import { Button, Typography, Paper, CardContent } from '@material-ui/core';

import { DiverstCSSGrid, DiverstCSSCell } from 'components/Shared/DiverstCSSGrid';
import { withStyles } from '@material-ui/core/styles';
import { ROUTES } from 'containers/Shared/Routes/constants';
import messages from 'containers/Region/messages';
import DiverstHTMLEmbedder from 'components/Shared/DiverstHTMLEmbedder';

const styles = theme => ({});

export function RegionHome({ classes, ...props }) {
  const description = (
    <DiverstHTMLEmbedder
      html={
        props.currentRegion
          ? props.currentRegion.description
          : ''
      }
    />
  );

  return (
    <DiverstCSSGrid
      columns={10}
      rows='auto auto auto auto 1fr'
      areas={[
        'description description  description  description  description  description  description  description  description  description',
      ]}
      rowGap='16px'
      columnGap='24px'
    >
      <DiverstCSSCell area='description'>{description}</DiverstCSSCell>
    </DiverstCSSGrid>
  );
}

RegionHome.propTypes = {
  classes: PropTypes.object,
  currentRegion: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles)
)(RegionHome);
